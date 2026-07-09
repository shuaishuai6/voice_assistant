import 'package:flutter_test/flutter_test.dart';
import 'package:voice_assistant/features/analysis/data/rule_based_visit_analysis_service.dart';
import 'package:voice_assistant/features/analysis/domain/conversation_segment.dart';

void main() {
  test('extracts conservative sections from conversation text', () async {
    final service = RuleBasedVisitAnalysisService();

    final analysis = await service.analyzeSegments(const [
      ConversationSegment(
        speakerId: SpeakerId.a,
        role: SpeakerRole.doctor,
        startTime: Duration.zero,
        endTime: Duration(seconds: 4),
        text: '建议先做心电图检查。',
      ),
      ConversationSegment(
        speakerId: SpeakerId.a,
        role: SpeakerRole.doctor,
        startTime: Duration(seconds: 5),
        endTime: Duration(seconds: 9),
        text: '这个药饭后吃，一天两次。',
      ),
      ConversationSegment(
        speakerId: SpeakerId.a,
        role: SpeakerRole.doctor,
        startTime: Duration(seconds: 10),
        endTime: Duration(seconds: 15),
        text: '一周后复查，注意休息。',
      ),
    ]);

    expect(analysis.examItems.single, contains('心电图'));
    expect(analysis.medicationItems.single, contains('饭后'));
    expect(analysis.followUpPlan.single, contains('复查'));
    expect(analysis.careNotes.single, contains('注意'));
  });
}
