import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

/// Sistem tipografi terpusat untuk aplikasi HomeSikil.
///
/// Hirarki skala:
///   Title  → Title1 (28), Title2 (24), Title3 (20)
///   Body   → Body1  (16), Body2  (14)
///   Label  → Label1 (12), Label2 (11)
///
/// Setiap skala tersedia dalam 4 weight:
///   regular   → w400
///   medium    → w500
///   semibold  → w600
///   bold      → w700
///
/// Contoh pemakaian:
///   Text('Halo', style: AppTextStyles.title1Bold)
///   Text('Halo', style: AppTextStyles.body1Regular.copyWith(color: Colors.red))
class AppTextStyles {
  AppTextStyles._();

  // ─────────────────────────────────────────────────────────
  // TITLE 1  (28 sp)
  // ─────────────────────────────────────────────────────────
  static TextStyle get title1Regular  => _base(28, FontWeight.w400);
  static TextStyle get title1Medium   => _base(28, FontWeight.w500);
  static TextStyle get title1SemiBold => _base(28, FontWeight.w600);
  static TextStyle get title1Bold     => _base(28, FontWeight.w700);

  // ─────────────────────────────────────────────────────────
  // TITLE 2  (24 sp)
  // ─────────────────────────────────────────────────────────
  static TextStyle get title2Regular  => _base(24, FontWeight.w400);
  static TextStyle get title2Medium   => _base(24, FontWeight.w500);
  static TextStyle get title2SemiBold => _base(24, FontWeight.w600);
  static TextStyle get title2Bold     => _base(24, FontWeight.w700);

  // ─────────────────────────────────────────────────────────
  // TITLE 3  (20 sp)
  // ─────────────────────────────────────────────────────────
  static TextStyle get title3Regular  => _base(20, FontWeight.w400);
  static TextStyle get title3Medium   => _base(20, FontWeight.w500);
  static TextStyle get title3SemiBold => _base(20, FontWeight.w600);
  static TextStyle get title3Bold     => _base(20, FontWeight.w700);

  // ─────────────────────────────────────────────────────────
  // BODY 1  (16 sp)
  // ─────────────────────────────────────────────────────────
  static TextStyle get body1Regular  => _base(16, FontWeight.w400, secondary: false);
  static TextStyle get body1Medium   => _base(16, FontWeight.w500, secondary: false);
  static TextStyle get body1SemiBold => _base(16, FontWeight.w600, secondary: false);
  static TextStyle get body1Bold     => _base(16, FontWeight.w700, secondary: false);

  // ─────────────────────────────────────────────────────────
  // BODY 2  (14 sp)  — warna sekunder secara default
  // ─────────────────────────────────────────────────────────
  static TextStyle get body2Regular  => _base(14, FontWeight.w400, secondary: true);
  static TextStyle get body2Medium   => _base(14, FontWeight.w500, secondary: true);
  static TextStyle get body2SemiBold => _base(14, FontWeight.w600, secondary: true);
  static TextStyle get body2Bold     => _base(14, FontWeight.w700, secondary: true);

  // ─────────────────────────────────────────────────────────
  // LABEL 1  (12 sp) — warna sekunder secara default
  // ─────────────────────────────────────────────────────────
  static TextStyle get label1Regular  => _base(12, FontWeight.w400, secondary: true);
  static TextStyle get label1Medium   => _base(12, FontWeight.w500, secondary: true);
  static TextStyle get label1SemiBold => _base(12, FontWeight.w600, secondary: true);
  static TextStyle get label1Bold     => _base(12, FontWeight.w700, secondary: true);

  // ─────────────────────────────────────────────────────────
  // LABEL 2  (11 sp) — misalnya untuk chip / badge
  // ─────────────────────────────────────────────────────────
  static TextStyle get label2Regular  => _base(11, FontWeight.w400, secondary: true);
  static TextStyle get label2Medium   => _base(11, FontWeight.w500, secondary: true);
  static TextStyle get label2SemiBold => _base(11, FontWeight.w600, secondary: true);
  static TextStyle get label2Bold     => _base(11, FontWeight.w700, secondary: true);

  // ─────────────────────────────────────────────────────────
  // Legacy aliases — tetap ada agar kode lama tidak rusak
  // ─────────────────────────────────────────────────────────

  /// @deprecated Gunakan [title1SemiBold] atau [title2Bold].
  static TextStyle get displayLarge => title1SemiBold.copyWith(height: 1.2);

  /// @deprecated Gunakan [title2Bold].
  static TextStyle get heading => title2Bold;

  /// @deprecated Gunakan [title3SemiBold].
  static TextStyle get title => title3SemiBold;

  /// @deprecated Gunakan [body1Regular].
  static TextStyle get bodyLarge => body1Regular;

  /// @deprecated Gunakan [body2Regular].
  static TextStyle get bodyMedium => body2Regular;

  /// @deprecated Gunakan [label1Medium].
  static TextStyle get label => label1Medium;

  // ─────────────────────────────────────────────────────────
  // Private builder
  // ─────────────────────────────────────────────────────────
  static TextStyle _base(
    double size,
    FontWeight weight, {
    bool secondary = false,
  }) =>
      GoogleFonts.inter(
        fontSize: size,
        fontWeight: weight,
        color: secondary ? AppColors.textSecondary : AppColors.textPrimary,
        height: 1.4,
      );
}
