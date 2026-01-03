import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const heading = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static const subHeading = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static const body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textLight,
  );

  static const small = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textLight,
  );

  static const button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const caption = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColors.textLight,
  );

  static const link = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryBlue,
    decoration: TextDecoration.underline,
  );

  static const error = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.dangerRed,
  );
  static const success = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.successGreen,
  );
   
   static const highlight = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.infoBlue,
   );
   static const warning = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.warningYellow,
   );
   static const purpleText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.purple,
   );
   
}
