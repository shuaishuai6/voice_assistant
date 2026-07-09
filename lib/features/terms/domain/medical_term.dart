class MedicalTerm {
  const MedicalTerm({
    required this.term,
    required this.plainLanguageExplanation,
    required this.aliases,
    required this.category,
  });

  final String term;
  final String plainLanguageExplanation;
  final List<String> aliases;
  final String category;
}
