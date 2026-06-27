import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';

/// Notification data model for in-app notifications.
class NotificationItem {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final DateTime time;
  final String category; // schedule, vaccination, feeding, grooming, consultation
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.time,
    required this.category,
    this.isRead = false,
  });
}

/// Provider managing in-app notification state and badge count.
class NotificationProvider extends ChangeNotifier {
  final List<NotificationItem> _notifications = [];

  NotificationProvider() {
    _loadSampleNotifications();
  }

  List<NotificationItem> get notifications => _notifications;

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  void markAsRead(String id) {
    final idx = _notifications.indexWhere((n) => n.id == id);
    if (idx != -1) {
      _notifications[idx].isRead = true;
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (var n in _notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }

  void addNotification(NotificationItem item) {
    _notifications.insert(0, item);
    notifyListeners();
  }

  /// Pre-populate with sample notifications for demo
  void _loadSampleNotifications() {
    _notifications.addAll([
      NotificationItem(
        id: '1',
        title: 'Vaccination Reminder',
        subtitle: 'Your pet Milo is due for a rabies shot tomorrow.',
        icon: Icons.vaccines,
        color: Colors.red,
        time: DateTime.now().subtract(const Duration(minutes: 15)),
        category: 'vaccination',
      ),
      NotificationItem(
        id: '2',
        title: 'Feeding Time',
        subtitle: 'It\'s time to feed Luna. Don\'t forget her vitamins!',
        icon: Icons.restaurant,
        color: Colors.orange,
        time: DateTime.now().subtract(const Duration(hours: 1)),
        category: 'feeding',
      ),
      NotificationItem(
        id: '3',
        title: 'Grooming Scheduled',
        subtitle: 'Buddy\'s grooming session is tomorrow at 10:00 AM.',
        icon: Icons.content_cut,
        color: Colors.pink,
        time: DateTime.now().subtract(const Duration(hours: 3)),
        category: 'grooming',
      ),
      NotificationItem(
        id: '5',
        title: 'Schedule Reminder',
        subtitle: 'You have 3 pet activities scheduled for today.',
        icon: Icons.calendar_today,
        color: AppColors.primaryPurple,
        time: DateTime.now().subtract(const Duration(hours: 8)),
        category: 'schedule',
        isRead: true,
      ),
    ]);
  }
}

// ─── Notification Screen ─────────────────────────────────────────────────────
class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Use a simple demo list (in a real app, pull from provider)
    final notifications = [
      _NotifData(
        title: 'Vaccination Reminder',
        subtitle: 'Your pet Milo is due for a rabies shot tomorrow.',
        icon: Icons.vaccines,
        color: Colors.red,
        time: '15 min ago',
        isRead: false,
      ),
      _NotifData(
        title: 'Feeding Time',
        subtitle: "It's time to feed Luna. Don't forget her vitamins!",
        icon: Icons.restaurant,
        color: Colors.orange,
        time: '1 hour ago',
        isRead: false,
      ),
      _NotifData(
        title: 'Grooming Scheduled',
        subtitle: "Buddy's grooming session is tomorrow at 10:00 AM.",
        icon: Icons.content_cut,
        color: Colors.pink,
        time: '3 hours ago',
        isRead: false,
      ),
      _NotifData(
        title: 'Schedule Reminder',
        subtitle: 'You have 3 pet activities scheduled for today.',
        icon: Icons.calendar_today,
        color: AppColors.primaryPurple,
        time: '8 hours ago',
        isRead: true,
      ),
    ];

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Mark all read',
              style: GoogleFonts.poppins(
                color: AppColors.primaryPurple,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final n = notifications[index];
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: Duration(milliseconds: 300 + index * 80),
            curve: Curves.easeOutBack,
            builder: (context, value, child) => Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
            ),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: n.isRead
                    ? null
                    : Border.all(
                        color: n.color.withValues(alpha: 0.3), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                leading: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: n.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(n.icon, color: n.color, size: 22),
                ),
                title: Text(
                  n.title,
                  style: GoogleFonts.poppins(
                    fontWeight: n.isRead ? FontWeight.w500 : FontWeight.bold,
                    fontSize: 14,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimary,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      n.subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      n.time,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
                trailing: !n.isRead
                    ? Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: n.color,
                          shape: BoxShape.circle,
                        ),
                      )
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NotifData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String time;
  final bool isRead;

  _NotifData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.time,
    required this.isRead,
  });
}
