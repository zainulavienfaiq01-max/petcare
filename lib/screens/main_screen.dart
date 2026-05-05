import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';
import '../utils/colors.dart';
import 'dashboard_screen.dart';
import 'pets_screen.dart';
import 'schedule_screen.dart';
import 'health_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _controller;

  final List<Widget> _pages = const [
    DashboardScreen(),
    PetsScreen(),
    ScheduleScreen(),
    HealthScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light 
              ? Colors.white 
              : AppColors.surfaceDark,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() => _currentIndex = index);
              _controller.forward(from: 0);
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
              BottomNavigationBarItem(icon: Icon(Icons.pets_outlined), label: 'Pets'),
              BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), label: 'Schedule'),
              BottomNavigationBarItem(icon: Icon(Icons.favorite_outlined), label: 'Health'),
              BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }
}