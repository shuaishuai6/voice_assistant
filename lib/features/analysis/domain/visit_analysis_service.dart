import 'package:voice_assistant/features/analysis/domain/conversation_segment.dart';
import 'package:voice_assistant/features/analysis/domain/visit_analysis.dart';

abstract interface class VisitAnalysisService {
  Future<VisitAnalysis> analyzeRecording(String audioFilePath);

  Future<VisitAnalysis> analyzeSegments(List<ConversationSegment> segments);
}
