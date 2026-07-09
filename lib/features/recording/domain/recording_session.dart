enum RecordingStatus {
  idle,
  requestingPermission,
  recording,
  stopping,
  analyzing,
  completed,
  failed,
}

class RecordingSession {
  const RecordingSession({
    required this.id,
    required this.startedAt,
    this.endedAt,
    this.audioFilePath,
    this.status = RecordingStatus.idle,
    this.errorMessage,
  });

  final String id;
  final DateTime startedAt;
  final DateTime? endedAt;
  final String? audioFilePath;
  final RecordingStatus status;
  final String? errorMessage;

  Duration get duration {
    final end = endedAt ?? DateTime.now();
    return end.difference(startedAt);
  }
}
