import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/onboarding_controller.dart';
import '../../domain/entities/interest_topic.dart';
import 'onboarding_subscription_screen.dart';

class OnboardingInterestsScreen extends ConsumerWidget {
  const OnboardingInterestsScreen({super.key});

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
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: const LinearProgressIndicator(
                  value: 0.5,
                  minHeight: 6,
                  color: Color(0xFF1E6EF2),
                  backgroundColor: Color(0xFFD7DCE5),
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Personalise your\nexperience',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  height: 1.02,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Choose your interests.',
                style: TextStyle(color: Color(0xFF7A818F), fontSize: 15),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  itemCount: InterestTopic.values.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final topic = InterestTopic.values[index];
                    final isSelected = state.selectedTopics.contains(topic);

                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => controller.toggleTopic(topic),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFE4EBF8)
                              : const Color(0xFFF4F4F5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : const Color(0xFFE0E2E6),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                topic.label,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF31343A),
                                ),
                              ),
                            ),
                            Icon(
                              isSelected
                                  ? Icons.check_rounded
                                  : Icons.circle_outlined,
                              size: 18,
                              color: isSelected
                                  ? const Color(0xFF1E6EF2)
                                  : const Color(0xFFBBC1CC),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    if (state.selectedTopics.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Select at least one interest to continue.',
                          ),
                        ),
                      );
                      return;
                    }

                    controller.goToStep(3);
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const OnboardingSubscriptionScreen(),
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF1E6EF2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    minimumSize: const Size.fromHeight(56),
                  ),
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
