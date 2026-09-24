import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'push_notification_service.dart';

/// Single app-wide instance of the push notification service.
final pushNotificationServiceProvider = Provider<PushNotificationService>(
  (ref) => PushNotificationService(),
);
