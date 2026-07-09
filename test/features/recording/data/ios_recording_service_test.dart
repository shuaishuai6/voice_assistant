import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voice_assistant/features/recording/data/ios_recording_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('voice_assistant/audio_recorder');

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('startRecording delegates to platform channel', () async {
    final calls = <String>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          calls.add(call.method);
          if (call.method == 'startRecording') {
            return '/tmp/visit.wav';
          }
          return null;
        });

    final service = IosRecordingService();
    final path = await service.startRecording();

    expect(path, '/tmp/visit.wav');
    expect(calls, ['startRecording']);
  });
}
