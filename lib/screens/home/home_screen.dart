import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../constants/app_colors.dart';
import '../chat/chat_details_screen.dart';
import '../chat/new_chat_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onAppBarChanged;
  const HomeScreen({super.key, this.onAppBarChanged});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSearching = false;
  String _searchQuery = '';
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _chats = [
    {
      'name': 'Priya',
      'msg': 'Okay👍',
      'time': '10:53 am',
      'unread': 0,
      'isSent': true,
      'isRead': true,
      'isGroup': false,
    },
    {
      'name': 'Rahul',
      'msg': 'I have shared the documents',
      'time': '10:53 am',
      'unread': 2,
      'isSent': false,
      'isRead': false,
      'isGroup': false,
    },

    {
      'name': 'Sales Group',
      'msg': 'Jeena : Complete bug rep......',
      'time': '10:53 am',
      'unread': 16,
      'isSent': false,
      'isRead': false,
      'isGroup': true,
    },
    {
      'name': 'Sumesh',
      'msg': 'I\'ll see you in a bit',
      'time': '10:53 am',
      'unread': 0,
      'isSent': true,
      'isRead': true,
      'isGroup': false,
    },
    {
      'name': 'Robert Fox',
      'msg': 'I\'ll see you in a bit',
      'time': '10:53 am',
      'unread': 1,
      'isSent': false,
      'isRead': false,
      'isGroup': false,
    },
    {
      'name': 'Arun',
      'msg': 'Are you free?',
      'time': 'Yesterday',
      'unread': 0,
      'isSent': true,
      'isRead': false,
      'isGroup': false,
    },
  ];

  void _markAllAsRead() {
    setState(() {
      for (var chat in _chats) {
        chat['unread'] = 0;
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  _TabItem(
                    label: 'All',
                    isSelected: _selectedCategory == 'All',
                    onTap: () => setState(() => _selectedCategory = 'All'),
                  ),
                  const SizedBox(width: 12),
                  _TabItem(
                    label: 'Unread',
                    isSelected: _selectedCategory == 'Unread',
                    onTap: () => setState(() => _selectedCategory = 'Unread'),
                  ),
                  const SizedBox(width: 12),
                  _TabItem(
                    label: 'Groups',
                    isSelected: _selectedCategory == 'Groups',
                    onTap: () => setState(() => _selectedCategory = 'Groups'),
                  ),
                ],
              ),
            ),
            _announcementSection(),
            const SizedBox(height: 20),
            _chatList(context),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget getAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: _isSearching
          ? TextField(
              controller: _searchController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Search...',
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 18),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            )
          : Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    );
                  },
                  child: Container(
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
          icon: Icon(
            _isSearching ? Icons.close : Icons.search,
            color: Colors.black,
            size: 28,
          ),
          onPressed: () {
            setState(() {
              if (_isSearching) {
                _isSearching = false;
                _searchQuery = '';
                _searchController.clear();
              } else {
                _isSearching = true;
              }
            });
            widget.onAppBarChanged?.call();
          },
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.black, size: 28),
          onSelected: (value) {
            if (value == 'profile') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            } else if (value == 'read_all') {
              _markAllAsRead();
            }
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          offset: const Offset(0, 50),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'read_all',
              child: Text('Read All', style: TextStyle(fontSize: 14)),
            ),
            PopupMenuItem(
              value: 'profile',
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.check, size: 18, color: Colors.black),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget getFAB(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NewChatScreen()),
        );
      },
      backgroundColor: AppColors.primary,
      child: SvgPicture.asset('icons/chat.svg'),
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
    final filteredChats = _chats.where((chat) {
      // Category Filter
      bool categoryMatch = true;
      if (_selectedCategory == 'Unread') {
        categoryMatch = (chat['unread'] as int) > 0;
      } else if (_selectedCategory == 'Groups') {
        categoryMatch = chat['isGroup'] == true;
      }

      // Search Filter
      final name = chat['name'].toString().toLowerCase();
      final msg = chat['msg'].toString().toLowerCase();
      final query = _searchQuery.toLowerCase();
      bool searchMatch = name.contains(query) || msg.contains(query);

      return categoryMatch && searchMatch;
    }).toList();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredChats.length,
      itemBuilder: (context, index) {
        final chat = filteredChats[index];
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
  final VoidCallback onTap;
  const _TabItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: isSelected
              ? null
              : Border.all(color: const Color(0xFFF5F5F5)),
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
      ),
    );
  }
}
