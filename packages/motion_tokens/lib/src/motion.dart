import 'package:flutter/animation.dart';

/// モーショントークン定義（06_MOTION_AUDIO_SPEC.md 準拠）
/// **OS別値禁止**（00_PARITY_CONTRACT.md）
class MotionTokens {
  MotionTokens._(); // インスタンス化禁止

  // Duration（06_MOTION_AUDIO_SPEC.md より）
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 500);
  static const Duration durationGenesis =
      Duration(milliseconds: 5000); // Genesis Sequence

  // Curve（Ease-Out-Expo: "Fluid Sci-Fi"）
  static const Curve curveDefault = Curves.easeOutExpo;
  static const Curve curveSharp = Curves.easeOut;
  static const Curve curveSmooth = Curves.easeInOutCubic;

  // FPS Target
  static const int fpsTarget = 60;
}
