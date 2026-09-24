import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Handles a background/terminated message. Must be a top-level function.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // No heavy work here; the tap handling happens when the app opens.
}

/// Centralizes Firebase Cloud Messaging: permissions, token storage,
/// foreground notifications and tap routing.
///
/// When a notification is tapped, [onOrderTapped] is called with the orderId
/// found in the message data (if any), so the app can open the order detail.
class PushNotificationService {
  PushNotificationService({
    FirebaseMessaging? messaging,
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _messaging = messaging ?? FirebaseMessaging.instance,
        _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseMessaging _messaging;
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'orders_channel',
    'Pedidos',
    description: 'Notificaciones sobre tus compras',
    importance: Importance.high,
  );

  /// Called with the orderId when a notification is tapped.
  void Function(String orderId)? onOrderTapped;

  bool _initialized = false;

  /// Initialize once, early in app startup (after Firebase.initializeApp).
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    // Ask for permission (Android 13+, iOS).
    await _messaging.requestPermission();

    // Set up local notifications for foreground display on Android.
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        final orderId = response.payload;
        if (orderId != null && orderId.isNotEmpty) {
          onOrderTapped?.call(orderId);
        }
      },
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    // Foreground messages: show a local notification.
    FirebaseMessaging.onMessage.listen(_showForegroundNotification);

    // App opened from background via notification tap.
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageTap);

    // App opened from terminated state via notification tap.
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageTap(initialMessage);
    }

    // Keep the token fresh.
    _messaging.onTokenRefresh.listen((token) {
      final uid = _auth.currentUser?.uid;
      if (uid != null) _saveToken(uid, token);
    });
  }

  /// Registers the current device token for [uid]. Call after sign-in.
  Future<void> registerTokenForUser(String uid) async {
    try {
      final token = await _messaging.getToken();
      if (token != null) await _saveToken(uid, token);
    } catch (e) {
      if (kDebugMode) {
        // Getting a token can fail on emulators without Play Services.
        debugPrint('FCM token error: $e');
      }
    }
  }

  Future<void> _saveToken(String uid, String token) async {
    await _firestore.collection('users').doc(uid).set(
      {
        'fcmTokens': FieldValue.arrayUnion([token]),
      },
      SetOptions(merge: true),
    );
  }

  /// Shows a local notification for an approved order. Used to notify the
  /// buyer on-device right after a successful purchase. Tapping it opens the
  /// order detail (payload carries the orderId).
  Future<void> showLocalOrderNotification({
    required String orderId,
    required String title,
    required String body,
  }) async {
    await _localNotifications.show(
      orderId.hashCode,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      payload: orderId,
    );
  }

  void _showForegroundNotification(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      payload: message.data['orderId'] as String?,
    );
  }

  void _handleMessageTap(RemoteMessage message) {
    final orderId = message.data['orderId'] as String?;
    if (orderId != null && orderId.isNotEmpty) {
      onOrderTapped?.call(orderId);
    }
  }
}
