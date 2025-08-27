import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_flutter/core/constants/text_styles.dart';
import 'package:smart_flutter/theme/app_colors.dart';
import 'package:smart_flutter/viewmodels/chat_viewmodel.dart';
import 'package:smart_flutter/views/widgets/chat_screen/chat_header.dart';
import 'package:smart_flutter/views/widgets/chat_screen/chat_tile.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).extension<AppTextTheme>()!;
    final chats = ref.watch(chatViewModelProvider).getChats();
    // Transparent status bar
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Makes status bar transparent
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return ScreenUtilInit(
      designSize: Size(375, 812),
      minTextAdapt: true,
      builder:
          (context, child) => Scaffold(
            extendBodyBehindAppBar: true, // Allows layout behind status bar
            body: Stack(
              children: [
                // Repeated background behind everything including status bar
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        opacity: 0.3,
                        image: AssetImage('assets/images/chat_background.png'),
                        // Your image
                        repeat: ImageRepeat.repeatY,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),

                // Foreground content
                SafeArea(
                  child: Column(
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
                            style: textTheme.bodyLargeSemiBold!.copyWith(
                              color: context.colors.generalText,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Expanded(
                        child: ListView.builder(
                          itemCount: chats.length,
                          itemBuilder:
                              (context, index) => ChatTile(chat: chats[index]),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
