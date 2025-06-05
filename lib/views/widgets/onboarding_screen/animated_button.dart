import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/app_colors.dart';

class ProgressAnimatedIconButton extends StatefulWidget {
  final VoidCallback onPressed;

  const ProgressAnimatedIconButton({super.key, required this.onPressed});

  @override
  State<ProgressAnimatedIconButton> createState() =>
      ProgressAnimatedIconButtonState();
}

class ProgressAnimatedIconButtonState extends State<ProgressAnimatedIconButton>
    with TickerProviderStateMixin {
  late AnimationController progressController;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
  }

  @override
  void dispose() {
    progressController.dispose();
    isProcessing = false;
    super.dispose();
  }

  void onButtonPressed() {
    //if (isProcessing) return;
    if (!isProcessing) {
      setState(() => isProcessing = true);
      progressController.forward(from: 0).whenComplete(() {
        setState(() => isProcessing = false);
        widget.onPressed();
        print('Button pressed');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double size = 100.w;

    return GestureDetector(
      onTap: onButtonPressed,
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (isProcessing)
              SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  backgroundColor: AppColors.neutral40,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.neutral0),
                  strokeWidth: 2.w,
                ),
              ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.neutral0,
                shape: const CircleBorder(),
                padding: EdgeInsets.all(22.w),
              ),
              onPressed: onButtonPressed,
              child: SvgPicture.asset(
                'assets/icons/arrow-right.svg',
                width: 24.w,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
