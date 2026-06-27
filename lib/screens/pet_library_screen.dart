import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import '../utils/colors.dart';
import 'breed_list_screen.dart';

/// Landing screen for the Pet Library.
/// Displays two animated category cards: Dogs and Cats.
class PetLibraryScreen extends StatefulWidget {
  const PetLibraryScreen({super.key});

  @override
  State<PetLibraryScreen> createState() => _PetLibraryScreenState();
}

class _PetLibraryScreenState extends State<PetLibraryScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _cardsController;
  late Animation<double> _headerFade;
  late Animation<Offset> _dogSlide;
  late Animation<Offset> _catSlide;

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
    _dogSlide = Tween<Offset>(
      begin: const Offset(-0.4, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _cardsController, curve: Curves.easeOutBack));
    _catSlide = Tween<Offset>(
      begin: const Offset(0.4, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _cardsController, curve: Curves.easeOutBack));

    // Stagger the animations
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
          // ── Gradient SliverAppBar ──────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primaryPurple,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
                child: SafeArea(
                  child: FadeTransition(
                    opacity: _headerFade,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        // Library icon with glow
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.auto_stories,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          t('pet_library'),
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          t('explore_breeds'),
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

          // ── Category Cards ─────────────────────────────────────────────────
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SlideTransition(
                    position: _dogSlide,
                    child: _CategoryCard(
                      label: t('dogs'),
                      emoji: '🐶',
                      subtitle: '${BreedListScreen.dogCount} ${t('dog_breeds')}',
                      gradient: const LinearGradient(
                        colors: [Color(0xFFf6a623), Color(0xFFf0845c)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      imageUrl: 'assets/images/dogs/YellowLabradorLooking.jpg',
                      onTap: () => Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, a1, a2) =>
                              const BreedListScreen(type: 'dog'),
                          transitionsBuilder: (_, a1, a2, child) =>
                              SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1, 0),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: a1,
                              curve: Curves.easeInOut,
                            )),
                            child: child,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SlideTransition(
                    position: _catSlide,
                    child: _CategoryCard(
                      label: t('cats'),
                      emoji: '🐱',
                      subtitle: '${BreedListScreen.catCount} ${t('cat_breeds')}',
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8360c3), Color(0xFF2ebf91)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      imageUrl: 'assets/images/cats/Persian_in_Cat_Cafe.jpg',
                      onTap: () => Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, a1, a2) =>
                              const BreedListScreen(type: 'cat'),
                          transitionsBuilder: (_, a1, a2, child) =>
                              SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1, 0),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: a1,
                              curve: Curves.easeInOut,
                            )),
                            child: child,
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
    );
  }
}

// ── Category Card Widget ────────────────────────────────────────────────────
class _CategoryCard extends StatefulWidget {
  final String label;
  final String emoji;
  final String subtitle;
  final LinearGradient gradient;
  final String imageUrl;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.label,
    required this.emoji,
    required this.subtitle,
    required this.gradient,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
      lowerBound: 0.96,
      upperBound: 1.0,
    )..value = 1.0;
    _scale = _scaleController;
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
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
              // Background image (faded)
              Positioned(
                right: -20,
                bottom: -20,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    widget.imageUrl,
                    width: 180,
                    height: 180,
                    fit: BoxFit.cover,
                    color: Colors.white.withValues(alpha: 0.15),
                    colorBlendMode: BlendMode.modulate,
                    errorBuilder: (_, __, ___) => const SizedBox(),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.emoji,
                      style: const TextStyle(fontSize: 44),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.label,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 26,
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
              // Arrow indicator
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
