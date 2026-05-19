import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/locale_provider.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import 'splash_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Consumer3<ThemeProvider, AuthProvider, LocaleProvider>(
        builder: (context, themeProvider, authProvider, locale, child) {
          final t = locale.translate;

          return CustomScrollView(
            slivers: [
              // ── Gradient Header ──────────────────────────────────────
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                  ),
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 20,
                    bottom: 32,
                  ),
                  child: Column(
                    children: [
                      // Avatar
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.5),
                              width: 3),
                        ),
                        child: const Center(
                          child:
                              Icon(Icons.person, size: 52, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        authProvider.userName.isNotEmpty
                            ? authProvider.userName
                            : 'User',
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        authProvider.userEmail,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Settings List ────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),

                      // ── Appearance Card ──────────────────────────────
                      _SettingsCard(
                        children: [
                          // Dark Mode toggle
                          _SettingsTile(
                            icon: themeProvider.isDarkMode
                                ? Icons.dark_mode
                                : Icons.light_mode,
                            iconColor: AppColors.primaryPurple,
                            title: t('dark_mode'),
                            subtitle: t('dark_mode_sub'),
                            trailing: Switch(
                              value: themeProvider.isDarkMode,
                              onChanged: (_) => themeProvider.toggleTheme(),
                              activeColor: AppColors.primaryPurple,
                            ),
                          ),

                          const Divider(height: 1, indent: 56),

                          // Language setting
                          _SettingsTile(
                            icon: Icons.language,
                            iconColor: Colors.blue,
                            title: t('language_settings'),
                            subtitle: locale.isEnglish ? 'English' : 'Indonesia',
                            trailing: const Icon(Icons.chevron_right,
                                color: Colors.grey),
                            onTap: () =>
                                _showLanguageDialog(context, locale),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // ── About Card ────────────────────────────────────
                      _SettingsCard(
                        children: [
                          _SettingsTile(
                            icon: Icons.info_outline,
                            iconColor: Colors.green,
                            title: t('about_app'),
                            subtitle:
                                '${AppConstants.appName} v${AppConstants.appVersion}',
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // ── Logout Card ───────────────────────────────────
                      _SettingsCard(
                        children: [
                          _SettingsTile(
                            icon: Icons.logout,
                            iconColor: AppColors.error,
                            title: t('logout'),
                            titleColor: AppColors.error,
                            onTap: () =>
                                _showLogoutDialog(context, authProvider, t),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Language picker dialog
  void _showLanguageDialog(BuildContext context, LocaleProvider locale) {
    final t = locale.translate;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                t('language_settings'),
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),

              // English option
              _LanguageOption(
                flag: '🇺🇸',
                language: 'English',
                isSelected: locale.isEnglish,
                onTap: () async {
                  await locale.setEnglish();
                  if (ctx.mounted) Navigator.pop(ctx);
                },
              ),
              const SizedBox(height: 12),

              // Indonesian option
              _LanguageOption(
                flag: '🇮🇩',
                language: 'Indonesia',
                isSelected: locale.isIndonesian,
                onTap: () async {
                  await locale.setIndonesian();
                  if (ctx.mounted) Navigator.pop(ctx);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showLogoutDialog(
      BuildContext context, AuthProvider authProvider, String Function(String) t) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(t('logout'),
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text(t('logout_confirm'),
            style: GoogleFonts.poppins(fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(t('cancel')),
          ),
          TextButton(
            onPressed: () async {
              await authProvider.logout();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const SplashScreen()),
                  (route) => false,
                );
              }
            },
            child: Text(
              t('logout'),
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Language Option Tile ─────────────────────────────────────────────────────
class _LanguageOption extends StatelessWidget {
  final String flag;
  final String language;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.flag,
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryPurple.withValues(alpha: 0.1)
              : Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryPurple : Colors.grey[200]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 14),
            Text(
              language,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? AppColors.primaryPurple
                    : AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle,
                  color: AppColors.primaryPurple, size: 22),
          ],
        ),
      ),
    );
  }
}

// ── Reusable Settings Card ───────────────────────────────────────────────────
class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(children: children),
    );
  }
}

// ── Reusable Settings Tile ───────────────────────────────────────────────────
class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Color? titleColor;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.titleColor,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: titleColor ?? AppColors.textPrimary,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: GoogleFonts.poppins(
                  fontSize: 12, color: Colors.grey[500]),
            )
          : null,
      trailing: trailing,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}