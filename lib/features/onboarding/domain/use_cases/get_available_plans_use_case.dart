import '../entities/subscription_plan.dart';
import '../repositories/onboarding_repository.dart';

class GetAvailablePlansUseCase {
  const GetAvailablePlansUseCase({required this.repository});

  final OnboardingRepository repository;

  Future<List<SubscriptionPlan>> call() async {
    return repository.getAvailablePlans();
  }
}
