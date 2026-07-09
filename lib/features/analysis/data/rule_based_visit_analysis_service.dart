import 'package:voice_assistant/features/analysis/domain/conversation_segment.dart';
import 'package:voice_assistant/features/analysis/domain/visit_analysis.dart';
import 'package:voice_assistant/features/analysis/domain/visit_analysis_service.dart';

class RuleBasedVisitAnalysisService implements VisitAnalysisService {
  @override
  Future<VisitAnalysis> analyzeRecording(String audioFilePath) async {
    return VisitAnalysis.empty();
  }

  @override
  Future<VisitAnalysis> analyzeSegments(
    List<ConversationSegment> segments,
  ) async {
    final texts = segments.map((segment) => segment.text).toList();
    return VisitAnalysis(
      summaryTitle: '就诊回顾',
      doctorAdvice: _findAny(texts, const ['建议', '需要', '可以']),
      medicationItems: _findAny(texts, const [
        '药',
        '片',
        '胶囊',
        '每日',
        '一天',
        '饭后',
        '饭前',
      ]),
      examItems: _findAny(texts, const ['检查', '化验', 'CT', '超声', '心电图', '抽血']),
      followUpPlan: _findAny(texts, const [
        '复查',
        '复诊',
        '下周',
        '一周',
        '一个月',
        '三个月',
      ]),
      careNotes: _findAny(texts, const ['注意', '少吃', '避免', '休息', '观察']),
      conversation: segments,
      terms: const [],
    );
  }

  List<String> _findAny(List<String> texts, List<String> keywords) {
    final matches = texts
        .where((text) => keywords.any(text.contains))
        .toList(growable: false);
    if (matches.isNotEmpty) {
      return matches;
    }
    return const ['本次记录中未明确提到。'];
  }
}
