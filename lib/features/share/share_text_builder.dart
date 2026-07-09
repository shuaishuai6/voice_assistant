import 'package:voice_assistant/features/analysis/domain/visit_analysis.dart';

class ShareTextBuilder {
  String build(VisitAnalysis analysis) {
    return [
      analysis.summaryTitle,
      '',
      '医生建议记录',
      ...analysis.doctorAdvice.map((item) => '- $item'),
      '',
      '用药信息',
      ...analysis.medicationItems.map((item) => '- $item'),
      '',
      '检查项目',
      ...analysis.examItems.map((item) => '- $item'),
      '',
      '复查安排',
      ...analysis.followUpPlan.map((item) => '- $item'),
      '',
      '注意事项',
      ...analysis.careNotes.map((item) => '- $item'),
      '',
      analysis.disclaimer,
    ].join('\n');
  }
}
