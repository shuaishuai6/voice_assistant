import 'package:flutter/material.dart';

abstract final class FigmaColors {
  static const background = Color(0xFFF8FBF8);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceMuted = Color(0xFFEAF2EE);
  static const textPrimary = Color(0xFF123128);
  static const textSecondary = Color(0xFF6B7D75);
  static const brandGreen = Color(0xFF00513E);
  static const mutedGreen = Color(0xFF6F8078);
  static const patientGreen = Color(0xFF4BA06D);
  static const recordRed = Color(0xFFD83B32);
  static const border = Color(0xFFDDE8E2);
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
}

abstract final class FigmaAssets {
  static const whiteKit = 'assets/images/node-id=1-133.png';
  static const whiteMic = 'assets/images/node-id=1-396.png';
  static const greenMic = 'assets/images/node-id=2-826-1.png';
  static const mutedMic = 'assets/images/node-id=2-826-2.png';
  static const greenKit = 'assets/images/node-id=2-832-1.png';
  static const mutedKit = 'assets/images/node-id=2-832-2.png';
}
