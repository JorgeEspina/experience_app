import '../repositories/onboarding_repository.dart';

class CompleteOnboardingUseCase {
  const CompleteOnboardingUseCase({required this.repository});

  final OnboardingRepository repository;

  Future<void> call() async {
    return repository.completeOnboarding();
  }
}
