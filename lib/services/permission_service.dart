import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// Centralized permission management service.
/// Handles requesting and checking permissions for
/// notifications, camera, media/gallery, and calendar.
class PermissionService {
  static final PermissionService _instance = PermissionService._internal();
  factory PermissionService() => _instance;
  PermissionService._internal();

  /// Request all essential permissions on first launch.
  Future<void> requestInitialPermissions() async {
    await requestNotificationPermission();
    await requestCameraPermission();
    await requestMediaPermission();
    await requestCalendarPermission();
  }

  /// Request notification permission.
  Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isGranted) return true;
    final result = await Permission.notification.request();
    debugPrint('PermissionService: Notification permission: $result');
    return result.isGranted;
  }

  /// Request camera permission.
  Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.status;
    if (status.isGranted) return true;
    final result = await Permission.camera.request();
    debugPrint('PermissionService: Camera permission: $result');
    return result.isGranted;
  }

  /// Request media/gallery permission.
  Future<bool> requestMediaPermission() async {
    final status = await Permission.photos.status;
    if (status.isGranted) return true;
    final result = await Permission.photos.request();
    debugPrint('PermissionService: Photos permission: $result');
    return result.isGranted;
  }

  /// Request calendar permission.
  Future<bool> requestCalendarPermission() async {
    final status = await Permission.calendarFullAccess.status;
    if (status.isGranted) return true;
    final result = await Permission.calendarFullAccess.request();
    debugPrint('PermissionService: Calendar permission: $result');
    return result.isGranted;
  }

  /// Check if all essential permissions are granted.
  Future<Map<String, bool>> checkAllPermissions() async {
    return {
      'notification': await Permission.notification.isGranted,
      'camera': await Permission.camera.isGranted,
      'photos': await Permission.photos.isGranted,
      'calendar': await Permission.calendarFullAccess.isGranted,
    };
  }

  /// Show a dialog to guide user to app settings if permission is denied.
  static Future<void> showPermissionDeniedDialog(
    BuildContext context,
    String permissionName,
  ) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF2A2A4A) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Permission Required',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          '$permissionName permission is required for this feature. Please enable it in your device settings.',
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}
