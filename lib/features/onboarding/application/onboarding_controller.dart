import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/interest_topic.dart';
import '../domain/subscription_plan.dart';

class OnboardingState {
  const OnboardingState({
    this.currentStep = 1,
    this.selectedTopics = const <InterestTopic>{},
    this.selectedPlan = SubscriptionPlan.yearly,
  });

  final int currentStep;
  final Set<InterestTopic> selectedTopics;
  final SubscriptionPlan? selectedPlan;

  OnboardingState copyWith({
    int? currentStep,
    Set<InterestTopic>? selectedTopics,
    SubscriptionPlan? selectedPlan,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      selectedTopics: selectedTopics ?? this.selectedTopics,
      selectedPlan: selectedPlan ?? this.selectedPlan,
    );
  }
}

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
