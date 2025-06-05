import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_flutter/core/constants/app_colors.dart';
import 'package:smart_flutter/core/constants/text_styles.dart';
import 'package:smart_flutter/viewmodels/chat_viewmodel.dart';
import 'package:smart_flutter/views/widgets/chat_screen/chat_header.dart';
import 'package:smart_flutter/views/widgets/chat_screen/chat_tile.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isTablet = screenSize.shortestSide >= 600;
    final chats = ref.watch(chatListProvider);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder:
          (context, child) => Scaffold(
            body: SafeArea(
              child: Stack(
                children: [
                  // Background image
                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        opacity: 0.2,
                        image: AssetImage('assets/images/chat_background.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),

                  // Foreground content
                  Column(
                    children: [
                      // Common Header (Back Button + Title)
                      ChatHeader(),
                      Padding(
                        padding: EdgeInsets.only(left: 16.w),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "All Message",
                            textAlign: TextAlign.start,
                            style: AppTextTheme.fallback(isTablet: isTablet)
                                .bodyLargeSemiBold!
                                .copyWith(color: AppColors.neutral100),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Expanded(
                        child: ListView.builder(
                          itemCount: chats.length,
                          itemBuilder:
                              (context, index) => ChatTile(
                                isTablet: isTablet,
                                chat: chats[index],
                              ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
