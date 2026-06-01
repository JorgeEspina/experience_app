import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/interest_topic.dart';
import '../../domain/entities/subscription_plan.dart';
import 'onboarding_providers.dart';
import 'onboarding_state.dart';

class OnboardingController extends Notifier<OnboardingState> {
  @override
  OnboardingState build() => const OnboardingState();

  void goToStep(int step) {
    state = state.copyWith(currentStep: step);
  }

  void toggleTopic(InterestTopic topic) {
    final updated = Set<InterestTopic>.from(state.selectedTopics);
    if (!updated.add(topic)) {
      updated.remove(topic);
    }
    state = state.copyWith(selectedTopics: updated);
  }

  void selectPlan(SubscriptionPlan plan) {
    state = state.copyWith(selectedPlan: plan);
  }

  Future<void> saveTopics() async {
    final saveTopics = ref.read(saveSelectedTopicsUseCaseProvider);
    await saveTopics(state.selectedTopics);
  }

  Future<void> subscribe() async {
    final plan = state.selectedPlan;
    if (plan == null) return;

    final savePlan = ref.read(saveSelectedPlanUseCaseProvider);
    final completeOnboarding = ref.read(completeOnboardingUseCaseProvider);

    await savePlan(plan);
    await completeOnboarding();
  }
}
