import 'package:e_commerce_app/core/Theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:e_commerce_app/features/presentation/Widget/custom_button.dart';
import 'package:flutter/material.dart';

class DialogHelper {
  static Future<T?> showCustomDialog<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: builder,
    );
  }

  static Future<T?> showAlertDialog<T>({
    required BuildContext context,
    required String title,
    Widget? content,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    String? cancelText,
    String? confirmText,
    bool barrierDismissible = true,
    bool isLoading = false,
    bool showCancelButton = true,
    Color? confirmColor,
    Color? confirmTextColor,
    Color? cancelColor,
    Color? cancelTextColor,
  }) {
    return showCustomDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (dialogContext) => CustomAlertDialog(
        title: title,
        content: content,
        onCancel: onCancel ?? () => Navigator.of(dialogContext).pop(false),
        onConfirm: onConfirm,
        cancelText: cancelText ?? 'Cancel',
        confirmText: confirmText ?? 'Confirm',
        isLoading: isLoading,
        showCancelButton: showCancelButton,
        confirmColor: confirmColor,
        confirmTextColor: confirmTextColor,
        cancelColor: cancelColor,
        cancelTextColor: cancelTextColor,
      ),
    );
  }
}

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final Widget? content;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;
  final String cancelText;
  final String confirmText;
  final bool showCancelButton;
  final Color? confirmColor;
  final Color? confirmTextColor;
  final Color? cancelColor;
  final Color? cancelTextColor;
  final bool isLoading;

  const CustomAlertDialog({
    super.key,
    required this.title,
    this.content,
    required this.onCancel,
    required this.onConfirm,
    this.cancelText = "Cancel",
    this.confirmText = "Reject",
    this.isLoading = false,
    this.showCancelButton = true,
    this.confirmColor,
    this.confirmTextColor,
    this.cancelColor,
    this.cancelTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: AppColors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 20.h,
          horizontal: 16.w,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.text1,
              ),
            ),
            SizedBox(height: 12.h),
            if (content != null)
              DefaultTextStyle(
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.text1,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                child: content!,
              )
            else
              Text(
                'Are you sure you want to proceed?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.text1,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (showCancelButton)
                  Expanded(
                    child: CustomButton(
                      onPressed: onCancel,
                      text: cancelText,
                      color: cancelColor ?? AppColors.white,
                      textColor: cancelTextColor ?? AppColors.primarycolor,
                      edgeRadius: 8,
                      height: 44.h,
                      isBoldText: true,
                      isLoading: false,
                      borderColor: AppColors.primarycolor,
                    ),
                  ),
                if (showCancelButton) const SizedBox(width: 10),
                Expanded(
                  child: CustomButton(
                    onPressed: () {
                      onConfirm();
                      Navigator.of(context).pop(true);
                    },
                    text: confirmText,
                    color: confirmColor ?? AppColors.primarycolor,
                    textColor: confirmTextColor ?? AppColors.text2,
                    edgeRadius: 8,
                    height: 44.h,
                    isBoldText: true,
                    isLoading: isLoading,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
