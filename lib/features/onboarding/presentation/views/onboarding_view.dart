import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/onboarding_providers.dart';
import 'onboarding_interests_screen.dart';

class OnboardingView extends ConsumerStatefulWidget {
  const OnboardingView({super.key});

  @override
  ConsumerState<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends ConsumerState<OnboardingView> {
  late final PageController _pageController;
  int _currentIndex = 0;

  static const List<_IntroSlide> _slides = [
    _IntroSlide(
      title: 'Create a prototype in just\na few minutes',
      description:
          'Enjoy these pre-made components and worry only\nabout creating the best product ever.',
      icon: Icons.image_outlined,
      background: Color(0xFFDDE6F3),
    ),
    _IntroSlide(
      title: 'Build flows that\nfeel polished',
      description:
          'Start faster with reusable blocks and focus on\nwhat really matters: your user journey.',
      icon: Icons.auto_awesome_outlined,
      background: Color(0xFFE4EEF7),
    ),
    _IntroSlide(
      title: 'Validate ideas with\nyour team',
      description:
          'Share early, gather insights quickly, and iterate\nwithout slowing down your process.',
      icon: Icons.groups_2_outlined,
      background: Color(0xFFE6ECF8),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(onboardingControllerProvider.notifier);
    final slide = _slides[_currentIndex];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _slides.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final item = _slides[index];
                      return ColoredBox(
                        color: item.background,
                        child: Center(
                          child: Icon(
                            item.icon,
                            size: 54,
                            color: const Color(0xFFA3B1C9),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    _PageDots(
                      currentIndex: _currentIndex,
                      total: _slides.length,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      slide.title,
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        height: 1.05,
                        letterSpacing: -0.8,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      slide.description,
                      style: const TextStyle(
                        color: Color(0xFF868A93),
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          final isLast = _currentIndex == _slides.length - 1;
                          if (!isLast) {
                            _pageController.animateToPage(
                              _currentIndex + 1,
                              duration: const Duration(milliseconds: 260),
                              curve: Curves.easeOut,
                            );
                            return;
                          }

                          controller.goToStep(2);
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const OnboardingInterestsScreen(),
                            ),
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF1E6EF2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          minimumSize: const Size.fromHeight(56),
                        ),
                        child: const Text('Next'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IntroSlide {
  const _IntroSlide({
    required this.title,
    required this.description,
    required this.icon,
    required this.background,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color background;
}

class _PageDots extends StatelessWidget {
  const _PageDots({required this.currentIndex, required this.total});

  final int currentIndex;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(total, (index) {
        final selected = index == currentIndex;
        return Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color:
                selected ? const Color(0xFF1E6EF2) : const Color(0xFFD5D8DE),
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}
