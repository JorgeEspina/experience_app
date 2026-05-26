import 'package:go_router/go_router.dart';
import 'package:experience_app/features/onboarding/presentation/views/onboarding_view.dart';
import 'package:experience_app/features/shop/presentation/views/explore_view.dart';
import 'package:experience_app/features/shop/presentation/views/cart_view.dart';
import 'package:experience_app/features/shop/presentation/views/checkout_view.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      name: Routes.onboarding,
      path: '/',
      builder: (context, state) => const OnboardingView(),
    ),
    GoRoute(
      name: Routes.explore,
      path: '/explore',
      builder: (context, state) => const ExploreView(),
    ),
    GoRoute(
      name: Routes.cart,
      path: '/cart',
      builder: (context, state) => const CartView(),
    ),
    GoRoute(
      name: Routes.checkout,
      path: '/checkout',
      builder: (context, state) => const CheckoutView(),
    ),
  ],
);

abstract class Routes {
  static const String onboarding = 'onboarding';
  static const String explore = 'explore';
  static const String cart = 'cart';
  static const String checkout = 'checkout';
}
