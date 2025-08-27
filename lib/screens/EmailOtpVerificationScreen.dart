import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:smart_flutter/core/constants/app_colors.dart';
import 'package:smart_flutter/core/constants/text_styles.dart';
import 'package:smart_flutter/core/utils/device_utils.dart';
import 'package:smart_flutter/routes/tab_controller_notifier.dart';
import 'package:smart_flutter/services/shared_preferences_service.dart';
import 'package:smart_flutter/theme/app_colors.dart';
import 'package:smart_flutter/viewmodels/personal_data_viewmodel.dart';
import 'package:smart_flutter/viewmodels/register_viewmodel.dart';

class PhoneOtpVerificationScreen extends ConsumerStatefulWidget {
  final String phoneNumber;

  const PhoneOtpVerificationScreen({super.key, required this.phoneNumber});

  @override
  ConsumerState<PhoneOtpVerificationScreen> createState() => _PhoneOtpVerificationScreenState();
}

class _PhoneOtpVerificationScreenState extends ConsumerState<PhoneOtpVerificationScreen> {
  TextEditingController otpController = TextEditingController();
  int countdownSeconds = 30;

  @override
  void initState() {
    super.initState();
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

  void onContinuePressed() async {
    // Validate OTP and navigate
    final otp = otpController.text;
    if (otp.length == 6) {
      // Perform verification logic here
      // Call the ViewModel
      await ref.read(registerViewModelProvider.notifier).phoneOTPVerification(phoneNumber: widget.phoneNumber, otp: otp);

      final result = ref.read(registerViewModelProvider);

      result.when(
        data: (_) {
          SharedPreferencesService.setUserLoggedIn(true);
          SharedPreferencesService.setPhoneOTPAuthenticated(true);
          ref.read(tabIndexProvider.notifier).state = 0;
          ref.invalidate(personalDataProvider);
          // Go to home screen
          context.goNamed('home');
        },
        error: (error, _) {
          print('Error: $error');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $error')));
        },
        loading: () {
          // UI already shows CircularProgressIndicator
        },
      );

      //debugPrint('OTP Verified: $otp');
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ResetPasswordScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter the valid OTP')));
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
    final textTheme = Theme.of(context).extension<AppTextTheme>()!;
    final state = ref.watch(registerViewModelProvider);
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
                      constraints: BoxConstraints(minHeight: constraints.minHeight),
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
                                    icon: DeviceUtils.backIcon('assets/icons/back.svg', context.colors.generalText, 16),
                                    onPressed: () => context.goNamed('login'),
                                  ),
                                ),

                                Text('OTP Verification', style: textTheme.bodyLargeSemiBold!.copyWith(color: context.colors.generalText)),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 24.w, right: 24.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10.h),
                                  Text(
                                    'OTP Verification',
                                    style: AppTextTheme.fallback(isTablet: isTablet).headingH4SemiBold!.copyWith(color: AppColors.neutral100),
                                  ),
                                  SizedBox(height: 10.h),
                                  Text(
                                    'Enter the verification code we sent you on: +91${widget.phoneNumber}',
                                    style: AppTextTheme.fallback(isTablet: isTablet).bodyMediumMedium!.copyWith(color: AppColors.neutral60),
                                  ),
                                  SizedBox(height: 35.h),
                                  PinCodeTextField(
                                    controller: otpController,
                                    appContext: context,
                                    length: 6,
                                    keyboardType: TextInputType.number,
                                    animationType: AnimationType.fade,
                                    pinTheme: PinTheme(
                                      shape: PinCodeFieldShape.circle,

                                      fieldHeight: 48.h,
                                      fieldWidth: 48.w,
                                      activeFillColor: AppColors.neutral0,
                                      selectedColor: AppColors.primaryAccent,
                                      activeColor: AppColors.primaryAccent,
                                      inactiveColor: AppColors.neutral40,
                                      inactiveFillColor: AppColors.neutral0,
                                      selectedFillColor: AppColors.primaryAccent,
                                      borderWidth: 10.w,
                                    ),
                                    onChanged: (value) {},
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Didn't receive code?", style: textTheme.bodyMediumSemiBold!.copyWith(color: context.colors.defaultGray878787)),
                                      TextButton(
                                        onPressed: countdownSeconds == 0 ? onResendPressed : null,
                                        child: Text(
                                          'Resend',
                                          style: AppTextTheme.fallback(isTablet: isTablet).bodyMediumSemiBold!.copyWith(
                                            color: countdownSeconds == 0 ? AppColors.primaryAccent : AppColors.primaryAccent.withValues(alpha: 0.5),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.access_time_rounded, size: 18, color: AppColors.neutral60),
                                      SizedBox(width: 8.w),
                                      Text(
                                        "${countdownSeconds.toString().padLeft(2, '0')}:00",
                                        style: AppTextTheme.fallback(isTablet: isTablet).bodyMediumMedium!.copyWith(color: AppColors.neutral60),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 30.h),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: state.isLoading ? null : onContinuePressed,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange,
                                        padding: EdgeInsets.symmetric(vertical: 16.h),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
                                      ),
                                      child:
                                          state.isLoading
                                              ? CircularProgressIndicator()
                                              : Text(
                                                "Verify",
                                                style: AppTextTheme.fallback(isTablet: isTablet).bodyMediumSemiBold!.copyWith(color: AppColors.neutral0),
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
