import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import '../utils/colors.dart';
import 'dashboard_screen.dart';
import 'pets_screen.dart';
import 'schedule_screen.dart';
import 'pet_library_screen.dart';
import 'profile_screen.dart';

/// Main shell with bottom navigation bar.
/// Now includes the Pet Library tab (index 3).
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _controller;

  final List<Widget> _pages = const [
    DashboardScreen(),
    PetsScreen(),
    ScheduleScreen(),
    PetLibraryScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>();
    final t = locale.translate;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        child: KeyedSubtree(
          key: ValueKey(_currentIndex),
          child: _pages[_currentIndex],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(24)),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() => _currentIndex = index);
              _controller.forward(from: 0);
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            selectedItemColor: AppColors.primaryPurple,
            unselectedItemColor: Colors.grey[400],
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
            unselectedLabelStyle: const TextStyle(fontSize: 10),
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.dashboard_outlined),
                activeIcon: const Icon(Icons.dashboard),
                label: t('nav_home'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.pets_outlined),
                activeIcon: const Icon(Icons.pets),
                label: t('nav_pets'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.calendar_today_outlined),
                activeIcon: const Icon(Icons.calendar_today),
                label: t('nav_schedule'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.auto_stories_outlined),
                activeIcon: const Icon(Icons.auto_stories),
                label: t('pet_library'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person_outline),
                activeIcon: const Icon(Icons.person),
                label: t('nav_profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}