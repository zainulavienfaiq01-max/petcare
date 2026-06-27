import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import '../utils/colors.dart';

/// Pet Tips & Articles screen — the 4th Quick Action feature.
/// Provides useful pet care tips organized by category.
class PetTipsScreen extends StatelessWidget {
  const PetTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locale = context.watch<LocaleProvider>();
    final t = locale.translate;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // ── Gradient Header ────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: const Color(0xFF00b894),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF00b894), Color(0xFF00cec9)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.lightbulb_outline,
                            color: Colors.white, size: 36),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        t('pet_tips_title'),
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        t('pet_tips_desc'),
                        style: GoogleFonts.poppins(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              titlePadding: EdgeInsets.zero,
            ),
          ),

          // ── Category Chips ─────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: SizedBox(
                height: 42,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _CategoryChip(label: t('all'), isSelected: true),
                    const SizedBox(width: 8),
                    _CategoryChip(label: t('cat_nutrition')),
                    const SizedBox(width: 8),
                    _CategoryChip(label: t('cat_health')),
                    const SizedBox(width: 8),
                    _CategoryChip(label: t('cat_training')),
                    const SizedBox(width: 8),
                    _CategoryChip(label: t('cat_grooming')),
                    const SizedBox(width: 8),
                    _CategoryChip(label: t('cat_safety')),
                  ],
                ),
              ),
            ),
          ),

          // ── Tips List ──────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final tip = _tips[index];
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: Duration(milliseconds: 350 + index * 60),
                    curve: Curves.easeOutBack,
                    builder: (context, value, child) => Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: Opacity(
                          opacity: value.clamp(0.0, 1.0), child: child),
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardDark : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Icon
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: tip.color.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child:
                                  Icon(tip.icon, color: tip.color, size: 24),
                            ),
                            const SizedBox(width: 14),
                            // Content
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: tip.color
                                              .withValues(alpha: 0.12),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          t(tip.category),
                                          style: GoogleFonts.poppins(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: tip.color,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    t(tip.title),
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: isDark
                                          ? AppColors.textPrimaryDark
                                          : AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    t(tip.description),
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: isDark
                                          ? AppColors.textSecondaryDark
                                          : Colors.grey[600],
                                      height: 1.4,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: _tips.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Chip Widget ──────────────────────────────────────────────────────────────
class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _CategoryChip({required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: isSelected
            ? const LinearGradient(
                colors: [Color(0xFF00b894), Color(0xFF00cec9)])
            : null,
        color: isSelected
            ? null
            : (isDark ? AppColors.cardDark : Colors.grey[100]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isSelected
              ? Colors.white
              : (isDark ? AppColors.textSecondaryDark : Colors.grey[600]),
        ),
      ),
    );
  }
}

// ── Tips Data ────────────────────────────────────────────────────────────────
class _TipData {
  final String title;
  final String description;
  final String category;
  final IconData icon;
  final Color color;

  const _TipData({
    required this.title,
    required this.description,
    required this.category,
    required this.icon,
    required this.color,
  });
}

const List<_TipData> _tips = [
  _TipData(
    title: 'tip_1_title',
    description: 'tip_1_desc',
    category: 'cat_nutrition',
    icon: Icons.water_drop,
    color: Colors.blue,
  ),
  _TipData(
    title: 'tip_2_title',
    description: 'tip_2_desc',
    category: 'cat_health',
    icon: Icons.health_and_safety,
    color: Colors.red,
  ),
  _TipData(
    title: 'tip_3_title',
    description: 'tip_3_desc',
    category: 'cat_training',
    icon: Icons.school,
    color: Colors.purple,
  ),
  _TipData(
    title: 'tip_4_title',
    description: 'tip_4_desc',
    category: 'cat_grooming',
    icon: Icons.clean_hands,
    color: Colors.pink,
  ),
  _TipData(
    title: 'tip_5_title',
    description: 'tip_5_desc',
    category: 'cat_safety',
    icon: Icons.warning_amber,
    color: Colors.orange,
  ),
  _TipData(
    title: 'tip_6_title',
    description: 'tip_6_desc',
    category: 'cat_nutrition',
    icon: Icons.restaurant,
    color: Colors.teal,
  ),
  _TipData(
    title: 'tip_7_title',
    description: 'tip_7_desc',
    category: 'cat_grooming',
    icon: Icons.bathtub,
    color: Colors.cyan,
  ),
  _TipData(
    title: 'tip_8_title',
    description: 'tip_8_desc',
    category: 'cat_safety',
    icon: Icons.medical_services,
    color: Colors.green,
  ),
];
