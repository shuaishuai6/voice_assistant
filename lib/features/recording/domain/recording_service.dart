abstract interface class RecordingService {
  Future<bool> requestPermission();

  Future<String> startRecording();

  Future<String> stopRecording();
}
