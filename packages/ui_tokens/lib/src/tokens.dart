import 'package:flutter/material.dart';

/// UI トークン定義（05_UI_VISUAL_SPEC.md 準拠）
/// **OS別値禁止**（00_PARITY_CONTRACT.md）
class UITokens {
  UITokens._(); // インスタンス化禁止

  // 色定義（05_UI_VISUAL_SPEC.md より）
  static const Color colorBase = Color(0xFF0A0E17); // Deep Space
  static const Color colorAccent = Color(0xFF00F0FF); // Cyan Neon
  static const Color colorSecondary = Color(0xFF7000FF); // Purple

  // 余白（基本単位: 8px）
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;

  // 角丸
  static const double radiusSm = 4.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 16.0;

  // 影（Glassmorphism）
  static const double blurMin = 10.0;
  static const double blurMax = 20.0;
  static const double opacity = 0.8;
}
