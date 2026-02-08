import 'package:flutter_screenutil/flutter_screenutil.dart';


class AppSize {
  // Screen dimensions
  static double get screenWidth => ScreenUtil().screenWidth;
  static double get screenHeight => ScreenUtil().screenHeight;

  // Status bar height
  static double get statusBarHeight => ScreenUtil().statusBarHeight;

  // Bottom bar height
  static double get bottomBarHeight => ScreenUtil().bottomBarHeight;

  // Common spacing
  static double get xs => 4.w;
  static double get sm => 8.w;
  static double get md => 16.w;
  static double get lg => 24.w;
  static double get xl => 32.w;
  static double get xxl => 48.w;

  // Common font sizes
  static double get fontXs => 10.sp;
  static double get fontSm => 12.sp;
  static double get fontMd => 14.sp;
  static double get fontLg => 16.sp;
  static double get fontXl => 18.sp;
  static double get fontXxl => 20.sp;
  static double get fontH1 => 24.sp;
  static double get fontH2 => 22.sp;
  static double get fontH3 => 20.sp;

  // Common radius
  static double get radiusSm => 4.r;
  static double get radiusMd => 8.r;
  static double get radiusLg => 12.r;
  static double get radiusXl => 16.r;
  static double get radiusXxl => 20.r;
  static double get radiusRound => 999.r;

  // Icon sizes
  static double get iconSm => 16.w;
  static double get iconMd => 24.w;
  static double get iconLg => 32.w;
  static double get iconXl => 40.w;

  // Button heights
  static double get buttonHeightSm => 36.h;
  static double get buttonHeightMd => 48.h;
  static double get buttonHeightLg => 56.h;
}
