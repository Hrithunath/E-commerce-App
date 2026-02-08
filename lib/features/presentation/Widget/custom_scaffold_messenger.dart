import 'package:flutter/material.dart';
import 'package:e_commerce_app/core/Theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:e_commerce_app/core/constants/app_strings.dart';

/// NOTE:
/// This shows messages to the user in a nice way:
/// • Success, error, or warning colors/icons
/// • Can show single or multiple messages
/// • Can convert any error/exception into a readable message

void showCustomSnackBar({
  required BuildContext context,
  required String message,
  IconData icon = Icons.info,
  Color iconColor = AppColors.text1,
  Color borderColor = AppColors.transparent,
  Color textColor = AppColors.text2,
  Color backgroundColor = AppColors.text2,
  Color buttonColor = AppColors.text1,
  double elevation = 6.0,
  Duration duration = const Duration(seconds: 2),
  String? actionLabel,
  VoidCallback? onAction,
}) {
  final safeMessage =
      (message.trim().isEmpty) ? AppStrings.genericError : message.trim();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: Icon(
                      icon,
                      color: iconColor,
                      size: 24.w,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      safeMessage,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16.sp,
                        height: 1.5,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  onAction?.call();
                }
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 8.h,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                actionLabel ?? "OK",
                style: TextStyle(
                  color: buttonColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
      ),
      duration: duration,
      backgroundColor: backgroundColor,
      elevation: elevation,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.symmetric(
        horizontal: 15.w,
        vertical: 50.h,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
        side: BorderSide(
          color: borderColor,
          width: 2.w,
        ),
      ),
    ),
  );
}

extension SnackBarType on BuildContext {
  void showSuccessSnackBar(String message) => showCustomSnackBar(
        context: this,
        message: message,
        icon: Icons.check_circle,
        iconColor: AppColors.successGreen,
        borderColor: AppColors.successGreen,
        textColor: AppColors.text1,
        backgroundColor: AppColors.text2,
        buttonColor: AppColors.successGreen,
      );

  void showErrorSnackBar(String message) => showCustomSnackBar(
        context: this,
        message: message,
        icon: Icons.error,
        iconColor: AppColors.errorRed,
        borderColor: AppColors.errorRed,
        textColor: AppColors.text1,
        backgroundColor: AppColors.text2,
        buttonColor: AppColors.errorRed,
      );

  void showWarningSnackBar(String message) => showCustomSnackBar(
        context: this,
        message: message,
        icon: Icons.warning_amber_rounded,
        iconColor: AppColors.warningOrange,
        borderColor: AppColors.warningOrange,
        textColor: AppColors.text1,
        backgroundColor: AppColors.text2,
        buttonColor: AppColors.warningOrange,
      );

  /// Accepts any object/exception, extracts a sensible message, and shows an error snackbar.
  void showErrorFromException(Object? error) {
    final message = error?.toString() ?? AppStrings.genericError;
    showErrorSnackBar(message);
  }

  void showMultipleErrorMessages(
    List<String> messages, {
    Duration delayBetween = const Duration(milliseconds: 1000),
  }) async {
    if (messages.isEmpty) return;

    // Remove duplicates while preserving order
    final uniqueMessages = <String>[];
    final seen = <String>{};
    for (final msg in messages) {
      final cleanMsg = msg.trim();
      if (cleanMsg.isNotEmpty && !seen.contains(cleanMsg)) {
        uniqueMessages.add(cleanMsg);
        seen.add(cleanMsg);
      }
    }

    if (uniqueMessages.isEmpty) return;

    for (int i = 0; i < uniqueMessages.length; i++) {
      if (i > 0) {
        await Future.delayed(delayBetween);
      }
      if (mounted) {
        showErrorSnackBar(uniqueMessages[i]);
      }
    }
  }

  void showCombinedErrorMessage(List<String> messages) {
    if (messages.isEmpty) {
      showErrorSnackBar(AppStrings.genericError);
      return;
    }

    // Remove duplicates while preserving order
    final uniqueMessages = <String>[];
    final seen = <String>{};
    for (final msg in messages) {
      final cleanMsg = msg.trim();
      if (cleanMsg.isNotEmpty && !seen.contains(cleanMsg)) {
        uniqueMessages.add(cleanMsg);
        seen.add(cleanMsg);
      }
    }

    if (uniqueMessages.isEmpty) {
      showErrorSnackBar(AppStrings.genericError);
      return;
    }

    if (uniqueMessages.length == 1) {
      showErrorSnackBar(uniqueMessages.first);
    } else {
      // Combine multiple messages with bullet points
      final combined = uniqueMessages.map((msg) => '• $msg').join('\n');
      showErrorSnackBar(combined);
    }
  }
}
