import 'package:flutter/material.dart';

class NotificationBadge extends StatelessWidget {
  final int count;
  final IconData icon;
  final VoidCallback onTap;
  final Color? badgeColor;
  final Color? iconColor;
  final Color? backgroundColor;

  const NotificationBadge({
    super.key,
    required this.count,
    required this.icon,
    required this.onTap,
    this.badgeColor,
    this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Icon(
              icon,
              color: iconColor ?? Colors.white,
              size: 24,
            ),
          ),
        ),
        if (count > 0)
          Positioned(
            right: 0,
            top: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.elasticOut,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: badgeColor ?? Colors.red,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              constraints: const BoxConstraints(
                minWidth: 20,
                minHeight: 20,
              ),
              child: Text(
                count > 99 ? '99+' : count.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

// Model for notifications
class NotificationModel {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final String type; // 'emergency', 'update', 'info'
  final bool isRead;
  final String? imageUrl;
  final Map<String, dynamic>? actionData;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,
    this.imageUrl,
    this.actionData,
  });
}

// Mock notification service - Replace with backend integration
class NotificationService {
  static final List<NotificationModel> _mockNotifications = [
    NotificationModel(
      id: '1',
      title: 'Gempa Bumi Garut - Update Terbaru',
      message: 'Tim rescue telah tiba di lokasi. Status: Dalam penanganan.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      type: 'emergency',
    ),
    NotificationModel(
      id: '2',
      title: 'Laporan Banjir Bekasi Diterima',
      message: 'Laporan Anda telah diterima dan sedang diverifikasi oleh tim.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      type: 'update',
      isRead: true,
    ),
    NotificationModel(
      id: '3',
      title: 'Pelatihan Relawan Tersedia',
      message: 'Daftar pelatihan rescue terbaru untuk meningkatkan skill.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      type: 'info',
    ),
  ];

  // TODO: Backend Integration
  // Replace these methods with actual API calls
  static List<NotificationModel> getAllNotifications() {
    return _mockNotifications;
  }

  static int getUnreadCount() {
    return _mockNotifications.where((n) => !n.isRead).length;
  }

  static void markAsRead(String notificationId) {
    // TODO: Send API request to mark notification as read
    final index = _mockNotifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _mockNotifications[index] = NotificationModel(
        id: _mockNotifications[index].id,
        title: _mockNotifications[index].title,
        message: _mockNotifications[index].message,
        timestamp: _mockNotifications[index].timestamp,
        type: _mockNotifications[index].type,
        isRead: true,
        imageUrl: _mockNotifications[index].imageUrl,
        actionData: _mockNotifications[index].actionData,
      );
    }
  }

  static void markAllAsRead() {
    // TODO: Send API request to mark all notifications as read
    for (int i = 0; i < _mockNotifications.length; i++) {
      _mockNotifications[i] = NotificationModel(
        id: _mockNotifications[i].id,
        title: _mockNotifications[i].title,
        message: _mockNotifications[i].message,
        timestamp: _mockNotifications[i].timestamp,
        type: _mockNotifications[i].type,
        isRead: true,
        imageUrl: _mockNotifications[i].imageUrl,
        actionData: _mockNotifications[i].actionData,
      );
    }
  }
}
