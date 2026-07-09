import 'package:flutter/services.dart';
import 'package:voice_assistant/features/recording/domain/recording_service.dart';

class IosRecordingService implements RecordingService {
  static const _channel = MethodChannel('voice_assistant/audio_recorder');

  @override
  Future<bool> requestPermission() async {
    final result = await _channel.invokeMethod<bool>('requestPermission');
    return result ?? false;
  }

  @override
  Future<String> startRecording() async {
    final path = await _channel.invokeMethod<String>('startRecording');
    if (path == null || path.isEmpty) {
      throw StateError('Recording did not return a file path.');
    }
    return path;
  }

  @override
  Future<String> stopRecording() async {
    final path = await _channel.invokeMethod<String>('stopRecording');
    if (path == null || path.isEmpty) {
      throw StateError('Stop recording did not return a file path.');
    }
    return path;
  }
}
