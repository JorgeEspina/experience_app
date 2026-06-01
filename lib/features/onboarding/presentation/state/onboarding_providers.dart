import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/data_sources/onboarding_local_data_source.dart';
import '../../data/repositories/onboarding_repository_impl.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../../domain/use_cases/complete_onboarding_use_case.dart';
import '../../domain/use_cases/get_available_plans_use_case.dart';
import '../../domain/use_cases/get_available_topics_use_case.dart';
import '../../domain/use_cases/save_selected_plan_use_case.dart';
import '../../domain/use_cases/save_selected_topics_use_case.dart';
import 'onboarding_controller.dart';
import 'onboarding_state.dart';

// Data Sources
final onboardingLocalDataSourceProvider = Provider<OnboardingLocalDataSource>(
  (ref) => OnboardingLocalDataSource(),
);

// Repositories
final onboardingRepositoryProvider = Provider<OnboardingRepository>(
  (ref) => OnboardingRepositoryImpl(
    localDataSource: ref.read(onboardingLocalDataSourceProvider),
  ),
);

// Use Cases
final getAvailableTopicsUseCaseProvider = Provider<GetAvailableTopicsUseCase>(
  (ref) => GetAvailableTopicsUseCase(
    repository: ref.read(onboardingRepositoryProvider),
  ),
);

final getAvailablePlansUseCaseProvider = Provider<GetAvailablePlansUseCase>(
  (ref) => GetAvailablePlansUseCase(
    repository: ref.read(onboardingRepositoryProvider),
  ),
);

final saveSelectedTopicsUseCaseProvider = Provider<SaveSelectedTopicsUseCase>(
  (ref) => SaveSelectedTopicsUseCase(
    repository: ref.read(onboardingRepositoryProvider),
  ),
);

final saveSelectedPlanUseCaseProvider = Provider<SaveSelectedPlanUseCase>(
  (ref) => SaveSelectedPlanUseCase(
    repository: ref.read(onboardingRepositoryProvider),
  ),
);

final completeOnboardingUseCaseProvider = Provider<CompleteOnboardingUseCase>(
  (ref) => CompleteOnboardingUseCase(
    repository: ref.read(onboardingRepositoryProvider),
  ),
);

// Controller
final onboardingControllerProvider =
    NotifierProvider<OnboardingController, OnboardingState>(
  OnboardingController.new,
);
