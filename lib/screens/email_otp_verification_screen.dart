import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:smart_flutter/core/constants/app_colors.dart';
import 'package:smart_flutter/core/constants/text_styles.dart';
import 'package:smart_flutter/core/utils/device_utils.dart';
import 'package:smart_flutter/screens/reset_password_screen.dart';

class EmailOtpVerificationScreen extends StatefulWidget {
  const EmailOtpVerificationScreen({super.key});

  @override
  State<EmailOtpVerificationScreen> createState() =>
      _EmailOtpVerificationScreenState();
}

class _EmailOtpVerificationScreenState
    extends State<EmailOtpVerificationScreen> {
  TextEditingController otpController = TextEditingController();
  int countdownSeconds = 30;
  late final String emailAddress;

  @override
  void initState() {
    super.initState();
    emailAddress = 'kirtik******@gmail.com'; // This would normally be passed in
    startTimer();
  }

  void startTimer() {
    Future.delayed(Duration(seconds: 1), () {
      if (mounted && countdownSeconds > 0) {
        setState(() {
          countdownSeconds--;
        });
        startTimer();
      }
    });
  }

  void onContinuePressed() {
    // Validate OTP and navigate
    final otp = otpController.text;
    if (otp.length == 4) {
      // Perform verification logic here
      debugPrint('OTP Verified: $otp');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ResetPasswordScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the valid OTP')),
      );
    }
  }

  void onResendPressed() {
    if (countdownSeconds == 0) {
      // Resend logic here
      setState(() {
        countdownSeconds = 30;
      });
      startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isTablet = screenSize.shortestSide >= 600;
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder:
          (context, child) => Scaffold(
            body: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.minHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: IconButton(
                                    padding: EdgeInsets.only(left: 20.h),
                                    icon: DeviceUtils.backIcon(
                                      'assets/icons/back.svg',
                                      AppColors.neutral100,
                                      16,
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ),

                                Text(
                                  'OTP',
                                  style: AppTextTheme.fallback(
                                    isTablet: isTablet,
                                  ).bodyLargeSemiBold!.copyWith(
                                    color: AppColors.neutral100,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 24.w, right: 24.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10.h),
                                  Text(
                                    'Email verification',
                                    style: AppTextTheme.fallback(
                                      isTablet: isTablet,
                                    ).headingH4SemiBold!.copyWith(
                                      color: AppColors.neutral100,
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  Text(
                                    'Enter the verification code we sent you on: $emailAddress',
                                    style: AppTextTheme.fallback(
                                      isTablet: isTablet,
                                    ).bodyMediumMedium!.copyWith(
                                      color: AppColors.neutral60,
                                    ),
                                  ),
                                  SizedBox(height: 35.h),
                                  PinCodeTextField(
                                    controller: otpController,
                                    appContext: context,
                                    length: 4,
                                    keyboardType: TextInputType.number,
                                    animationType: AnimationType.fade,
                                    pinTheme: PinTheme(
                                      shape: PinCodeFieldShape.box,
                                      borderRadius: BorderRadius.circular(10.r),
                                      fieldHeight: 70.h,
                                      fieldWidth: 70.w,
                                      activeFillColor: AppColors.neutral0,
                                      selectedColor: AppColors.primaryAccent,
                                      activeColor: AppColors.primaryAccent,
                                      inactiveColor: AppColors.neutral40,
                                      inactiveFillColor: AppColors.neutral0,
                                      selectedFillColor:
                                          AppColors.primaryAccent,
                                      borderWidth: 1.w,
                                    ),
                                    onChanged: (value) {},
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Didn't receive code?",
                                        style: AppTextTheme.fallback(
                                          isTablet: isTablet,
                                        ).bodyMediumSemiBold!.copyWith(
                                          color: AppColors.neutral60,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed:
                                            countdownSeconds == 0
                                                ? onResendPressed
                                                : null,
                                        child: Text(
                                          'Resend',
                                          style: AppTextTheme.fallback(
                                            isTablet: isTablet,
                                          ).bodyMediumSemiBold!.copyWith(
                                            color:
                                                countdownSeconds == 0
                                                    ? AppColors.primaryAccent
                                                    : AppColors.primaryAccent
                                                        .withValues(alpha: 0.5),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.access_time_rounded,
                                        size: 18,
                                        color: AppColors.neutral60,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        "${countdownSeconds.toString().padLeft(2, '0')}:00",
                                        style: AppTextTheme.fallback(
                                          isTablet: isTablet,
                                        ).bodyMediumMedium!.copyWith(
                                          color: AppColors.neutral60,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 30.h),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: onContinuePressed,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            AppColors.primaryAccent,
                                        padding: EdgeInsets.symmetric(
                                          vertical: 16.h,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            30.r,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        "Continue",
                                        style: AppTextTheme.fallback(
                                          isTablet: isTablet,
                                        ).bodyMediumSemiBold!.copyWith(
                                          color: AppColors.neutral0,
                                        ),
                                      ),
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
                },
              ),
            ),
          ),
    );
  }
}
