import '../../domain/entities/interest_topic.dart';
import '../../domain/entities/subscription_plan.dart';

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
