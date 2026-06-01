import '../entities/interest_topic.dart';
import '../entities/subscription_plan.dart';

abstract class OnboardingRepository {
  Future<List<InterestTopic>> getAvailableTopics();
  Future<List<SubscriptionPlan>> getAvailablePlans();
  Future<void> saveSelectedTopics(Set<InterestTopic> topics);
  Future<void> saveSelectedPlan(SubscriptionPlan plan);
  Future<void> completeOnboarding();
}
