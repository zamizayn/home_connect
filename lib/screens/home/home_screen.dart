import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../constants/app_colors.dart';
import '../chat/chat_details_screen.dart';
import '../chat/new_chat_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.red.withOpacity(0.2)),
              ),
              child: const Icon(
                Icons.forum_outlined,
                color: Colors.red,
                size: 24,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Home Connect',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black, size: 28),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black, size: 28),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  _TabItem(label: 'All', isSelected: true),
                  SizedBox(width: 12),
                  _TabItem(label: 'Unread', isSelected: false),
                  SizedBox(width: 12),
                  _TabItem(label: 'Groups', isSelected: false),
                ],
              ),
            ),
            _announcementSection(),
            const SizedBox(height: 20),
            _chatList(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewChatScreen()),
          );
        },
        backgroundColor: AppColors.primary,
        child: SvgPicture.asset('icons/chat.svg'),
      ),
    );
  }

  Widget _announcementSection() {
    return SizedBox(
      height: 160,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _announcementCard(
            title: 'HR Announcement',
            content: 'New Company policy on work from home',
            tag: 'WFH',
            bg: const Color(0xFFFFF9C4),
          ),
          const SizedBox(width: 16),
          _announcementCard(
            title: 'HR Announcement',
            content: 'Tomorrow at office',
            tag: 'Work',
            bg: const Color(0xFFFCE4EC),
          ),
        ],
      ),
    );
  }

  Widget _announcementCard({
    required String title,
    required String content,
    required String tag,
    required Color bg,
  }) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(
                    color: Colors.indigo,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Row(
            children: [
              Icon(Icons.access_time_filled, color: Colors.grey[600], size: 20),
              const SizedBox(width: 8),
              Text(
                'Today Update',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chatList(BuildContext context) {
    final List<Map<String, dynamic>> chats = [
      {
        'name': 'Priya',
        'msg': 'Okay👍',
        'time': '10:53 am',
        'unread': 0,
        'isSent': true,
        'isRead': true,
      },
      {
        'name': 'Rahul',
        'msg': 'I have shared the documents',
        'time': '10:53 am',
        'unread': 2,
        'isSent': false,
        'isRead': false,
      },
      {
        'name': 'Machat Group',
        'msg': 'The due date is tomorrow.',
        'time': '10:53 am',
        'unread': 16,
        'isSent': false,
        'isRead': false,
      },
      {
        'name': 'Sumesh',
        'msg': 'I\'ll see you in a bit',
        'time': '10:53 am',
        'unread': 0,
        'isSent': true,
        'isRead': true,
      },
      {
        'name': 'Robert Fox',
        'msg': 'I\'ll see you in a bit',
        'time': '10:53 am',
        'unread': 1,
        'isSent': false,
        'isRead': false,
      },
      {
        'name': 'Arun',
        'msg': 'Are you free?',
        'time': 'Yesterday',
        'unread': 0,
        'isSent': true,
        'isRead': false,
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        return ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatDetailsScreen(name: chat['name']),
              ),
            );
          },
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 4,
          ),
          leading: CircleAvatar(
            radius: 28,
            backgroundColor: Colors.blue[100],
            child: Text(chat['name'][0]),
          ),
          title: Text(
            chat['name'],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          subtitle: Row(
            children: [
              if (chat['isSent'] == true) ...[
                SvgPicture.asset(
                  'icons/done_all.svg',
                  width: 16,
                  colorFilter: ColorFilter.mode(
                    chat['isRead'] ? Colors.blue : Colors.grey,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 4),
              ],
              Expanded(
                child: Text(
                  chat['msg'],
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          trailing: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                chat['time'],
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              if (chat['unread'] > 0)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    chat['unread'] > 9 ? '16+' : chat['unread'].toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  const _TabItem({required this.label, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: isSelected ? null : Border.all(color: const Color(0xFFF5F5F5)),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }
}
