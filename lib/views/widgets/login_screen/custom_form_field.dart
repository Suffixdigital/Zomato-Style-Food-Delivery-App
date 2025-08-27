import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_flutter/core/constants/text_styles.dart';
import 'package:smart_flutter/theme/app_colors.dart';

class CustomFormField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final bool obscureText;
  final bool readOnly;
  final TextInputType keyboardType;
  final VoidCallback? onVisibilityTap;
  final VoidCallback onTap;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final String? Function(String? value)? validator;
  final FocusNode focusNode;

  const CustomFormField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hintText,
    this.isPassword = false,
    this.obscureText = false,
    this.readOnly = false,
    required this.onTap,
    required this.keyboardType,
    this.onVisibilityTap,
    this.onChanged,
    this.errorText,
    this.validator,
  });

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  late bool _hasFocus;

  @override
  void initState() {
    super.initState();
    _hasFocus = widget.focusNode.hasFocus;

    widget.focusNode.addListener(() {
      setState(() {
        _hasFocus = widget.focusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).extension<AppTextTheme>()!;

    final double borderWidth = 1.2.w;

    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword && widget.obscureText,
      keyboardType: widget.keyboardType,
      cursorColor: context.colors.primary,
      obscuringCharacter: "*",
      readOnly: widget.readOnly,
      focusNode: widget.focusNode,
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      validator: widget.validator,
      style: textTheme.bodyMediumMedium,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: textTheme.bodyMediumMedium!.copyWith(
          color: context.colors.defaultGray878787,
        ),
        filled: true,
        fillColor: context.colors.background,
        errorText: widget.errorText,
        errorMaxLines: 3,
        errorStyle: textTheme.bodyMediumMedium!.copyWith(
          color: context.colors.error,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color:
                _hasFocus
                    ? context.colors.primary
                    : context.colors.defaultGray878787,
            width: borderWidth,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: context.colors.defaultGray878787,
            width: borderWidth,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: context.colors.primary,
            width: borderWidth + 0.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: context.colors.error,
            width: borderWidth,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: context.colors.error,
            width: borderWidth + 0.2,
          ),
        ),
        suffixIcon:
            widget.isPassword
                ? IconButton(
                  icon: Icon(
                    widget.obscureText
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: context.colors.generalText,
                  ),
                  onPressed: widget.onVisibilityTap,
                )
                : null,
      ),
    );
  }
}
