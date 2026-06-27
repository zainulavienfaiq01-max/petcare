import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/audio_provider.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import 'emergency_contacts_screen.dart';
import 'notification_screen.dart'; // Added missing import
/// Redesigned Profile screen with gradient header, dark mode support,
/// language settings, and animated settings tiles.

const List<Map<String, String>> _languageOptions = [
  {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
  {'code': 'id', 'name': 'Indonesia', 'flag': '🇮🇩'},
  {'code': 'es', 'name': 'Español', 'flag': '🇪🇸'},
  {'code': 'fr', 'name': 'Français', 'flag': '🇫🇷'},
  {'code': 'de', 'name': 'Deutsch', 'flag': '🇩🇪'},
  {'code': 'it', 'name': 'Italiano', 'flag': '🇮🇹'},
  {'code': 'pt', 'name': 'Português', 'flag': '🇵🇹'},
  {'code': 'ru', 'name': 'Русский', 'flag': '🇷🇺'},
  {'code': 'ja', 'name': '日本語', 'flag': '🇯🇵'},
  {'code': 'ko', 'name': '한국어', 'flag': '🇰🇷'},
  {'code': 'zh', 'name': '中文', 'flag': '🇨🇳'},
  {'code': 'ar', 'name': 'العربية', 'flag': '🇸🇦'},
  {'code': 'hi', 'name': 'हिन्दी', 'flag': '🇮🇳'},
  {'code': 'tr', 'name': 'Türkçe', 'flag': '🇹🇷'},
  {'code': 'nl', 'name': 'Nederlands', 'flag': '🇳🇱'},
  {'code': 'pl', 'name': 'Polski', 'flag': '🇵🇱'},
  {'code': 'th', 'name': 'ไทย', 'flag': '🇹🇭'},
];

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
                            onPressed: () => _showEditProfileDialog(context, authProvider, t),
                            icon: const Icon(Icons.edit, size: 16),
                            label: Text(t('edit_profile') != 'edit_profile' ? t('edit_profile') : 'Edit Profile',
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
                              activeThumbColor: AppColors.primaryPurple,
                            ),
                          ),
                          _divider(isDark),
                          _SettingsTile(
                            icon: Icons.music_note,
                            iconColor: Colors.deepPurple,
                            title: t('bgm') != 'bgm' ? t('bgm') : 'Background Music',
                            subtitle: t('bgm_sub') != 'bgm_sub' ? t('bgm_sub') : 'Play relaxing background music',
                            isDark: isDark,
                            trailing: Switch(
                              value: audioProvider.isBgmEnabled,
                              onChanged: (_) => audioProvider.toggleBgm(),
                              activeThumbColor: AppColors.primaryPurple,
                            ),
                          ),
                          _divider(isDark),
                          _SettingsTile(
                            icon: Icons.language,
                            iconColor: Colors.blue,
                            title: t('language_settings'),
                            subtitle: _languageOptions.firstWhere((l) => l['code'] == locale.currentLanguageCode, orElse: () => _languageOptions.first)['name'],
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
                            title: t('notifications') != 'notifications' ? t('notifications') : 'Notifications',
                            subtitle: t('notifications_sub') != 'notifications_sub' ? t('notifications_sub') : 'Manage reminders & alerts',
                            isDark: isDark,
                            trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                            onTap: () {
                              context.read<AudioProvider>().playActionClick();
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationScreen()));
                            },
                          ),
                          _divider(isDark),
                          _SettingsTile(
                            icon: Icons.contact_emergency,
                            iconColor: AppColors.error,
                            title: t('emergency_contacts') != 'emergency_contacts' ? t('emergency_contacts') : 'Emergency Contacts',
                            subtitle: t('emergency_contacts_sub') != 'emergency_contacts_sub' ? t('emergency_contacts_sub') : 'Important numbers for pet emergencies',
                            isDark: isDark,
                            trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                            onTap: () {
                              context.read<AudioProvider>().playActionClick();
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const EmergencyContactsScreen()));
                            },
                          ),
                          _divider(isDark),
                          // Privacy & Security removed
                          _SettingsTile(
                            icon: Icons.help_outline,
                            iconColor: Colors.teal,
                            title: t('help_support') != 'help_support' ? t('help_support') : 'Help & Support',
                            subtitle: t('help_support_sub') != 'help_support_sub' ? t('help_support_sub') : 'FAQ & contact us',
                            isDark: isDark,
                            trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                            onTap: () => _showHelpSupportDialog(context, t),
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

                      // ── Logout Section ──────────────────────────────────
                      _SettingsGroup(
                        isDark: isDark,
                        children: [
                          _SettingsTile(
                            icon: Icons.logout,
                            iconColor: AppColors.error,
                            title: t('logout'),
                            isDark: isDark,
                            onTap: () => _showLogoutDialog(context, authProvider, t),
                          ),
                        ],
                      ),
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
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.cardDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          builder: (_, controller) {
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
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.separated(
                      controller: controller,
                      itemCount: _languageOptions.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final lang = _languageOptions[index];
                        return _LanguageOption(
                          flag: lang['flag']!,
                          language: lang['name']!,
                          isSelected: locale.currentLanguageCode == lang['code'],
                          isDark: isDark,
                          onTap: () async {
                            await locale.setLocale(lang['code']!);
                            if (ctx.mounted) Navigator.pop(ctx);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ── Logout dialog ───────────────────────────────────────────────────────
  void _showLogoutDialog(BuildContext context, AuthProvider auth, String Function(String) t) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.cardDark : Colors.white,
        title: Text(t('logout'), style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.error)),
        content: Text(t('logout_confirm'), style: GoogleFonts.poppins()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(t('cancel'), style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              auth.logout();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(t('logout'), style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ── Edit Profile Dialog ──────────────────────────────────────────────────
  void _showEditProfileDialog(BuildContext context, AuthProvider auth, String Function(String) t) {
    final nameController = TextEditingController(text: auth.userName);
    final emailController = TextEditingController(text: auth.userEmail);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.cardDark : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          t('edit_profile') != 'edit_profile' ? t('edit_profile') : 'Edit Profile',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: t('username') != 'username' ? t('username') : 'Username',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(t('cancel'), style: const TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              auth.updateProfile(nameController.text.trim(), emailController.text.trim());
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryPurple,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(t('save'), style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ── Help & Support Dialog ────────────────────────────────────────────────
  void _showHelpSupportDialog(BuildContext context, String Function(String) t) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.cardDark : Colors.white,
        title: Text(
          t('help_support') != 'help_support' ? t('help_support') : 'Help & Support',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'For support, contact us at:\nsupport@petcare.com\n\nOr visit our website.',
          style: GoogleFonts.poppins(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(t('close'), style: const TextStyle(color: AppColors.primaryPurple)),
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
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isDark;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.isDark,
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
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
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