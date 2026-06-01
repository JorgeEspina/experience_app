import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:experience_app/app_colors.dart';
import 'package:experience_app/core/local_storage.dart';
import 'package:experience_app/features/onboarding/presentation/views/onboarding_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage().init();
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E6EF2)),
        scaffoldBackgroundColor: const Color(0xFFF3F4F7),
        useMaterial3: true,
      ),
      title: 'Experience App',
      home: const OnboardingView(),
    );
  }
}
