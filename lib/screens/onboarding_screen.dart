import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_flutter/routes/tab_controller_notifier.dart';
import 'package:smart_flutter/screens/link_expired_dialog.dart';
import 'package:smart_flutter/services/shared_preferences_service.dart';

import '../core/data/page_data.dart';
import '../views/widgets/onboarding_screen/onboarding_card.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController controller = PageController();
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final message = ref.read(linkExpiredMessage);

    print('linkExpiredMessage $message');
    if (message.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        LinkExpiredDialog.show(context, message);
        ref.watch(linkExpiredMessage.notifier).state = '';
      });
    }
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder:
          (context, child) => Scaffold(
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
                      SharedPreferencesService.markOnboardingCompleted();
                      context.goNamed('login', extra: false);
                    }
                  },
                  onSkip: () {
                    controller.jumpToPage(pages.length - 1);
                  },
                );
              },
            ),
          ),
    );
  }
}
