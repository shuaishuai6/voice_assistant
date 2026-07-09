import 'package:voice_assistant/core/disclaimer.dart';
import 'package:voice_assistant/features/analysis/domain/conversation_segment.dart';
import 'package:voice_assistant/features/terms/domain/medical_term.dart';

class VisitAnalysis {
  const VisitAnalysis({
    required this.summaryTitle,
    required this.doctorAdvice,
    required this.medicationItems,
    required this.examItems,
    required this.followUpPlan,
    required this.careNotes,
    required this.conversation,
    required this.terms,
    this.disclaimer = medicalDisclaimer,
  });

  factory VisitAnalysis.empty() {
    return const VisitAnalysis(
      summaryTitle: '就诊回顾',
      doctorAdvice: ['本次记录中未明确提到医生建议。'],
      medicationItems: ['本次记录中未明确提到用药信息。'],
      examItems: ['本次记录中未明确提到检查项目。'],
      followUpPlan: ['本次记录中未明确提到复查安排。'],
      careNotes: ['本次记录中未明确提到注意事项。'],
      conversation: <ConversationSegment>[],
      terms: <MedicalTerm>[],
    );
  }

  final String summaryTitle;
  final List<String> doctorAdvice;
  final List<String> medicationItems;
  final List<String> examItems;
  final List<String> followUpPlan;
  final List<String> careNotes;
  final List<ConversationSegment> conversation;
  final List<MedicalTerm> terms;
  final String disclaimer;
}
