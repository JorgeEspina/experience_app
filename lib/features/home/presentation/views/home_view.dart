import 'package:flutter/material.dart';
import 'package:experience_app/features/onboarding/presentation/views/onboarding_view.dart';
import 'package:experience_app/features/onboarding/presentation/views/onboarding_subscription_screen.dart';
import 'package:experience_app/features/shop/presentation/views/explore_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Experience App',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E2229),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Choose a module to explore',
                style: TextStyle(fontSize: 15, color: Color(0xFF9CA3AF)),
              ),
              const SizedBox(height: 40),
              _ModuleCard(
                title: 'Onboarding',
                subtitle: 'Intro slides, interests & subscription',
                icon: Icons.rocket_launch_outlined,
                color: const Color(0xFF8B5CF6),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const OnboardingView(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _ModuleCard(
                title: 'E-Commerce',
                subtitle: 'Explore products, cart & payment',
                icon: Icons.shopping_bag_outlined,
                color: const Color(0xFF1E6EF2),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const ExploreView(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _ModuleCard(
                title: 'Subscription',
                subtitle: 'Choose a plan and subscribe',
                icon: Icons.card_membership_outlined,
                color: const Color(0xFF16A34A),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const OnboardingSubscriptionScreen(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withAlpha(25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E2229),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFF9CA3AF),
            ),
          ],
        ),
      ),
    );
  }
}
