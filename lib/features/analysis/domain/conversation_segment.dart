enum SpeakerId { a, b }

enum SpeakerRole { doctor, patient, unknown }

class ConversationSegment {
  const ConversationSegment({
    required this.speakerId,
    required this.role,
    required this.startTime,
    required this.endTime,
    required this.text,
  });

  final SpeakerId speakerId;
  final SpeakerRole role;
  final Duration startTime;
  final Duration endTime;
  final String text;

  Duration get duration => endTime - startTime;

  String get speakerLabel => switch (speakerId) {
    SpeakerId.a => '说话人 A',
    SpeakerId.b => '说话人 B',
  };

  String get roleLabel => switch (role) {
    SpeakerRole.doctor => '医生',
    SpeakerRole.patient => '患者',
    SpeakerRole.unknown => '未知角色',
  };
}
