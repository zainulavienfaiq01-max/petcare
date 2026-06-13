import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/disease_data_service.dart';
import '../utils/colors.dart';

/// Screen detailing a specific pet disease.
class DiseaseDetailScreen extends StatelessWidget {
  final DiseaseInfo disease;

  const DiseaseDetailScreen({super.key, required this.disease});

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sevColor = _severityColor(disease.severity);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──
          SliverAppBar(
            expandedHeight: 220,
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
                      Text(
                        disease.emoji,
                        style: const TextStyle(fontSize: 60),
                      ),
                    ],
                  ),
                ),
              ),
              title: Text(
                disease.name,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
          ),

          // ── Content ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Severity & Animal type badges
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: sevColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: sevColor, width: 1.5),
                        ),
                        child: Text(
                          'Severity: ${disease.severity}',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: sevColor,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const Spacer(),
                      ...disease.affectedAnimals.map((a) => Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.cardDark : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Colors.grey[300]!, width: 1),
                            ),
                            child: Text(
                              a == 'dog' ? '🐶 Dog' : '🐱 Cat',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : Colors.black87,
                              ),
                            ),
                          )),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Description
                  Text(
                    disease.description,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      height: 1.5,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Info Sections
                  _Section(
                    title: 'Causes & Transmission',
                    icon: Icons.biotech,
                    content: disease.causes,
                    isDark: isDark,
                  ),
                  _ListSection(
                    title: 'General Symptoms',
                    icon: Icons.sick,
                    items: disease.symptoms,
                    isDark: isDark,
                  ),
                  _ListSection(
                    title: 'Physical Signs',
                    icon: Icons.visibility,
                    items: disease.physicalSigns,
                    isDark: isDark,
                  ),
                  _ListSection(
                    title: 'Behavioral Changes',
                    icon: Icons.psychology,
                    items: disease.behavioralChanges,
                    isDark: isDark,
                  ),
                  _ListSection(
                    title: 'Prevention',
                    icon: Icons.shield,
                    items: disease.prevention,
                    isDark: isDark,
                  ),
                  _ListSection(
                    title: 'Treatments',
                    icon: Icons.healing,
                    items: disease.treatments,
                    isDark: isDark,
                  ),
                  _Section(
                    title: 'When to visit a Vet?',
                    icon: Icons.warning_amber_rounded,
                    content: disease.whenToVisitVet,
                    isDark: isDark,
                  ),
                  _ListSection(
                    title: 'Critical Emergency Signs',
                    icon: Icons.emergency,
                    items: disease.emergencyWarnings,
                    isDark: isDark,
                    isEmergency: true,
                  ),

                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final IconData icon;
  final String content;
  final bool isDark;

  const _Section({
    required this.title,
    required this.icon,
    required this.content,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primaryPurple, size: 24),
              const SizedBox(width: 10),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              content,
              style: GoogleFonts.poppins(
                fontSize: 14,
                height: 1.5,
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ListSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<String> items;
  final bool isDark;
  final bool isEmergency;

  const _ListSection({
    required this.title,
    required this.icon,
    required this.items,
    required this.isDark,
    this.isEmergency = false,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = isEmergency
        ? AppColors.error
        : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary);
    final iconColor = isEmergency ? AppColors.error : AppColors.primaryPurple;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 24),
              const SizedBox(width: 10),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: isEmergency ? Border.all(color: AppColors.error.withValues(alpha: 0.5)) : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 6, right: 10),
                        child: Icon(
                          isEmergency ? Icons.warning : Icons.circle,
                          size: isEmergency ? 14 : 6,
                          color: isEmergency ? AppColors.error : AppColors.primaryPurple,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          item,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            height: 1.4,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
