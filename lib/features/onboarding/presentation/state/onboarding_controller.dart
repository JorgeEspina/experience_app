import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/interest_topic.dart';
import '../../domain/entities/subscription_plan.dart';
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
}

final onboardingControllerProvider =
    NotifierProvider<OnboardingController, OnboardingState>(
  OnboardingController.new,
);
