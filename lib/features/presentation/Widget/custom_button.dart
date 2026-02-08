import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color? color;
  final Color? textColor;
  final double? width;
  final double? height;
  final double edgeRadius;
  final bool isBoldText;
  final bool isLoading;
  final Color? borderColor;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.color,
    this.textColor,
    this.width,
    this.height,
    this.edgeRadius = 8.0,
    this.isBoldText = false,
    this.isLoading = false,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          disabledBackgroundColor: color?.withOpacity(0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(edgeRadius),
            side: borderColor != null
                ? BorderSide(color: borderColor!, width: 1.5)
                : BorderSide.none,
          ),
          elevation: 0,
          padding: EdgeInsets.zero,
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    textColor ?? Colors.white,
                  ),
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  color: textColor ?? Colors.white,
                  fontSize: 16,
                  fontWeight: isBoldText ? FontWeight.bold : FontWeight.w500,
                ),
              ),
      ),
    );
  }
}
