import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';

/// Pet Tips & Articles screen — the 4th Quick Action feature.
/// Provides useful pet care tips organized by category.
class PetTipsScreen extends StatelessWidget {
  const PetTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                        'Pet Tips & Articles',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Expert advice for your furry friends',
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
                  children: const [
                    _CategoryChip(label: 'All', isSelected: true),
                    SizedBox(width: 8),
                    _CategoryChip(label: 'Nutrition'),
                    SizedBox(width: 8),
                    _CategoryChip(label: 'Health'),
                    SizedBox(width: 8),
                    _CategoryChip(label: 'Training'),
                    SizedBox(width: 8),
                    _CategoryChip(label: 'Grooming'),
                    SizedBox(width: 8),
                    _CategoryChip(label: 'Safety'),
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
                                          tip.category,
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
                                    tip.title,
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
                                    tip.description,
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
    title: 'How Much Water Should Your Dog Drink?',
    description:
        'A general rule of thumb is that dogs should drink about 1 ounce of water per pound of body weight each day. Puppies and active dogs may need more.',
    category: 'Nutrition',
    icon: Icons.water_drop,
    color: Colors.blue,
  ),
  _TipData(
    title: 'Signs Your Cat May Be Sick',
    description:
        'Watch for changes in appetite, litter box habits, hiding behavior, excessive grooming, or sudden weight loss. Early detection is key.',
    category: 'Health',
    icon: Icons.health_and_safety,
    color: Colors.red,
  ),
  _TipData(
    title: '5 Basic Commands Every Dog Should Know',
    description:
        'Start with Sit, Stay, Come, Down, and Leave It. Consistent training with positive reinforcement will build a strong bond with your pet.',
    category: 'Training',
    icon: Icons.school,
    color: Colors.purple,
  ),
  _TipData(
    title: 'Brushing Your Pet\'s Teeth at Home',
    description:
        'Use a pet-specific toothbrush and toothpaste. Start slowly and make it a positive experience. Aim for brushing at least 2-3 times per week.',
    category: 'Grooming',
    icon: Icons.clean_hands,
    color: Colors.pink,
  ),
  _TipData(
    title: 'Toxic Foods Your Pets Must Avoid',
    description:
        'Chocolate, grapes, onions, garlic, xylitol, and macadamia nuts are toxic to dogs and cats. Keep them out of reach at all times.',
    category: 'Safety',
    icon: Icons.warning_amber,
    color: Colors.orange,
  ),
  _TipData(
    title: 'Ideal Diet for Senior Cats',
    description:
        'Senior cats need more protein and fewer calories. Look for foods with joint support supplements like glucosamine and omega fatty acids.',
    category: 'Nutrition',
    icon: Icons.restaurant,
    color: Colors.teal,
  ),
  _TipData(
    title: 'How Often Should You Bathe Your Dog?',
    description:
        'Most dogs only need a bath every 4-6 weeks, unless they get dirty or have skin conditions. Over-bathing can strip natural oils from their coat.',
    category: 'Grooming',
    icon: Icons.bathtub,
    color: Colors.cyan,
  ),
  _TipData(
    title: 'Creating a Pet Emergency Kit',
    description:
        'Include first aid supplies, medications, copies of vet records, food, water, a leash, and a carrier. Update the kit every 6 months.',
    category: 'Safety',
    icon: Icons.medical_services,
    color: Colors.green,
  ),
];
