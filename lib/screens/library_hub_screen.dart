import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import '../providers/audio_provider.dart';
import '../utils/colors.dart';
import 'pet_library_screen.dart';
import 'disease_list_screen.dart';

/// Hub screen that shows two options: Pet Library and Diseases Encyclopedia.
/// Reached from the dashboard Quick Actions.
class LibraryHubScreen extends StatefulWidget {
  const LibraryHubScreen({super.key});

  @override
  State<LibraryHubScreen> createState() => _LibraryHubScreenState();
}

class _LibraryHubScreenState extends State<LibraryHubScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _cardsController;
  late Animation<double> _headerFade;
  late Animation<Offset> _librarySlide;
  late Animation<Offset> _diseaseSlide;

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _cardsController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _headerFade = CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOut,
    );
    _librarySlide = Tween<Offset>(
      begin: const Offset(-0.4, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _cardsController, curve: Curves.easeOutBack));
    _diseaseSlide = Tween<Offset>(
      begin: const Offset(0.4, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _cardsController, curve: Curves.easeOutBack));

    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _cardsController.forward();
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _cardsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>();
    final t = locale.translate;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // ── Gradient SliverAppBar ──
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primaryPurple,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient),
                child: SafeArea(
                  child: FadeTransition(
                    opacity: _headerFade,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.menu_book_rounded,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          t('library_hub'),
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          t('library_hub_sub'),
                          style: GoogleFonts.poppins(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              titlePadding: EdgeInsets.zero,
            ),
          ),

          // ── Two Option Cards ──
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Library Card
                  SlideTransition(
                    position: _librarySlide,
                    child: _HubCard(
                      label: t('pet_library'),
                      subtitle: t('explore_breeds'),
                      emoji: '📚',
                      icon: Icons.auto_stories,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      onTap: () {
                        context.read<AudioProvider>().playActionClick();
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, a1, a2) =>
                                const PetLibraryScreen(),
                            transitionsBuilder: (_, a1, a2, child) =>
                                SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(1, 0),
                                end: Offset.zero,
                              ).animate(CurvedAnimation(
                                  parent: a1, curve: Curves.easeInOut)),
                              child: child,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Diseases Card
                  SlideTransition(
                    position: _diseaseSlide,
                    child: _HubCard(
                      label: t('diseases'),
                      subtitle: t('diseases_sub'),
                      emoji: '🏥',
                      icon: Icons.local_hospital,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFe53935), Color(0xFFe35d5b)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      onTap: () {
                        context.read<AudioProvider>().playActionClick();
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, a1, a2) =>
                                const DiseaseListScreen(),
                            transitionsBuilder: (_, a1, a2, child) =>
                                SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(1, 0),
                                end: Offset.zero,
                              ).animate(CurvedAnimation(
                                  parent: a1, curve: Curves.easeInOut)),
                              child: child,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Hub Card Widget ──
class _HubCard extends StatefulWidget {
  final String label;
  final String subtitle;
  final String emoji;
  final IconData icon;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _HubCard({
    required this.label,
    required this.subtitle,
    required this.emoji,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  State<_HubCard> createState() => _HubCardState();
}

class _HubCardState extends State<_HubCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
      lowerBound: 0.96,
      upperBound: 1.0,
    )..value = 1.0;
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleController,
      child: GestureDetector(
        onTapDown: (_) => _scaleController.reverse(),
        onTapUp: (_) {
          _scaleController.forward();
          widget.onTap();
        },
        onTapCancel: () => _scaleController.forward(),
        child: Container(
          height: 160,
          decoration: BoxDecoration(
            gradient: widget.gradient,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: widget.gradient.colors.last.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // Background icon decoration
              Positioned(
                right: -20,
                bottom: -20,
                child: Icon(
                  widget.icon,
                  color: Colors.white.withValues(alpha: 0.12),
                  size: 140,
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.emoji,
                        style: const TextStyle(fontSize: 44)),
                    const SizedBox(height: 8),
                    Text(
                      widget.label,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.subtitle,
                      style: GoogleFonts.poppins(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              // Arrow
              Positioned(
                right: 20,
                top: 0,
                bottom: 0,
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withValues(alpha: 0.7),
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
