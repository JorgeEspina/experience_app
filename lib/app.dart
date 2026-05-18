import 'package:flutter/material.dart';

import 'features/onboarding/presentation/onboarding_intro_screen.dart';

class ExperienceApp extends StatelessWidget {
  const ExperienceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Experience App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1D6EF2)),
        scaffoldBackgroundColor: const Color(0xFFF3F4F7),
        useMaterial3: true,
      ),
      home: const OnboardingIntroScreen(),
    );
  }
}
