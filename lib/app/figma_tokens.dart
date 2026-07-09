import 'package:flutter/material.dart';

abstract final class FigmaColors {
  static const background = Color(0xFFFCF9F8);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceMuted = Color(0xFFEAF5F1);
  static const textPrimary = Color(0xFF1C1B1B);
  static const textSecondary = Color(0xFF3D4A42);
  static const brandGreen = Color(0xFF006C4B);
  static const accentGreen = Color(0xFF00A676);
  static const softGreen = Color(0xFFE6F6F1);
  static const mutedGreen = Color(0x663D4A42);
  static const patientGreen = Color(0xFF00A676);
  static const recordRed = Color(0xFFD83B32);
  static const border = Color(0x80FFFFFF);
  static const warningSurface = Color(0xFFFFF4EA);
  static const warningText = Color(0xFF80531A);

  static const doctor = brandGreen;
  static const patient = patientGreen;
  static const action = brandGreen;
  static const danger = recordRed;
}

abstract final class FigmaSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 40.0;
}

abstract final class FigmaRadius {
  static const sm = 4.0;
  static const md = 8.0;
  static const lg = 12.0;
  static const action = 28.0;
  static const card = 16.0;
}

abstract final class FigmaAssets {
  static const whiteKit = 'assets/images/node-id=1-133.png';
  static const whiteMic = 'assets/images/node-id=1-396.png';
  static const greenMic = 'assets/images/node-id=2-826-1.png';
  static const mutedMic = 'assets/images/node-id=2-826-2.png';
  static const greenKit = 'assets/images/node-id=2-832-1.png';
  static const mutedKit = 'assets/images/node-id=2-832-2.png';
}
