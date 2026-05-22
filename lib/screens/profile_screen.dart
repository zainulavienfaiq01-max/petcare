import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/audio_provider.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import 'splash_screen.dart';

/// Redesigned Profile screen with gradient header, dark mode support,
/// language settings, and animated settings tiles.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : Colors.grey[50],
      body: Consumer4<ThemeProvider, AuthProvider, LocaleProvider, AudioProvider>(
        builder: (context, themeProvider, authProvider, locale, audioProvider, child) {
          final t = locale.translate;

          return CustomScrollView(
            slivers: [
              // ── Gradient Profile Header ──────────────────────────────────
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
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                      child: Column(
                        children: [
                          // Top bar with dark mode toggle
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                t('profile'),
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // Dark mode toggle
                              GestureDetector(
                                onTap: () => themeProvider.toggleTheme(),
                                child: Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    isDark ? Icons.light_mode : Icons.dark_mode,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Avatar
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  width: 3),
                            ),
                            child: const Center(
                              child: Icon(Icons.person,
                                  size: 48, color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Name
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
                            authProvider.userEmail.isNotEmpty
                                ? authProvider.userEmail
                                : 'user@petcare.com',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Edit profile button
                          OutlinedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Edit profile coming soon!')),
                              );
                            },
                            icon: const Icon(Icons.edit, size: 16),
                            label: Text('Edit Profile',
                                style: GoogleFonts.poppins(fontSize: 13)),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(
                                  color: Colors.white.withValues(alpha: 0.5)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ── Settings Cards ──────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // ── Appearance Section ──────────────────────────────
                      _SettingsGroup(
                        isDark: isDark,
                        children: [
                          _SettingsTile(
                            icon: isDark ? Icons.dark_mode : Icons.light_mode,
                            iconColor: Colors.amber,
                            title: t('dark_mode'),
                            subtitle: t('dark_mode_sub'),
                            isDark: isDark,
                            trailing: Switch(
                              value: themeProvider.isDarkMode,
                              onChanged: (_) => themeProvider.toggleTheme(),
                              activeColor: AppColors.primaryPurple,
                            ),
                          ),
                          _divider(isDark),
                          _SettingsTile(
                            icon: Icons.music_note,
                            iconColor: Colors.deepPurple,
                            title: 'Background Music',
                            subtitle: 'Play relaxing background music',
                            isDark: isDark,
                            trailing: Switch(
                              value: audioProvider.isBgmEnabled,
                              onChanged: (_) => audioProvider.toggleBgm(),
                              activeColor: AppColors.primaryPurple,
                            ),
                          ),
                          _divider(isDark),
                          _SettingsTile(
                            icon: Icons.language,
                            iconColor: Colors.blue,
                            title: t('language_settings'),
                            subtitle:
                                locale.isEnglish ? 'English' : 'Indonesia',
                            isDark: isDark,
                            trailing: const Icon(Icons.chevron_right,
                                color: Colors.grey, size: 20),
                            onTap: () =>
                                _showLanguageDialog(context, locale, t),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // ── App Section ─────────────────────────────────────
                      _SettingsGroup(
                        isDark: isDark,
                        children: [
                          _SettingsTile(
                            icon: Icons.notifications_outlined,
                            iconColor: Colors.orange,
                            title: 'Notifications',
                            subtitle: 'Manage reminders & alerts',
                            isDark: isDark,
                            trailing: const Icon(Icons.chevron_right,
                                color: Colors.grey, size: 20),
                          ),
                          _divider(isDark),
                          _SettingsTile(
                            icon: Icons.shield_outlined,
                            iconColor: Colors.green,
                            title: 'Privacy & Security',
                            subtitle: 'Password & data settings',
                            isDark: isDark,
                            trailing: const Icon(Icons.chevron_right,
                                color: Colors.grey, size: 20),
                          ),
                          _divider(isDark),
                          _SettingsTile(
                            icon: Icons.help_outline,
                            iconColor: Colors.teal,
                            title: 'Help & Support',
                            subtitle: 'FAQ & contact us',
                            isDark: isDark,
                            trailing: const Icon(Icons.chevron_right,
                                color: Colors.grey, size: 20),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // ── About Section ───────────────────────────────────
                      _SettingsGroup(
                        isDark: isDark,
                        children: [
                          _SettingsTile(
                            icon: Icons.info_outline,
                            iconColor: AppColors.primaryPurple,
                            title: t('about_app'),
                            subtitle:
                                '${AppConstants.appName} v${AppConstants.appVersion}',
                            isDark: isDark,
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // ── Logout ──────────────────────────────────────────
                      _SettingsGroup(
                        isDark: isDark,
                        children: [
                          _SettingsTile(
                            icon: Icons.logout,
                            iconColor: AppColors.error,
                            title: t('logout'),
                            titleColor: AppColors.error,
                            isDark: isDark,
                            onTap: () => _showLogoutDialog(
                                context, authProvider, t),
                          ),
                        ],
                      ),

                      const SizedBox(height: 60),
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

  Widget _divider(bool isDark) {
    return Divider(
      height: 1,
      indent: 56,
      color: isDark ? Colors.grey[800] : Colors.grey[200],
    );
  }

  // ── Language dialog ──────────────────────────────────────────────────────
  void _showLanguageDialog(
      BuildContext context, LocaleProvider locale, String Function(String) t) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.cardDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                t('language_settings'),
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              _LanguageOption(
                flag: '🇺🇸',
                language: 'English',
                isSelected: locale.isEnglish,
                isDark: isDark,
                onTap: () async {
                  await locale.setEnglish();
                  if (ctx.mounted) Navigator.pop(ctx);
                },
              ),
              const SizedBox(height: 12),
              _LanguageOption(
                flag: '🇮🇩',
                language: 'Indonesia',
                isSelected: locale.isIndonesian,
                isDark: isDark,
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

  // ── Logout dialog ────────────────────────────────────────────────────────
  void _showLogoutDialog(BuildContext context, AuthProvider authProvider,
      String Function(String) t) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.cardDark : Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(t('logout'),
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color:
                  isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            )),
        content: Text(t('logout_confirm'),
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondary,
            )),
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

// ── Settings Group Card ──────────────────────────────────────────────────────
class _SettingsGroup extends StatelessWidget {
  final List<Widget> children;
  final bool isDark;

  const _SettingsGroup({required this.children, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(children: children),
    );
  }
}

// ── Settings Tile ────────────────────────────────────────────────────────────
class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Color? titleColor;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isDark;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.isDark,
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
          color: titleColor ??
              (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color:
                    isDark ? AppColors.textSecondaryDark : Colors.grey[500],
              ),
            )
          : null,
      trailing: trailing,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}

// ── Language Option ──────────────────────────────────────────────────────────
class _LanguageOption extends StatelessWidget {
  final String flag;
  final String language;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.flag,
    required this.language,
    required this.isSelected,
    required this.isDark,
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
              : (isDark ? AppColors.surfaceDark : Colors.grey[50]),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryPurple
                : (isDark ? Colors.grey[700]! : Colors.grey[200]!),
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
                    : (isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimary),
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