import 'package:flutter/material.dart';
import 'package:voice_assistant/app/figma_tokens.dart';
import 'package:voice_assistant/features/analysis/data/mock_visit_analysis_service.dart';
import 'package:voice_assistant/features/recording/data/ios_recording_service.dart';
import 'package:voice_assistant/features/recording/presentation/recording_screen.dart';
import 'package:voice_assistant/features/share/share_service.dart';

class VisitNotesApp extends StatelessWidget {
  const VisitNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '医嘱备忘',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: FigmaColors.action,
          surface: FigmaColors.background,
        ),
        scaffoldBackgroundColor: FigmaColors.background,
        useMaterial3: true,
      ),
      home: RecordingScreen(
        recordingService: IosRecordingService(),
        analysisService: MockVisitAnalysisService(),
        shareService: ShareService(),
      ),
    );
  }
}
