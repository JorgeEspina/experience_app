import '../entities/interest_topic.dart';
import '../repositories/onboarding_repository.dart';

class GetAvailableTopicsUseCase {
  const GetAvailableTopicsUseCase({required this.repository});

  final OnboardingRepository repository;

  Future<List<InterestTopic>> call() async {
    return repository.getAvailableTopics();
  }
}
