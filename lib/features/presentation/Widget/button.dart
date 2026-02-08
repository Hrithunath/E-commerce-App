import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ButtonCustomized extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final TextStyle? textStyle;
  final double borderRadius;
  final double? width;
  final double? height;
  final Icon? icon;
  const ButtonCustomized(
      {super.key,
      required this.text,
      required this.onPressed,
      this.color,
      this.textStyle,
      this.borderRadius = 8.0,
      this.width,
      this.height,
      this.icon});

  @override
  Widget build(BuildContext context) {
    final label = Text(
      text,
      style: textStyle ??
          TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
          ),
    );

    return SizedBox(
      width: width,
      height: height,
      child: icon == null
          ? ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius.r),
                ),
              ),
              child: label,
            )
          : ElevatedButton.icon(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius.r),
                ),
              ),
              icon: icon!,
              label: label,
            ),
    );
  }
}
