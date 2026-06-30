import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../providers/pet_provider.dart';
import '../providers/schedule_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/audio_provider.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../widgets/stat_card.dart';

import 'library_hub_screen.dart';
import 'pet_tips_screen.dart';
import 'notification_screen.dart';
import 'schedule_screen.dart';

/// Premium redesigned Dashboard with gradient header, notification badge,
/// dark mode toggle, 4 Quick Actions (2×2 grid), stats, and today's schedule.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward();
    _fadeAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>();
    final t = locale.translate;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = context.watch<ThemeProvider>();
    final authProvider = context.watch<AuthProvider>();
    final screenWidth = MediaQuery.sizeOf(context).width;
    final double quickActionAspectRatio = screenWidth < 380 ? 1.05 : 1.25;
    final double statCardAspectRatio = screenWidth < 380 ? 0.9 : 1.0;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Consumer2<PetProvider, ScheduleProvider>(
        builder: (context, petProvider, scheduleProvider, child) {
          final pets = petProvider.pets;
          final todaySchedules = scheduleProvider.todaySchedules;
          final upcomingVaccines = scheduleProvider.schedules
              .where((s) => s.type == 'Vaksin' && !s.isCompleted)
              .take(3)
              .toList();

          return FadeTransition(
            opacity: _fadeAnim,
            child: CustomScrollView(
              slivers: [
                // ── Gradient Header Section ────────────────────────────────
                SliverToBoxAdapter(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: isDark
                          ? const LinearGradient(
                              colors: [Color(0xFF2A2A4A), Color(0xFF1A1A2E)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : AppColors.primaryGradient,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── Top bar: Logo, Dark mode, Notification ──
                            Row(
                              children: [
                                // App logo
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Center(
                                    child: Text('🐾',
                                        style: TextStyle(fontSize: 22)),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  AppConstants.appName,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),

                                // Dark mode toggle
                                GestureDetector(
                                  onTap: () => themeProvider.toggleTheme(),
                                  child: Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.white.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      isDark
                                          ? Icons.light_mode
                                          : Icons.dark_mode,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),

                                // Notification icon with badge
                                GestureDetector(
                                  onTap: () {
                                    context.read<AudioProvider>().playMenuClick();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const NotificationScreen()),
                                    );
                                  },
                                  child: Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.white.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Stack(
                                      children: [
                                        const Center(
                                          child: Icon(
                                              Icons.notifications_outlined,
                                              color: Colors.white,
                                              size: 20),
                                        ),
                                        // Badge
                                        Positioned(
                                          right: 6,
                                          top: 6,
                                          child: Container(
                                            width: 16,
                                            height: 16,
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Text(
                                                '3',
                                                style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // ── Welcome Text ────────────────────────────
                            Text(
                              '${t('welcome_back')} 👋',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              authProvider.userName.isNotEmpty
                                  ? authProvider.userName
                                  : 'Pet Lover',
                              style: GoogleFonts.poppins(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            StreamBuilder(
                              stream: Stream.periodic(const Duration(seconds: 1)),
                              builder: (context, snapshot) {
                                return Text(
                                  DateFormat('EEEE, MMMM d, yyyy • HH:mm:ss')
                                      .format(DateTime.now()),
                                  style: GoogleFonts.poppins(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    fontSize: 13,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // ── Body Content ─────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Your Pets ─────────────────────────────────────
                        _SectionHeader(
                          title: t('your_pets'),
                          icon: Icons.pets,
                          isDark: isDark,
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 120,
                          child: pets.isEmpty
                              ? _EmptyPetsBanner(isDark: isDark, label: t('no_pets'))
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: pets.length,
                                  itemBuilder: (context, index) {
                                    final pet = pets[index];
                                    return TweenAnimationBuilder<double>(
                                      tween: Tween(begin: 0, end: 1),
                                      duration: Duration(
                                          milliseconds: 400 + index * 100),
                                      curve: Curves.easeOutBack,
                                      builder: (_, v, child) =>
                                          Transform.scale(
                                        scale: v,
                                        child: Opacity(
                                            opacity: v.clamp(0.0, 1.0),
                                            child: child),
                                      ),
                                      child: Container(
                                        width: 90,
                                        margin:
                                            const EdgeInsets.only(right: 12),
                                        child: Column(
                                          children: [
                                            Container(
                                              width: 64,
                                              height: 64,
                                              decoration: BoxDecoration(
                                                gradient: index % 4 == 0
                                                    ? AppColors.cardGradient1
                                                    : index % 4 == 1
                                                        ? AppColors
                                                            .cardGradient2
                                                        : index % 4 == 2
                                                            ? AppColors
                                                                .cardGradient3
                                                            : AppColors
                                                                .cardGradient4,
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: AppColors
                                                        .primaryPurple
                                                        .withValues(
                                                            alpha: 0.2),
                                                    blurRadius: 10,
                                                    offset:
                                                        const Offset(0, 4),
                                                  ),
                                                ],
                                              ),
                                              child: Center(
                                                child: Text(
                                                  AppConstants.petTypeEmoji[
                                                          pet.type] ??
                                                      '🐾',
                                                  style: const TextStyle(
                                                      fontSize: 28),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              pet.name,
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                                color: isDark
                                                    ? AppColors
                                                        .textPrimaryDark
                                                    : AppColors.textPrimary,
                                              ),
                                              textAlign: TextAlign.center,
                                              overflow:
                                                  TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),

                        const SizedBox(height: 24),

                        // ── Quick Actions (2×2 Grid) ─────────────────────
                        _SectionHeader(
                          title: t('quick_actions'),
                          icon: Icons.flash_on,
                          isDark: isDark,
                        ),
                        const SizedBox(height: 12),
                        GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          childAspectRatio: quickActionAspectRatio,
                          children: [
                            _QuickActionCard(
                              title: t('pet_library'),
                              icon: Icons.auto_stories,
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF667eea),
                                  Color(0xFF764ba2)
                                ],
                              ),
                              onTap: () {
                                context.read<AudioProvider>().playActionClick();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          const LibraryHubScreen()),
                                );
                              },
                            ),

                            _QuickActionCard(
                              title: t('nav_schedule'),
                              icon: Icons.calendar_month,
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFf6a623),
                                  Color(0xFFf0845c)
                                ],
                              ),
                              onTap: () {
                                context.read<AudioProvider>().playActionClick();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          const ScheduleScreen()),
                                );
                              },
                            ),
                            _QuickActionCard(
                              title: 'Pet Tips',
                              icon: Icons.lightbulb_outline,
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF00b894),
                                  Color(0xFF00cec9)
                                ],
                              ),
                              onTap: () {
                                context.read<AudioProvider>().playActionClick();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          const PetTipsScreen()),
                                );
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // ── Statistics ─────────────────────────────────────
                        _SectionHeader(
                          title: t('statistics'),
                          icon: Icons.bar_chart,
                          isDark: isDark,
                        ),
                        const SizedBox(height: 12),
                        GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          childAspectRatio: statCardAspectRatio,
                          children: [
                            StatCard(
                              title: t('total_pets'),
                              value: pets.length.toString(),
                              icon: Icons.pets,
                              gradient: AppColors.cardGradient1,
                            ),
                            StatCard(
                              title: t('todays_tasks'),
                              value: todaySchedules.length.toString(),
                              icon: Icons.today,
                              gradient: AppColors.cardGradient2,
                            ),
                            StatCard(
                              title: t('completed'),
                              value: scheduleProvider.schedules
                                  .where((s) => s.isCompleted)
                                  .length
                                  .toString(),
                              icon: Icons.check_circle,
                              gradient: AppColors.cardGradient3,
                            ),
                            StatCard(
                              title: t('upcoming_vaccines'),
                              value: upcomingVaccines.length.toString(),
                              icon: Icons.vaccines,
                              gradient: AppColors.cardGradient4,
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // ── Today's Schedule ──────────────────────────────
                        _SectionHeader(
                          title: t('todays_schedule'),
                          icon: Icons.schedule,
                          isDark: isDark,
                        ),
                        const SizedBox(height: 12),
                        todaySchedules.isEmpty
                            ? Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(28),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.cardDark
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withValues(alpha: 0.04),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Icon(Icons.event_available,
                                        size: 52,
                                        color: isDark
                                            ? Colors.grey[600]
                                            : Colors.grey[300]),
                                    const SizedBox(height: 12),
                                    Text(
                                      t('no_schedules'),
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: isDark
                                            ? AppColors.textSecondaryDark
                                            : Colors.grey[400],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics:
                                    const NeverScrollableScrollPhysics(),
                                itemCount: todaySchedules.length,
                                itemBuilder: (context, index) {
                                  final schedule = todaySchedules[index];
                                  final pet = petProvider
                                      .getPetById(schedule.petId);
                                  return Container(
                                    margin:
                                        const EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? AppColors.cardDark
                                          : Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.04),
                                          blurRadius: 10,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 6),
                                      leading: Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryPurple
                                              .withValues(alpha: 0.12),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Center(
                                          child: Text(
                                            AppConstants.scheduleTypeEmoji[
                                                    schedule.type] ??
                                                '📅',
                                            style: const TextStyle(
                                                fontSize: 20),
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        schedule.type,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          color: isDark
                                              ? AppColors.textPrimaryDark
                                              : AppColors.textPrimary,
                                        ),
                                      ),
                                      subtitle: Text(
                                        '${pet?.name ?? 'Unknown'} • ${DateFormat('HH:mm').format(schedule.dateTime)}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: isDark
                                              ? AppColors
                                                  .textSecondaryDark
                                              : Colors.grey[500],
                                        ),
                                      ),
                                      trailing: Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: (schedule.isCompleted
                                                  ? AppColors.success
                                                  : AppColors.warning)
                                              .withValues(alpha: 0.15),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          schedule.isCompleted
                                              ? Icons.check_circle
                                              : Icons.pending_outlined,
                                          color: schedule.isCompleted
                                              ? AppColors.success
                                              : AppColors.warning,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),

                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ── Section Header Widget ────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isDark;

  const _SectionHeader({
    required this.title,
    required this.icon,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.primaryPurple.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primaryPurple, size: 18),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

// ── Quick Action Card (2×2 grid item) ────────────────────────────────────────
class _QuickActionCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  State<_QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<_QuickActionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleCtrl;

  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
      lowerBound: 0.95,
      upperBound: 1.0,
    )..value = 1.0;
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleCtrl,
      child: GestureDetector(
        onTapDown: (_) => _scaleCtrl.reverse(),
        onTapUp: (_) {
          _scaleCtrl.forward();
          widget.onTap();
        },
        onTapCancel: () => _scaleCtrl.forward(),
        child: Container(
          decoration: BoxDecoration(
            gradient: widget.gradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color:
                    widget.gradient.colors.last.withValues(alpha: 0.35),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background circle decoration
              Positioned(
                right: -12,
                bottom: -12,
                child: Icon(
                  widget.icon,
                  color: Colors.white.withValues(alpha: 0.12),
                  size: 70,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(widget.icon,
                          color: Colors.white, size: 22),
                    ),
                    const SizedBox(height: 6),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Empty Pets Banner ────────────────────────────────────────────────────────
class _EmptyPetsBanner extends StatelessWidget {
  final bool isDark;
  final String label;

  const _EmptyPetsBanner({required this.isDark, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primaryPurple.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('🐾', style: TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tap the Pets tab to add your first pet!',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}