import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'preview_widgets.dart';

class ProfileBottomSheet extends StatelessWidget {
  final String name;
  final ScrollController? scrollController;
  const ProfileBottomSheet({
    super.key,
    required this.name,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            _header(),
            const SizedBox(height: 24),
            TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorColor: Colors.black,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorWeight: 3,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              tabs: const [
                Tab(text: 'Media'),
                Tab(text: 'Docs'),
                Tab(text: 'Groups'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [_mediaTab(), _docsTab(), _groupsTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.blue[100],
            child: Text(
              name[0],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Row(
                children: [
                  CircleAvatar(radius: 4, backgroundColor: Colors.green),
                  SizedBox(width: 6),
                  Text(
                    'Online',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _mediaTab() {
    final List<String> imageUrls = [
      'https://images.unsplash.com/photo-1499750310107-5fef28a66643?q=80&w=500&auto=format&fit=crop', // Desk
      'https://images.unsplash.com/photo-1455390582262-044cdee277a9?q=80&w=500&auto=format&fit=crop', // Writing
      'https://images.unsplash.com/photo-1497366216548-37526070297c?q=80&w=500&auto=format&fit=crop', // Office
      'https://images.unsplash.com/photo-1486312338219-ce68d2c6f44d?q=80&w=500&auto=format&fit=crop', // Laptop
      'https://images.unsplash.com/photo-1519389950473-47ba0277781c?q=80&w=500&auto=format&fit=crop', // Meeting
      'https://images.unsplash.com/photo-1542744094-24638eff58bb?q=80&w=500&auto=format&fit=crop', // Planning
    ];

    return GridView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: 12, // Mocking more items
      itemBuilder: (context, index) {
        String url = imageUrls[index % imageUrls.length];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FullscreenImageViewer(url: url),
              ),
            );
          },
          child: Hero(
            tag: url,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[200],
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image, color: Colors.grey),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _docsTab() {
    final List<Map<String, String>> docs = [
      {
        'name': 'Collection Report',
        'info': '5 pages 3mb PDF',
        'date': '3/3/2026',
      },
      {'name': 'Sales Report', 'info': '5 pages 3mb PDF', 'date': '3/3/2026'},
      {
        'name': 'Purchase Report',
        'info': '5 pages 3mb PDF',
        'date': '3/3/2026',
      },
      {'name': 'Growth Report', 'info': '5 pages 3mb PDF', 'date': '3/3/2026'},
    ];

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: docs.length,
      itemBuilder: (context, index) {
        final doc = docs[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ActualPdfViewer(
                  title: doc['name']!,
                  url: 'https://pdfobject.com/pdf/sample.pdf',
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.description_outlined,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doc['name']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        doc['info']!,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  doc['date']!,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _groupsTab() {
    final List<Map<String, String>> groups = [
      {'name': 'Sales Team', 'desc': 'Aravind CFO, Ajmal, 9565566595...'},
      {'name': 'Mafil Team', 'desc': 'Aravind CFO, Ajmal, 9565566595...'},
      {'name': 'Machat Group', 'desc': 'Aravind CFO, Ajmal, 9565566595...'},
      {'name': 'Macom Group', 'desc': 'Aravind CFO, Ajmal, 9565566595...'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Text(
                  group['name']![0],
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group['name']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      group['desc']!,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
