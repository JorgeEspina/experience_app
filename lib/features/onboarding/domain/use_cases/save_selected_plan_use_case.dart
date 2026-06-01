import '../entities/subscription_plan.dart';
import '../repositories/onboarding_repository.dart';

class SaveSelectedPlanUseCase {
  const SaveSelectedPlanUseCase({required this.repository});

  final OnboardingRepository repository;

  Future<void> call(SubscriptionPlan plan) async {
    return repository.saveSelectedPlan(plan);
  }
}
