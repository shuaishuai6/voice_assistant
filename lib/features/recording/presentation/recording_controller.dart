import 'package:flutter/foundation.dart';
import 'package:voice_assistant/features/recording/domain/recording_service.dart';
import 'package:voice_assistant/features/recording/domain/recording_session.dart';

class RecordingController extends ValueNotifier<RecordingSession> {
  RecordingController(this._recordingService)
    : super(RecordingSession(id: 'idle', startedAt: DateTime.now()));

  final RecordingService _recordingService;

  Future<void> start() async {
    final startedAt = DateTime.now();
    value = RecordingSession(
      id: 'pending',
      startedAt: startedAt,
      status: RecordingStatus.requestingPermission,
    );

    final granted = await _recordingService.requestPermission();
    if (!granted) {
      value = RecordingSession(
        id: 'failed',
        startedAt: startedAt,
        status: RecordingStatus.failed,
        errorMessage: '需要麦克风权限才能记录就诊内容。',
      );
      return;
    }

    final path = await _recordingService.startRecording();
    value = RecordingSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      startedAt: DateTime.now(),
      audioFilePath: path,
      status: RecordingStatus.recording,
    );
  }

  Future<void> stop() async {
    final current = value;
    value = RecordingSession(
      id: current.id,
      startedAt: current.startedAt,
      audioFilePath: current.audioFilePath,
      status: RecordingStatus.stopping,
    );

    final path = await _recordingService.stopRecording();
    value = RecordingSession(
      id: current.id,
      startedAt: current.startedAt,
      endedAt: DateTime.now(),
      audioFilePath: path,
      status: RecordingStatus.completed,
    );
  }

  void markAnalyzing() {
    final current = value;
    value = RecordingSession(
      id: current.id,
      startedAt: current.startedAt,
      endedAt: current.endedAt,
      audioFilePath: current.audioFilePath,
      status: RecordingStatus.analyzing,
    );
  }

  void markFailed(String message) {
    final current = value;
    value = RecordingSession(
      id: current.id,
      startedAt: current.startedAt,
      endedAt: current.endedAt,
      audioFilePath: current.audioFilePath,
      status: RecordingStatus.failed,
      errorMessage: message,
    );
  }
}
