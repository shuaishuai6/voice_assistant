import 'package:voice_assistant/features/analysis/domain/conversation_segment.dart';
import 'package:voice_assistant/features/analysis/domain/visit_analysis.dart';
import 'package:voice_assistant/features/analysis/domain/visit_analysis_service.dart';
import 'package:voice_assistant/features/terms/domain/medical_term.dart';

class MockVisitAnalysisService implements VisitAnalysisService {
  @override
  Future<VisitAnalysis> analyzeRecording(String audioFilePath) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    return analyzeSegments(_mockSegments);
  }

  @override
  Future<VisitAnalysis> analyzeSegments(
    List<ConversationSegment> segments,
  ) async {
    return VisitAnalysis(
      summaryTitle: '就诊回顾',
      doctorAdvice: const ['医生建议先观察症状变化，并结合检查结果判断后续安排。'],
      medicationItems: const ['如需用药，请以医生现场说明和药品标签为准。'],
      examItems: const ['建议完成心电图检查。'],
      followUpPlan: const ['一周后根据结果复查。'],
      careNotes: const ['注意休息，若症状加重请及时就医。'],
      conversation: segments,
      terms: const [
        MedicalTerm(
          term: '心电图',
          plainLanguageExplanation: '一种记录心脏电活动的检查。',
          aliases: ['ECG'],
          category: '检查',
        ),
      ],
    );
  }

  static const _mockSegments = [
    ConversationSegment(
      speakerId: SpeakerId.a,
      role: SpeakerRole.doctor,
      startTime: Duration(seconds: 0),
      endTime: Duration(seconds: 4),
      text: '最近哪里不舒服？',
    ),
    ConversationSegment(
      speakerId: SpeakerId.b,
      role: SpeakerRole.patient,
      startTime: Duration(seconds: 5),
      endTime: Duration(seconds: 11),
      text: '胸口有点闷，走快了会更明显。',
    ),
    ConversationSegment(
      speakerId: SpeakerId.a,
      role: SpeakerRole.doctor,
      startTime: Duration(seconds: 12),
      endTime: Duration(seconds: 18),
      text: '建议先做心电图检查，一周后根据结果复查。',
    ),
  ];
}
