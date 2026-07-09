import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:voice_assistant/features/terms/domain/medical_term.dart';

class MedicalTermRepository {
  const MedicalTermRepository(this._terms);

  factory MedicalTermRepository.fromJsonString(String source) {
    final decoded = jsonDecode(source) as List<dynamic>;
    return MedicalTermRepository(
      decoded.map((item) {
        final map = item as Map<String, dynamic>;
        return MedicalTerm(
          term: map['term'] as String,
          plainLanguageExplanation: map['plainLanguageExplanation'] as String,
          aliases: (map['aliases'] as List<dynamic>).cast<String>(),
          category: map['category'] as String,
        );
      }).toList(),
    );
  }

  static Future<MedicalTermRepository> load() async {
    final source = await rootBundle.loadString(
      'assets/data/medical_terms.zh.json',
    );
    return MedicalTermRepository.fromJsonString(source);
  }

  final List<MedicalTerm> _terms;

  List<MedicalTerm> matchTerms(String text) {
    return _terms
        .where((term) {
          if (text.contains(term.term)) {
            return true;
          }
          return term.aliases.any(text.contains);
        })
        .toList(growable: false);
  }
}
