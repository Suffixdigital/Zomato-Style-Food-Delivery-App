import 'package:flutter/material.dart';

import '../core/data/page_data.dart';
import '../views/widgets/onboarding_screen/onboarding_card.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController controller = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,

      body: PageView.builder(
        controller: controller,
        onPageChanged: (index) => setState(() => currentPage = index),
        itemCount: pages.length,
        itemBuilder: (ctx, index) {
          return OnboardingCard(
            // pageDetail: pages[index],
            // isLast: index == images.length - 1,
            currentIndex: currentPage,
            onNext: () {
              if (currentPage < pages.length - 1) {
                controller.nextPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => const LoginScreen(
                          shouldForgotPasswordModelOnLoad: false,
                        ),
                  ),
                );
              }
            },
            onSkip: () {
              controller.jumpToPage(pages.length - 1);
            },
          );
        },
      ),
    );
  }
}
