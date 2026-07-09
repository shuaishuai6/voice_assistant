import 'package:flutter_test/flutter_test.dart';
import 'package:voice_assistant/features/analysis/domain/visit_analysis.dart';
import 'package:voice_assistant/features/share/share_text_builder.dart';

void main() {
  test('share text contains note content and disclaimer only', () {
    final text = ShareTextBuilder().build(VisitAnalysis.empty());

    expect(text, contains('就诊回顾'));
    expect(text, contains('本 App 仅供个人记录'));
    expect(text, isNot(contains('.wav')));
    expect(text, isNot(contains('/tmp/')));
  });
}
