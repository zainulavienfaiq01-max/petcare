import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _pulseController;
  late AnimationController _progressController;
  late AnimationController _fadeOutController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _iconSlide;
  late Animation<double> _titleOpacity;
  late Animation<double> _subtitleOpacity;
  late Animation<double> _progressOpacity;
  late Animation<double> _pulseAnimation;
  late Animation<double> _progressValue;
  late Animation<double> _fadeOutAnimation;

  @override
  void initState() {
    super.initState();

    // ─── Logo entrance animation ───
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    _iconSlide = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.1, 0.5, curve: Curves.easeOutCubic),
      ),
    );

    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.4, 0.7, curve: Curves.easeIn),
      ),
    );

    _subtitleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.55, 0.85, curve: Curves.easeIn),
      ),
    );

    _progressOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.7, 1.0, curve: Curves.easeIn),
      ),
    );

    // ─── Subtle pulse glow on logo ───
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // ─── Progress bar animation ───
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 2200),
      vsync: this,
    );
    _progressValue = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    // ─── Fade out animation ───
    _fadeOutController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeOutAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _fadeOutController, curve: Curves.easeIn),
    );

    _startAnimationSequence();
  }

  Future<void> _startAnimationSequence() async {
    // Phase 1: Logo entrance
    _logoController.forward();

    await Future.delayed(const Duration(milliseconds: 1200));

    // Phase 2: Start pulse & progress
    _pulseController.repeat(reverse: true);
    _progressController.forward();

    // Phase 3: Wait for progress to finish, then fade out & navigate
    await Future.delayed(const Duration(milliseconds: 2600));

    if (mounted) {
      _fadeOutController.forward();
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 600),
            pageBuilder: (context, animation, secondaryAnimation) =>
                const MainScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _pulseController.dispose();
    _progressController.dispose();
    _fadeOutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.backgroundDark : const Color(0xFFF8F6FC);

    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _logoController,
          _pulseController,
          _progressController,
          _fadeOutController,
        ]),
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeOutAnimation.status == AnimationStatus.forward ||
                    _fadeOutAnimation.status == AnimationStatus.completed
                ? _fadeOutController
                : const AlwaysStoppedAnimation(1.0),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: bgColor,
              ),
              child: Stack(
                children: [
                  // ─── Subtle decorative circles ───
                  _buildDecorativeOrb(
                    top: -60,
                    right: -40,
                    size: 200,
                    opacity: 0.06,
                    isDark: isDark,
                  ),
                  _buildDecorativeOrb(
                    bottom: -80,
                    left: -50,
                    size: 240,
                    opacity: 0.05,
                    isDark: isDark,
                  ),
                  _buildDecorativeOrb(
                    top: MediaQuery.of(context).size.height * 0.3,
                    left: -100,
                    size: 160,
                    opacity: 0.04,
                    isDark: isDark,
                  ),

                  // ─── Main content ───
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(flex: 3),

                        // ─── Logo icon ───
                        Opacity(
                          opacity: _logoOpacity.value,
                          child: Transform.scale(
                            scale: _logoScale.value,
                            child: Transform.translate(
                              offset: Offset(0, _iconSlide.value),
                              child: _buildLogoIcon(isDark),
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // ─── App title ───
                        Opacity(
                          opacity: _titleOpacity.value,
                          child: Text(
                            'PetCare',
                            style: GoogleFonts.poppins(
                              fontSize: 34,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppColors.textPrimaryDark
                                  : AppColors.textPrimary,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // ─── Subtitle ───
                        Opacity(
                          opacity: _subtitleOpacity.value,
                          child: Text(
                            'Your Pet\'s Wellness Partner',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondary,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),

                        const Spacer(flex: 2),

                        // ─── Loading indicator ───
                        Opacity(
                          opacity: _progressOpacity.value,
                          child: _buildLoadingIndicator(isDark),
                        ),

                        const SizedBox(height: 48),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLogoIcon(bool isDark) {
    final double pulseVal = _pulseAnimation.value;
    final double glowRadius = 20 + (pulseVal * 12);
    final double glowOpacity = isDark ? 0.25 + (pulseVal * 0.15) : 0.15 + (pulseVal * 0.10);

    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: isDark
              ? [
                  AppColors.accentPurple.withValues(alpha: 0.9),
                  AppColors.primaryPurple.withValues(alpha: 0.7),
                ]
              : [
                  AppColors.primaryPurple,
                  AppColors.accentPurple,
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentPurple.withValues(alpha: glowOpacity),
            blurRadius: glowRadius,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: CustomPaint(
          size: const Size(52, 52),
          painter: _PetLogoPainter(
            color: Colors.white.withValues(alpha: 0.95),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(bool isDark) {
    return Column(
      children: [
        // Slim progress bar
        SizedBox(
          width: 160,
          height: 3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: _progressValue.value,
              backgroundColor: isDark
                  ? AppColors.surfaceDark
                  : AppColors.softGrey,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.accentPurple.withValues(alpha: 0.8),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Loading...',
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: isDark
                ? AppColors.textSecondaryDark.withValues(alpha: 0.7)
                : AppColors.textHint,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }

  Widget _buildDecorativeOrb({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double size,
    required double opacity,
    required bool isDark,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primaryPurple.withValues(alpha: opacity),
        ),
      ),
    );
  }
}

// ─── Custom pet paw logo painter ───
// Draws a minimalist paw print icon using Canvas
class _PetLogoPainter extends CustomPainter {
  final Color color;

  _PetLogoPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final cx = size.width / 2;
    final cy = size.height / 2;

    // Main pad (large oval at bottom)
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, cy + size.height * 0.14),
        width: size.width * 0.42,
        height: size.height * 0.32,
      ),
      paint,
    );

    // Top-left toe
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx - size.width * 0.22, cy - size.height * 0.12),
        width: size.width * 0.18,
        height: size.height * 0.22,
      ),
      paint,
    );

    // Top-right toe
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx + size.width * 0.22, cy - size.height * 0.12),
        width: size.width * 0.18,
        height: size.height * 0.22,
      ),
      paint,
    );

    // Upper-left toe
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx - size.width * 0.10, cy - size.height * 0.30),
        width: size.width * 0.16,
        height: size.height * 0.20,
      ),
      paint,
    );

    // Upper-right toe
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx + size.width * 0.10, cy - size.height * 0.30),
        width: size.width * 0.16,
        height: size.height * 0.20,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}