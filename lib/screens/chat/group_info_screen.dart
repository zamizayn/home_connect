import 'package:flutter/material.dart';
import 'group_media_docs_screen.dart';

class GroupInfoScreen extends StatelessWidget {
  final String groupName;
  const GroupInfoScreen({super.key, required this.groupName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9F9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Group Info',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _groupHeader(),
            const SizedBox(height: 30),
            _mediaDocsSection(context),
            const SizedBox(height: 20),
            _membersSection(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _groupHeader() {
    return Column(
      children: [
        Text(
          groupName,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          '100 Members',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 20),
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.purple[50],
          child: Text(
            groupName[0],
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.purple,
            ),
          ),
        ),
      ],
    );
  }

  Widget _mediaDocsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GroupMediaDocsScreen(title: groupName),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Row(
            children: [
              Icon(Icons.image_outlined, color: Colors.black, size: 28),
              SizedBox(width: 16),
              Text(
                'Media, docs',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Spacer(),
              Text('76', style: TextStyle(fontSize: 16, color: Colors.grey)),
              SizedBox(width: 4),
              Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _membersSection() {
    final List<Map<String, dynamic>> members = [
      {
        'name': 'Rahul',
        'dept': 'Gold Loan',
        'role': 'You',
        'image':
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=200&auto=format&fit=crop',
      },
      {
        'name': 'Priya',
        'dept': 'HRM Department',
        'role': 'Group Admin',
        'image':
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=200&auto=format&fit=crop',
      },
      {
        'name': 'Jerome Bell',
        'dept': 'Gold Loan',
        'role': null,
        'image':
            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=200&auto=format&fit=crop',
      },
      {
        'name': 'Sumesh',
        'dept': 'HRM Department',
        'role': null,
        'image':
            'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?q=80&w=200&auto=format&fit=crop',
      },
      {
        'name': 'Robert Fox',
        'dept': 'Gold Loan',
        'role': null,
        'image':
            'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?q=80&w=200&auto=format&fit=crop',
      },
      {
        'name': 'Robert Fox',
        'dept': 'Gold Loan',
        'role': null,
        'image':
            'https://images.unsplash.com/photo-1527980965255-d3b416303d12?q=80&w=200&auto=format&fit=crop',
      },
      {
        'name': 'Robert Fox',
        'dept': 'Gold Loan',
        'role': null,
        'image':
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=200&auto=format&fit=crop',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...members.map((member) => _memberItem(member)),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {},
            child: const Text(
              'View All (80 More)',
              style: TextStyle(
                color: Color(0xFF4CAF50),
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _memberItem(Map<String, dynamic> member) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage(member['image']),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  member['dept'],
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          if (member['role'] != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: member['role'] == 'You'
                    ? const Color(0xFFFFF9C4)
                    : const Color(0xFF4CAF50),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                member['role'],
                style: TextStyle(
                  color: member['role'] == 'You' ? Colors.black : Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
