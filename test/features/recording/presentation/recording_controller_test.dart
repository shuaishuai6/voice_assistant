import 'package:flutter_test/flutter_test.dart';
import 'package:voice_assistant/features/recording/domain/recording_service.dart';
import 'package:voice_assistant/features/recording/domain/recording_session.dart';
import 'package:voice_assistant/features/recording/presentation/recording_controller.dart';

class FakeRecordingService implements RecordingService {
  bool permission = true;

  @override
  Future<bool> requestPermission() async => permission;

  @override
  Future<String> startRecording() async => '/tmp/visit.wav';

  @override
  Future<String> stopRecording() async => '/tmp/visit.wav';
}

void main() {
  test('start and stop recording update state', () async {
    final controller = RecordingController(FakeRecordingService());

    await controller.start();
    expect(controller.value.status, RecordingStatus.recording);

    await controller.stop();
    expect(controller.value.status, RecordingStatus.completed);
    expect(controller.value.audioFilePath, '/tmp/visit.wav');
  });

  test('permission denial moves to failed state', () async {
    final service = FakeRecordingService()..permission = false;
    final controller = RecordingController(service);

    await controller.start();

    expect(controller.value.status, RecordingStatus.failed);
    expect(controller.value.errorMessage, contains('麦克风权限'));
  });
}
