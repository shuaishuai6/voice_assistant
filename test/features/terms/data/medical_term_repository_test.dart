import 'package:flutter_test/flutter_test.dart';
import 'package:voice_assistant/features/terms/data/medical_term_repository.dart';

void main() {
  test('matches known terms by term and alias', () {
    final repository = MedicalTermRepository.fromJsonString('''
[
  {
    "term": "超声",
    "plainLanguageExplanation": "声波检查。",
    "aliases": ["B超"],
    "category": "检查"
  }
]
''');

    final matches = repository.matchTerms('医生建议做一个B超检查');

    expect(matches, hasLength(1));
    expect(matches.single.term, '超声');
  });
}
