import 'package:flutter_test/flutter_test.dart';
import 'package:voice_assistant/core/disclaimer.dart';
import 'package:voice_assistant/features/analysis/domain/conversation_segment.dart';
import 'package:voice_assistant/features/analysis/domain/visit_analysis.dart';

void main() {
  test('visit analysis keeps conservative empty section text', () {
    final analysis = VisitAnalysis.empty();

    expect(analysis.medicationItems.single, contains('未明确提到'));
    expect(analysis.examItems.single, contains('未明确提到'));
    expect(analysis.disclaimer, medicalDisclaimer);
  });

  test('conversation segment validates speaker and role values', () {
    const segment = ConversationSegment(
      speakerId: SpeakerId.a,
      role: SpeakerRole.doctor,
      startTime: Duration(seconds: 1),
      endTime: Duration(seconds: 4),
      text: '最近哪里不舒服？',
    );

    expect(segment.speakerLabel, '说话人 A');
    expect(segment.roleLabel, '医生');
    expect(segment.duration, const Duration(seconds: 3));
  });
}
