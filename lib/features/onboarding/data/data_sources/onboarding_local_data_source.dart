import '../../domain/entities/interest_topic.dart';
import '../../domain/entities/subscription_plan.dart';
import '../models/interest_topic_model.dart';
import '../models/subscription_plan_model.dart';

class OnboardingLocalDataSource {
  Set<InterestTopic> _savedTopics = {};
  SubscriptionPlan? _savedPlan;
  bool _onboardingCompleted = false;

  Future<List<InterestTopicModel>> getAvailableTopics() async {
    return InterestTopic.values
        .map((t) => InterestTopicModel.fromEntity(t))
        .toList();
  }

  Future<List<SubscriptionPlanModel>> getAvailablePlans() async {
    return SubscriptionPlan.values
        .map((p) => SubscriptionPlanModel.fromEntity(p))
        .toList();
  }

  Future<void> saveSelectedTopics(Set<InterestTopic> topics) async {
    _savedTopics = topics;
  }

  Future<void> saveSelectedPlan(SubscriptionPlan plan) async {
    _savedPlan = plan;
  }

  Future<void> completeOnboarding() async {
    _onboardingCompleted = true;
  }

  bool get isOnboardingCompleted => _onboardingCompleted;
  Set<InterestTopic> get savedTopics => _savedTopics;
  SubscriptionPlan? get savedPlan => _savedPlan;
}
