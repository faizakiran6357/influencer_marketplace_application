
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:influencer_marketplace_application/get_server_key.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;

/// Notification Service handles FCM & local notifications on the main isolate
class NotificationService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static final SupabaseClient _supabase = Supabase.instance.client;
  static final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  /// Initialize FCM & local notifications — call this on the main isolate only
  static Future<void> initNotifications() async {
    // Request permissions (Android will ignore most settings but iOS needs this)
    await _fcm.requestPermission(alert: true, badge: true, sound: true);

    // Initialize local notifications plugin (Android)
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);

    await _local.initialize(initSettings,
        onDidReceiveNotificationResponse: (details) {
      // Handle notification tap
      debugPrint("🔔 Notification tapped (payload): ${details.payload}");
      // You can navigate using navigatorKey if desired:
      // final data = details.payload != null ? jsonDecode(details.payload!) : null;
      // navigatorKey.currentState?.pushNamed('/someRoute', arguments: data);
    });

    // Foreground message handler — convert remote message to local notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('📩 onMessage received (foreground): ${message.notification?.title}');
      if (message.notification != null) {
        showLocalNotification(message);
      }
    });

    // When the app is opened from a notification (background -> foreground)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('📩 onMessageOpenedApp: ${message.data}');
      // handle navigation if needed using navigatorKey
    });

    // Save FCM token (profiles table) for current user if logged in
    try {
      final token = await _fcm.getToken();
      if (token != null) {
        await _saveTokenToUser(token);
      }
    } catch (e) {
      debugPrint('⚠️ Error fetching FCM token: $e');
    }

    // Handle token refresh
    _fcm.onTokenRefresh.listen((newToken) async {
      await _saveTokenToUser(newToken);
    });
  }

  /// Show a local notification on the main isolate (foreground)
  static Future<void> showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'default_channel',
      'General Notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    try {
      await _local.show(
        notification.hashCode,
        notification.title,
        notification.body,
        platformDetails,
        payload: jsonEncode(message.data),
      );
    } catch (e) {
      debugPrint('⚠️ showLocalNotification failed: $e');
    }
  }

  /// Save FCM token to Supabase 'profiles' table
  static Future<void> _saveTokenToUser(String token) async {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      try {
        await _supabase.from('profiles').update({'fcm_token': token}).eq('id', user.id);
        debugPrint("✅ FCM Token saved for user: ${user.email}");
      } catch (e) {
        debugPrint('❌ Error saving token to profiles: $e');
      }
    } else {
      debugPrint('⚠️ No authenticated user to save FCM token for.');
    }
  }

  /// Send push message via Firebase HTTP v1 API (server-side service account token)
  static Future<void> sendPushMessage({
    required String targetToken,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    final accessToken = await GetServerKey().getServerKeyToken();

    final url = Uri.parse(
        'https://fcm.googleapis.com/v1/projects/influencer-marketing-app-b76fc/messages:send');

    final message = {
      "message": {
        "token": targetToken,
        "notification": {"title": title, "body": body},
        "data": data ?? {"click_action": "FLUTTER_NOTIFICATION_CLICK"}
      }
    };

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode(message),
      );

      if (response.statusCode == 200) {
        debugPrint("✅ Notification sent successfully!");
      } else {
        debugPrint("❌ Failed to send notification: ${response.body}");
      }
    } catch (e) {
      debugPrint('❌ sendPushMessage error: $e');
    }
  }
}
