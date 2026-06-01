import '../entities/interest_topic.dart';
import '../repositories/onboarding_repository.dart';

class SaveSelectedTopicsUseCase {
  const SaveSelectedTopicsUseCase({required this.repository});

  final OnboardingRepository repository;

  Future<void> call(Set<InterestTopic> topics) async {
    return repository.saveSelectedTopics(topics);
  }
}
