import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/onboarding_controller.dart';
import '../../domain/entities/subscription_plan.dart';
import '../../../shop/presentation/views/explore_view.dart';

class OnboardingSubscriptionScreen extends ConsumerWidget {
  const OnboardingSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Choose your\nsubscription plan',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  height: 1.02,
                  letterSpacing: -1.1,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'And get a 7-day free trial',
                style: TextStyle(color: Color(0xFF7D8491), fontSize: 16),
              ),
              const SizedBox(height: 22),
              ...SubscriptionPlan.values.map((plan) {
                final selected = state.selectedPlan == plan;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _PlanTile(
                    plan: plan,
                    selected: selected,
                    onTap: () => controller.selectPlan(plan),
                  ),
                );
              }),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F1F5),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'You\'ll get:',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 14),
                    _BenefitRow(text: 'Unlimited access'),
                    SizedBox(height: 10),
                    _BenefitRow(text: '200GB storage'),
                    SizedBox(height: 10),
                    _BenefitRow(text: 'Sync all your devices'),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    final selectedPlan = state.selectedPlan;
                    if (selectedPlan == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select a plan first.'),
                        ),
                      );
                      return;
                    }

                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute<void>(
                        builder: (_) => const ExploreView(),
                      ),
                      (route) => false,
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF1E6EF2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    minimumSize: const Size.fromHeight(56),
                  ),
                  child: const Text('Subscribe'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlanTile extends StatelessWidget {
  const _PlanTile({
    required this.plan,
    required this.selected,
    required this.onTap,
  });

  final SubscriptionPlan plan;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE4EBF8) : const Color(0xFFF7F8FA),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? Colors.transparent : const Color(0xFFE0E3E8),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color:
                  selected ? const Color(0xFF1E6EF2) : const Color(0xFFBCC2CC),
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E2229),
                    ),
                  ),
                  if (plan.discount != null)
                    Text(
                      plan.discount!,
                      style: const TextStyle(
                        color: Color(0xFF1E6EF2),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  plan.price,
                  style: const TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E2229),
                  ),
                ),
                Text(
                  plan.period,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF666D79),
                  ),
                ),
              ],
            ),
            if (selected && plan.highlighted)
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Color(0xFF1E6EF2),
                  child: Icon(Icons.star, size: 12, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BenefitRow extends StatelessWidget {
  const _BenefitRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star, size: 14, color: Color(0xFF1E6EF2)),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF7B8290),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
