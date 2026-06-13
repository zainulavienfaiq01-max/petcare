import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import '../services/disease_data_service.dart';
import '../utils/colors.dart';
import 'disease_detail_screen.dart';

/// Displays a searchable, filterable list of pet diseases.
class DiseaseListScreen extends StatefulWidget {
  const DiseaseListScreen({super.key});

  @override
  State<DiseaseListScreen> createState() => _DiseaseListScreenState();
}

class _DiseaseListScreenState extends State<DiseaseListScreen>
    with SingleTickerProviderStateMixin {
  String _searchQuery = '';
  String _filterType = 'all'; // 'all', 'dog', 'cat'
  String _filterSeverity = 'all'; // 'all', 'Mild', 'Moderate', 'Severe', 'Critical'
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  List<DiseaseInfo> get _filteredDiseases {
    List<DiseaseInfo> result = DiseaseDataService.diseases;

    // Filter by animal type
    if (_filterType != 'all') {
      result = result
          .where((d) => d.affectedAnimals.contains(_filterType))
          .toList();
    }

    // Filter by severity
    if (_filterSeverity != 'all') {
      result = result.where((d) => d.severity == _filterSeverity).toList();
    }

    // Search
    if (_searchQuery.isNotEmpty) {
      final lower = _searchQuery.toLowerCase();
      result = result.where((d) {
        return d.name.toLowerCase().contains(lower) ||
            d.description.toLowerCase().contains(lower) ||
            d.symptoms.any((s) => s.toLowerCase().contains(lower));
      }).toList();
    }

    return result;
  }

  Color _severityColor(String severity) {
    switch (severity) {
      case 'Mild':
        return AppColors.success;
      case 'Moderate':
        return AppColors.warning;
      case 'Severe':
        return Colors.deepOrange;
      case 'Critical':
        return AppColors.error;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>();
    final t = locale.translate;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final diseases = _filteredDiseases;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            backgroundColor: AppColors.primaryPurple,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFe53935), Color(0xFFe35d5b)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.local_hospital,
                            color: Colors.white, size: 32),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        t('diseases'),
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${DiseaseDataService.diseases.length} ${t('diseases_count')}',
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

          // ── Search & Filters ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Search bar
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: (val) => setState(() => _searchQuery = val),
                      style: GoogleFonts.poppins(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: t('search_diseases'),
                        hintStyle: GoogleFonts.poppins(color: Colors.grey),
                        prefixIcon: const Icon(Icons.search,
                            color: AppColors.primaryPurple),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Animal type filter
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterChip(
                          label: t('all'),
                          isSelected: _filterType == 'all',
                          onTap: () =>
                              setState(() => _filterType = 'all'),
                          isDark: isDark,
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          label: '🐶 ${t('dogs')}',
                          isSelected: _filterType == 'dog',
                          onTap: () =>
                              setState(() => _filterType = 'dog'),
                          isDark: isDark,
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          label: '🐱 ${t('cats')}',
                          isSelected: _filterType == 'cat',
                          onTap: () =>
                              setState(() => _filterType = 'cat'),
                          isDark: isDark,
                        ),
                        const SizedBox(width: 16),
                        // Severity filters
                        _FilterChip(
                          label: t('mild'),
                          isSelected: _filterSeverity == 'Mild',
                          color: AppColors.success,
                          onTap: () => setState(() => _filterSeverity =
                              _filterSeverity == 'Mild'
                                  ? 'all'
                                  : 'Mild'),
                          isDark: isDark,
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          label: t('moderate'),
                          isSelected: _filterSeverity == 'Moderate',
                          color: AppColors.warning,
                          onTap: () => setState(() => _filterSeverity =
                              _filterSeverity == 'Moderate'
                                  ? 'all'
                                  : 'Moderate'),
                          isDark: isDark,
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          label: t('severe'),
                          isSelected: _filterSeverity == 'Severe',
                          color: Colors.deepOrange,
                          onTap: () => setState(() => _filterSeverity =
                              _filterSeverity == 'Severe'
                                  ? 'all'
                                  : 'Severe'),
                          isDark: isDark,
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          label: t('critical'),
                          isSelected: _filterSeverity == 'Critical',
                          color: AppColors.error,
                          onTap: () => setState(() => _filterSeverity =
                              _filterSeverity == 'Critical'
                                  ? 'all'
                                  : 'Critical'),
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Disease List ──
          diseases.isEmpty
              ? SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off,
                            size: 64,
                            color: isDark
                                ? Colors.grey[600]
                                : Colors.grey[300]),
                        const SizedBox(height: 12),
                        Text(
                          t('no_diseases_found'),
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final disease = diseases[index];
                      return TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: Duration(
                            milliseconds: 300 + (index * 50).clamp(0, 500)),
                        curve: Curves.easeOutCubic,
                        builder: (_, value, child) => Opacity(
                          opacity: value.clamp(0.0, 1.0),
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: child,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 5),
                          child: _DiseaseCard(
                            disease: disease,
                            isDark: isDark,
                            severityColor: _severityColor(disease.severity),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    DiseaseDetailScreen(disease: disease),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: diseases.length,
                  ),
                ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

// ── Filter Chip ──
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;
  final Color? color;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? AppColors.primaryPurple;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor.withValues(alpha: 0.15)
              : (isDark ? AppColors.cardDark : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? activeColor
                : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected
                ? activeColor
                : (isDark ? AppColors.textSecondaryDark : Colors.grey[600]),
          ),
        ),
      ),
    );
  }
}

// ── Disease Card ──
class _DiseaseCard extends StatelessWidget {
  final DiseaseInfo disease;
  final bool isDark;
  final Color severityColor;
  final VoidCallback onTap;

  const _DiseaseCard({
    required this.disease,
    required this.isDark,
    required this.severityColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Emoji icon
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: severityColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(disease.emoji,
                    style: const TextStyle(fontSize: 26)),
              ),
            ),
            const SizedBox(width: 14),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    disease.name,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Animal badges
                  Row(
                    children: [
                      ...disease.affectedAnimals.map((a) => Container(
                            margin: const EdgeInsets.only(right: 6),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primaryPurple
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              a == 'dog' ? '🐶 Dog' : '🐱 Cat',
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryPurple,
                              ),
                            ),
                          )),
                      const Spacer(),
                      // Severity badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: severityColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          disease.severity,
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: severityColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right,
                color: isDark ? Colors.grey[600] : Colors.grey[400], size: 20),
          ],
        ),
      ),
    );
  }
}
