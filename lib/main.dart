import 'package:experience_app/app_colors.dart';
import 'package:experience_app/core/local_storage.dart';
import 'package:experience_app/core/notifications/push_notification_provider.dart';
import 'package:experience_app/core/notifications/push_notification_service.dart';
import 'package:experience_app/features/auth/presentation/views/login_view.dart';
import 'package:experience_app/features/shop/presentation/state/shop_providers.dart';
import 'package:experience_app/features/shop/presentation/views/order_detail_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';

/// Global navigator key so notification taps can navigate from anywhere.
final navigatorKey = GlobalKey<NavigatorState>();

/// Toggle to point the app at the local Firebase emulators. Enable with:
///   flutter run --dart-define=USE_EMULATORS=true
const bool _useEmulators =
    bool.fromEnvironment('USE_EMULATORS', defaultValue: false);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (_useEmulators) {
    // 10.0.2.2 is the host machine's localhost from the Android emulator.
    const host = '10.0.2.2';
    FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
    await FirebaseAuth.instance.useAuthEmulator(host, 9099);
  }

  // Register the background message handler (must be top-level).
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await LocalStorage().init();
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  @override
  void initState() {
    super.initState();
    _setupNotifications();
  }

  Future<void> _setupNotifications() async {
    final service = ref.read(pushNotificationServiceProvider);
    service.onOrderTapped = _openOrder;
    await service.initialize();
  }

  /// Loads the order by id and opens its detail screen.
  Future<void> _openOrder(String orderId) async {
    final navigator = navigatorKey.currentState;
    if (navigator == null) return;
    try {
      final order =
          await ref.read(orderRepositoryProvider).getOrderById(orderId);
      navigator.push(
        MaterialPageRoute<void>(
          builder: (_) => OrderDetailView(order: order),
        ),
      );
    } catch (_) {
      // Order not found or not accessible; ignore.
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E6EF2)),
        scaffoldBackgroundColor: const Color(0xFFF3F4F7),
        useMaterial3: true,
      ),
      title: 'Experience App',
      home: const LoginView(),
    );
  }
}
