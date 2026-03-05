import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants/app_colors.dart';
import 'home_screen.dart';
import '../field_visit/field_visit_screen.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;
  final GlobalKey<dynamic> _homeKey = GlobalKey();

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(
        key: _homeKey,
        onAppBarChanged: () {
          if (mounted) setState(() {});
        },
      ),
      const FieldVisitScreen(),
    ];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() {});
    });
  }

  PreferredSizeWidget? _buildAppBar() {
    if (_selectedIndex == 0) {
      final state = _homeKey.currentState;
      if (state != null) {
        return (state as dynamic).getAppBar(context);
      }
    } else if (_selectedIndex == 1) {
      return const FieldVisitScreen().getAppBar(context);
    }
    return null;
  }

  Widget? _buildFAB() {
    if (_selectedIndex == 0) {
      final state = _homeKey.currentState;
      if (state != null) {
        return (state as dynamic).getFAB(context);
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: IndexedStack(index: _selectedIndex, children: _screens),
      floatingActionButton: _buildFAB(),
      extendBody: true,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: _navItem(
                index: 0,
                label: 'Chat',
                svgPath: 'icons/bottomTabChat.svg',
              ),
            ),
            Expanded(
              child: _navItem(
                index: 1,
                label: 'Field Visit',
                svgPath: 'icons/bottomTabField.svg',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem({
    required int index,
    required String label,
    required String svgPath,
  }) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              svgPath,
              colorFilter: ColorFilter.mode(
                isSelected ? Colors.black : Colors.white,
                BlendMode.srcIn,
              ),
              height: 20,
            ),
            if (isSelected) const SizedBox(height: 4),
            if (isSelected)
              Text(
                label,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
