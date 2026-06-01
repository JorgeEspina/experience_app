import '../../domain/entities/interest_topic.dart';
import '../../domain/entities/subscription_plan.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../data_sources/onboarding_local_data_source.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  const OnboardingRepositoryImpl({required this.localDataSource});

  final OnboardingLocalDataSource localDataSource;

  @override
  Future<List<InterestTopic>> getAvailableTopics() async {
    final models = await localDataSource.getAvailableTopics();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<SubscriptionPlan>> getAvailablePlans() async {
    final models = await localDataSource.getAvailablePlans();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> saveSelectedTopics(Set<InterestTopic> topics) async {
    await localDataSource.saveSelectedTopics(topics);
  }

  @override
  Future<void> saveSelectedPlan(SubscriptionPlan plan) async {
    await localDataSource.saveSelectedPlan(plan);
  }

  @override
  Future<void> completeOnboarding() async {
    await localDataSource.completeOnboarding();
  }
}
