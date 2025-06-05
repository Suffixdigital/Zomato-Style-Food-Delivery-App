import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_flutter/core/constants/app_colors.dart';
import 'package:smart_flutter/core/constants/text_styles.dart';
import 'package:smart_flutter/model/chat_model.dart';

class ChatTile extends ConsumerWidget {
  final ChatModel chat;
  final bool isTablet;

  const ChatTile({super.key, required this.isTablet, required this.chat});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.neutral0,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral40,
            blurRadius: 4.r,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 2.w, right: 8.w),
            child: Image.asset(chat.avatar),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chat.name,
                style: AppTextTheme.fallback(
                  isTablet: isTablet,
                ).bodyMediumSemiBold!.copyWith(color: AppColors.neutral100),
              ),
              SizedBox(height: 2.h),
              Text(
                chat.message,
                style: AppTextTheme.fallback(
                  isTablet: isTablet,
                ).bodySmallMedium!.copyWith(color: AppColors.neutral60),
              ),
            ],
          ),
          Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                chat.time,
                style: AppTextTheme.fallback(
                  isTablet: isTablet,
                ).bodySmallMedium!.copyWith(color: AppColors.neutral60),
              ),
              SizedBox(height: 2.h),
              if (chat.isDelivered)
                SvgPicture.asset("assets/icons/double_check.svg")
              else if (chat.unreadCount > 0)
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryAccent,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    chat.unreadCount.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 10.sp),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
    /*ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      leading: CircleAvatar(child: Image.asset(chat.avatar)),
      title: Text(
        chat.name,
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        chat.message,
        style: TextStyle(fontSize: 12.sp, color: Colors.grey),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            chat.time,
            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
          ),
          SizedBox(height: 4.h),
          if (chat.isDelivered)
            Icon(Icons.check, size: 16.sp, color: Colors.orange)
          else if (chat.unreadCount > 0)
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: const BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
              child: Text(
                chat.unreadCount.toString(),
                style: TextStyle(color: Colors.white, fontSize: 10.sp),
              ),
            ),
        ],
      ),
    );*/
  }
}
