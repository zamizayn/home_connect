import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

enum MessageType { text, file, audio, image }

class ChatMessage {
  final String content;
  final String time;
  final bool isSent;
  final MessageType type;
  final String? fileName;
  final String? fileSize;
  final String? localPath;
  bool isPlaying;
  Duration audioDuration;
  Duration audioPosition;

  ChatMessage({
    required this.content,
    required this.time,
    required this.isSent,
    this.type = MessageType.text,
    this.fileName,
    this.fileSize,
    this.localPath,
    this.isPlaying = false,
    this.audioDuration = Duration.zero,
    this.audioPosition = Duration.zero,
  });
}

class ChatDetailsScreen extends StatefulWidget {
  final String name;
  const ChatDetailsScreen({super.key, required this.name});

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      content: 'Hey Ethan, do you have the documents?',
      time: '2:00pm',
      isSent: false,
    ),
    ChatMessage(
      content: 'Yes I do, sending right now.',
      time: '2:00pm',
      isSent: true,
    ),
    ChatMessage(content: 'Okay', time: '2:00pm', isSent: true),
    ChatMessage(
      content: 'Imp.PDF',
      time: '2:00pm',
      isSent: false,
      type: MessageType.file,
      fileName: 'Imp.PDF',
      fileSize: '2 pages 835kB PDF',
    ),
    ChatMessage(content: 'Thank You.', time: '2:00pm', isSent: true),
  ];

  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final ImagePicker _imagePicker = ImagePicker();
  bool _isRecording = false;
  Timer? _recordTimer;
  int _recordDuration = 0;
  bool _isCancelled = false;
  double _dragOffset = 0.0;
  bool _showSendButton = false;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration>? _durationSubscription;
  StreamSubscription<void>? _playerCompleteSubscription;
  ChatMessage? _currentlyPlayingMessage;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
    _messageController.addListener(() {
      if (mounted) {
        setState(() {
          _showSendButton = _messageController.text.trim().isNotEmpty;
        });
      }
    });
  }

  void _initAudioPlayer() {
    _positionSubscription = _audioPlayer.onPositionChanged.listen((p) {
      if (_currentlyPlayingMessage != null) {
        setState(() {
          _currentlyPlayingMessage!.audioPosition = p;
        });
      }
    });

    _durationSubscription = _audioPlayer.onDurationChanged.listen((d) {
      if (_currentlyPlayingMessage != null) {
        setState(() {
          _currentlyPlayingMessage!.audioDuration = d;
        });
      }
    });

    _playerCompleteSubscription = _audioPlayer.onPlayerComplete.listen((_) {
      if (_currentlyPlayingMessage != null) {
        setState(() {
          _currentlyPlayingMessage!.isPlaying = false;
          _currentlyPlayingMessage!.audioPosition = Duration.zero;
          _currentlyPlayingMessage = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final directory = await getApplicationDocumentsDirectory();
        final path =
            '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

        const config = RecordConfig();
        await _audioRecorder.start(config, path: path);

        setState(() {
          _isRecording = true;
          _isCancelled = false;
          _dragOffset = 0.0;
          _recordDuration = 0;
        });
        _startTimer();
      }
    } catch (e) {
      debugPrint('Error starting recording: $e');
    }
  }

  void _startTimer() {
    _recordTimer?.cancel();
    _recordTimer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        _recordDuration++;
      });
    });
  }

  void _stopTimer() {
    _recordTimer?.cancel();
  }

  Future<void> _stopRecording({bool cancel = false}) async {
    try {
      _stopTimer();
      final path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
      });

      if (!cancel && path != null) {
        _addMessage(
          ChatMessage(
            content: 'Audio message',
            time: _getCurrentTime(),
            isSent: true,
            type: MessageType.audio,
            localPath: path,
          ),
        );
      } else if (cancel && path != null) {
        // Delete the recorded file if cancelled
        final file = File(path);
        if (await file.exists()) {
          await file.delete();
        }
      }
    } catch (e) {
      debugPrint('Error stopping recording: $e');
    }
  }

  Future<void> _playAudio(ChatMessage message) async {
    if (message.localPath == null) return;

    if (message.isPlaying) {
      await _audioPlayer.pause();
      setState(() {
        message.isPlaying = false;
      });
    } else {
      if (_currentlyPlayingMessage != null &&
          _currentlyPlayingMessage != message) {
        _currentlyPlayingMessage!.isPlaying = false;
        _currentlyPlayingMessage!.audioPosition = Duration.zero;
      }

      await _audioPlayer.play(DeviceFileSource(message.localPath!));
      setState(() {
        message.isPlaying = true;
        _currentlyPlayingMessage = message;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: source);
      if (image != null) {
        _addMessage(
          ChatMessage(
            content: 'Image',
            time: _getCurrentTime(),
            isSent: true,
            type: MessageType.image,
            localPath: image.path,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
    if (mounted) Navigator.pop(context);
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        PlatformFile file = result.files.first;
        _addMessage(
          ChatMessage(
            content: file.name,
            time: _getCurrentTime(),
            isSent: true,
            type: MessageType.file,
            fileName: file.name,
            fileSize: '${(file.size / 1024).toStringAsFixed(1)} KB',
            localPath: file.path,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
    }
    if (mounted) Navigator.pop(context);
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'pm' : 'am'}';
  }

  void _addMessage(ChatMessage message) {
    setState(() {
      _messages.add(message);
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    _addMessage(
      ChatMessage(
        content: _messageController.text.trim(),
        time: _getCurrentTime(),
        isSent: true,
      ),
    );
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.blue[100],
              child: Text(widget.name[0]),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const Row(
                  children: [
                    CircleAvatar(radius: 4, backgroundColor: Colors.green),
                    SizedBox(width: 4),
                    Text(
                      'Online',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Monday 5:34 PM',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                if (message.type == MessageType.file) {
                  return _fileMessage(message);
                } else if (message.type == MessageType.audio) {
                  return _audioMessage(message);
                } else if (message.type == MessageType.image) {
                  return _imageMessage(message);
                }
                return message.isSent
                    ? _sentMessage(message.content, message.time, true)
                    : _receivedMessage(message.content, message.time);
              },
            ),
          ),
          _messageInputField(),
        ],
      ),
    );
  }

  Widget _receivedMessage(String msg, String time) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16, right: 80),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: Color(0xFFFFF9C4),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              msg,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sentMessage(String msg, String time, bool isRead) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16, left: 80),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: Color(0xFFF5F5F5),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              msg,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  time,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
                const SizedBox(width: 4),
                if (isRead)
                  const Icon(Icons.done_all, size: 14, color: Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _fileMessage(ChatMessage message) {
    return Align(
      alignment: message.isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 16,
          left: message.isSent ? 80 : 0,
          right: message.isSent ? 0 : 80,
        ),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.amber[100],
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.picture_as_pdf,
                color: Colors.red,
                size: 40,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message.fileName ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  message.fileSize ?? '',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  message.time,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageMessage(ChatMessage message) {
    return Align(
      alignment: message.isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 16,
          left: message.isSent ? 80 : 0,
          right: message.isSent ? 0 : 80,
        ),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Image.file(
              File(message.localPath!),
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  message.time,
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _audioMessage(ChatMessage message) {
    double progress = 0.0;
    if (message.audioDuration.inMilliseconds > 0) {
      progress =
          message.audioPosition.inMilliseconds /
          message.audioDuration.inMilliseconds;
    }

    return Align(
      alignment: message.isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 16,
          left: message.isSent ? 60 : 0,
          right: message.isSent ? 0 : 60,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: message.isSent
              ? const Color(0xFFF5F5F5)
              : const Color(0xFFFFF9C4),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(message.isSent ? 20 : 0),
            bottomRight: Radius.circular(message.isSent ? 0 : 20),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => _playAudio(message),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  message.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.black,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: List.generate(15, (index) {
                    double height = 3 + (index % 5) * 3.0;
                    bool isPlayed = (index / 15) <= progress;
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      width: 3,
                      height: height,
                      decoration: BoxDecoration(
                        color: isPlayed
                            ? Colors.black
                            : Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      message.time,
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                    const SizedBox(width: 50),
                    Text(
                      _formatDuration(
                        message.isPlaying
                            ? message.audioPosition
                            : message.audioDuration,
                      ),
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration == Duration.zero) return '0:12';
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  Widget _messageInputField() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Expanded(
              child: _isRecording
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          const Icon(Icons.mic, color: Colors.red, size: 22),
                          const SizedBox(width: 8),
                          Text(
                            _formatRecordDuration(_recordDuration),
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: _recordDuration % 2 == 0 ? 1.0 : 0.5,
                            child: const Text(
                              '< Slide to cancel',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    )
                  : TextField(
                      controller: _messageController,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: const InputDecoration(
                        hintText: 'Write your message',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
            ),
            if (!_isRecording)
              IconButton(
                icon: const Icon(Icons.attach_file, color: Colors.grey),
                onPressed: _showAttachmentOptions,
              ),
            GestureDetector(
              onLongPressStart: (_) =>
                  _showSendButton ? null : _startRecording(),
              onLongPressEnd: (_) {
                if (_showSendButton) return;
                if (_isCancelled) {
                  _stopRecording(cancel: true);
                } else {
                  setState(() {
                    _dragOffset = 0;
                  });
                }
              },
              onLongPressMoveUpdate: (details) {
                if (_isRecording) {
                  setState(() {
                    _dragOffset = details.localPosition.dx;
                    if (_dragOffset < -100) {
                      _isCancelled = true;
                    }
                  });
                }
              },
              onTap: () {
                if (_showSendButton) {
                  _sendMessage();
                } else if (_isRecording) {
                  _stopRecording(cancel: false);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Hold to record audio')),
                  );
                }
              },
              child: Transform.translate(
                offset: Offset(_dragOffset < 0 ? _dragOffset : 0, 0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (_isRecording)
                      TweenAnimationBuilder(
                        tween: Tween(begin: 1.0, end: 1.4),
                        duration: const Duration(milliseconds: 500),
                        builder: (context, double value, child) {
                          return Container(
                            width: 40 * value,
                            height: 40 * value,
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                          );
                        },
                      ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _isRecording || _showSendButton
                            ? Colors.black
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        _isRecording || _showSendButton
                            ? 'icons/sendg.svg'
                            : 'icons/microphone-2.svg',
                        width: _isRecording || _showSendButton ? 20 : 24,
                        colorFilter: ColorFilter.mode(
                          _isRecording || _showSendButton
                              ? Colors.white
                              : Colors.grey,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatRecordDuration(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(1, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _attachmentType(
                  Icons.insert_drive_file,
                  'Document',
                  Colors.blue,
                  _pickFile,
                ),
                _attachmentType(
                  Icons.camera_alt,
                  'Camera',
                  Colors.pink,
                  () => _pickImage(ImageSource.camera),
                ),
                _attachmentType(
                  Icons.image,
                  'Gallery',
                  Colors.purple,
                  () => _pickImage(ImageSource.gallery),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _attachmentType(Icons.headset, 'Audio', Colors.orange, () {}),
                _attachmentType(
                  Icons.location_on,
                  'Location',
                  Colors.green,
                  () {},
                ),
                _attachmentType(
                  Icons.person,
                  'Contact',
                  Colors.blueAccent,
                  () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _attachmentType(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
