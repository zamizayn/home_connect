import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class NewChatScreen extends StatelessWidget {
  const NewChatScreen({super.key});

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
        title: const Text(
          'New Chat',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F9F9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.search, color: Colors.grey, size: 24),
                        SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search Names, Addresses',
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(Icons.filter_list, color: Colors.black),
                ),
              ],
            ),
          ),
          Expanded(child: _contactList()),
        ],
      ),
    );
  }

  Widget _contactList() {
    final List<Map<String, String>> contacts = [
      {'name': 'Priya', 'role': 'HRM Department'},
      {'name': 'Rahul', 'role': 'Gold Loan'},
      {'name': 'Machat Group', 'role': 'Software Developing'},
      {'name': 'Sumesh', 'role': 'HRM Department'},
      {'name': 'Robert Fox', 'role': 'Gold Loan'},
      {'name': 'Jerome Bell', 'role': 'Gold Loan'},
      {'name': 'Cameron Williamson', 'role': 'Gold Loan'},
    ];

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 20),
      itemCount: contacts.length,
      separatorBuilder: (context, index) =>
          const Divider(height: 1, indent: 80),
      itemBuilder: (context, index) {
        final contact = contacts[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 4,
          ),
          leading: CircleAvatar(
            radius: 28,
            backgroundColor: Colors.blue[100],
            child: Text(contact['name']![0]),
          ),
          title: Text(
            contact['name']!,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          subtitle: Text(
            contact['role']!,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          trailing: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.withOpacity(0.5)),
            ),
          ),
        );
      },
    );
  }
}
