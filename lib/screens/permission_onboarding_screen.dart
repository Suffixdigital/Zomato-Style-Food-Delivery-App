import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_flutter/core/constants/text_styles.dart';
import 'package:smart_flutter/model/permission_item.dart';
import 'package:smart_flutter/services/shared_preferences_service.dart';
import 'package:smart_flutter/theme/app_colors.dart';

class PermissionOnboardingScreen extends StatefulWidget {
  const PermissionOnboardingScreen({super.key});

  @override
  State<PermissionOnboardingScreen> createState() => _PermissionOnboardingScreenState();
}

class _PermissionOnboardingScreenState extends State<PermissionOnboardingScreen> with TickerProviderStateMixin {
  final List<PermissionItem> permissionItemList = [
    PermissionItem(
      permission: Permission.locationWhenInUse,
      title: "Location Access",
      description: "Get better results and recommendations near you.",
      lottieAsset: "assets/lottie/location.json",
      isPermissionGranted: false,
    ),
    PermissionItem(
      permission: Permission.camera,
      title: "Camera Access",
      description: "Capture moments and scan QR codes easily.",
      lottieAsset: "assets/lottie/camera.json",
      isPermissionGranted: false,
    ),
    PermissionItem(
      permission: Permission.notification,
      title: "Notifications",
      description: "Stay updated with important alerts.",
      lottieAsset: "assets/lottie/notification.json",
      isPermissionGranted: false,
    ),
  ];

  int currentIndex = 0;
  bool permissionGranted = false;
  late AnimationController fadeController;
  late AnimationController slideController;

  @override
  void initState() {
    super.initState();
    fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    slideController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    fadeController.forward();
    slideController.forward();
    checkInitialPermissionStatus();
  }

  Future<void> checkInitialPermissionStatus() async {
    for (int i = 0; i < permissionItemList.length; i++) {
      final permissionItem = permissionItemList[i];
      final status = await permissionItem.permission.status;
      permissionItem.isPermissionGranted = status.isGranted;
    }
    setState(() => {});
    /*for (int i = 0; i < permissionItemList.length; i++) {
      final permissionItem = permissionItemList[i];
      print("PermissionItem status after checkInitialPermissionStatus(): ${permissionItem.isPermissionGranted}");
    }*/
  }

  Future<void> requestPermission(PermissionItem item) async {
    final status = await item.permission.request();

    if (status.isGranted) {
      setState(() => permissionGranted = true);

      await Future.delayed(const Duration(milliseconds: 500)); // Show checkmark
      setState(() => currentIndex++);

      if (currentIndex < permissionItemList.length) {
        setState(() => permissionGranted = false);
      } else {
        // All permissions granted — Save to SharedPreferences
        SharedPreferencesService.setPermissionDone(true);

        if (!mounted) return;
        context.goNamed('login');
        // Navigator.pushReplacementNamed(context, "/home");
      }
    } else if (status.isPermanentlyDenied) {
      showSettingsDialog(item.title);
    }
  }

  void showSettingsDialog(String title) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text("$title Required"),
            content: const Text("Please enable permission from settings to continue."),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
              TextButton(
                onPressed: () {
                  openAppSettings();
                  Navigator.pop(ctx);
                },
                child: const Text("Open Settings"),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    fadeController.dispose();
    slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (currentIndex >= permissionItemList.length) {
      return const SizedBox.shrink();
    }

    final currentItem = permissionItemList[currentIndex];
    print("PermissionItem status: ${currentItem.isPermissionGranted}");
    final textTheme = Theme.of(context).extension<AppTextTheme>()!;
    return ScreenUtilInit(
      designSize: Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder:
          (context, child) => Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                // Background Image
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        opacity: 0.85,
                        image: AssetImage('assets/images/splash_burger1.png'),
                        // Your image
                        repeat: ImageRepeat.repeatY,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),

                SafeArea(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(currentItem.lottieAsset, height: 150.h, width: 150.w),
                        SizedBox(height: 30.h),
                        Text(currentItem.title, style: textTheme.headingH4SemiBold!.copyWith(color: context.colors.defaultWhite)),
                        SizedBox(height: 20.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.w),
                          child: Text(
                            currentItem.description,
                            textAlign: TextAlign.center,
                            style: textTheme.bodyMediumSemiBold!.copyWith(color: context.colors.defaultGrayEEEEEE),
                          ),
                        ),
                        SizedBox(height: 30.h),
                        SizedBox(
                          width: 240.w,
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.check_circle_outline, color: context.colors.defaultWhite),
                            onPressed: permissionGranted ? null : () => requestPermission(currentItem),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.colors.primary,
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
                            ),
                            label: Text(
                              currentItem.isPermissionGranted ? "Granted" : "Allow",
                              style: textTheme.bodyMediumSemiBold!.copyWith(color: context.colors.defaultWhite),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
