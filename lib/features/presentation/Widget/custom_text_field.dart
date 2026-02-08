import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:e_commerce_app/core/Theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// NOTES:
/// A customizable text field widget that supports various styles, validation, and responsive design.
class CustomTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscure;
  final Widget? suffix;
  final Widget? prefix;
  final String? Function(String?)? validator;
  final AutovalidateMode autovalidateMode;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? minLines;
  final bool enabled;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final bool readOnly;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final TextStyle? textStyle;
  final List<TextInputFormatter>? inputFormatters;
  final Color? borderColor;
  final bool capitalizeFirst;
  final Color? fillColor;
  final EdgeInsetsGeometry? contentPadding;

  const CustomTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.obscure = false,
    this.suffix,
    this.prefix,
    this.validator,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.keyboardType,
    this.maxLines = 1,
    this.minLines,
    this.enabled = true,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.textInputAction,
    this.focusNode,
    this.textStyle,
    this.inputFormatters,
    this.borderColor,
    this.capitalizeFirst = false,
    this.fillColor,
    this.contentPadding,
  });

  TextEditingValue _applyCapitalizeFirst(TextEditingValue value) {
    final text = value.text;
    if (text.isEmpty) return value;
    final first = text.characters.first.toUpperCase();
    final rest = text.characters.skip(1).toString();
    final newText = '$first$rest';
    if (newText == text) return value;
    return value.copyWith(text: newText);
  }

  @override
  Widget build(BuildContext context) {
    final combinedFormatters = <TextInputFormatter>[];
    if (inputFormatters != null) combinedFormatters.addAll(inputFormatters!);
    if (capitalizeFirst) {
      combinedFormatters.add(
        TextInputFormatter.withFunction(
          (oldValue, newValue) => _applyCapitalizeFirst(newValue),
        ),
      );
    }

    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      inputFormatters: combinedFormatters.isEmpty ? null : combinedFormatters,
      autovalidateMode: autovalidateMode,
      maxLines: obscure ? 1 : maxLines,
      minLines: minLines,
      enabled: enabled,
      onChanged: onChanged,
      onTap: onTap,
      readOnly: readOnly,
      textInputAction: textInputAction,
      focusNode: focusNode,
      style: TextStyle(
        fontSize: 15.sp,
        color: AppColors.headerText,
      ),
      decoration: InputDecoration(
        errorMaxLines: 2,
        errorStyle: TextStyle(
          fontSize: 12.sp,
          height: 1.4,
          color: AppColors.errorRed,
        ),
        labelText: label,
        labelStyle: TextStyle(
          color: AppColors.hintText,
          fontSize: 14.sp,
        ),
        hintText: hint,
        hintStyle: textStyle ??
            TextStyle(
              color: AppColors.hintText.withOpacity(0.7),
              fontSize: 14.sp,
            ),
        filled: true,
        fillColor: fillColor ?? AppColors.textFormFieldBackground,
        helperText:
            ' ', // Reserve space for error text to prevent height change
        helperStyle: TextStyle(
          fontSize: 12.sp,
          height: 1.4,
          color: AppColors.transparent,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: borderColor ?? AppColors.bordercolor.withOpacity(0.3),
            width: borderColor != null ? 1.5 : 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: borderColor ?? AppColors.bordercolor.withOpacity(0.3),
            width: borderColor != null ? 1.5 : 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: borderColor ?? AppColors.bordercolor.withOpacity(0.3),
            width: borderColor != null ? 1.5 : 1.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.errorRed, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.errorRed, width: 1.5),
        ),
        contentPadding: contentPadding ??
            EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
        suffixIcon: suffix,
        prefixIcon: prefix,
      ),
      validator: validator,
    );
  }
}
