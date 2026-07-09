import 'package:flutter/material.dart';
import 'package:voice_assistant/app/figma_tokens.dart';
import 'package:voice_assistant/features/analysis/domain/visit_analysis.dart';
import 'package:voice_assistant/features/results/presentation/summary_section.dart';
import 'package:voice_assistant/features/results/presentation/timeline_section.dart';
import 'package:voice_assistant/features/share/share_service.dart';
import 'package:voice_assistant/features/share/share_text_builder.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({
    super.key,
    required this.analysis,
    required this.shareService,
  });

  final VisitAnalysis analysis;
  final ShareService shareService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FigmaColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(FigmaSpacing.lg),
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back),
                  color: FigmaColors.textPrimary,
                  tooltip: '返回',
                ),
                const SizedBox(width: FigmaSpacing.sm),
                const Text(
                  '就诊回顾',
                  style: TextStyle(
                    color: FigmaColors.textPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: FigmaSpacing.lg),
            SummarySection(analysis: analysis),
            const SizedBox(height: FigmaSpacing.xl),
            TimelineSection(segments: analysis.conversation),
            const SizedBox(height: FigmaSpacing.xl),
            _TermsSection(analysis: analysis),
            const SizedBox(height: FigmaSpacing.lg),
            FilledButton.icon(
              onPressed: () {
                final text = ShareTextBuilder().build(analysis);
                shareService.shareText(text);
              },
              style: FilledButton.styleFrom(
                backgroundColor: FigmaColors.action,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(FigmaRadius.action),
                ),
              ),
              icon: const Icon(Icons.ios_share),
              label: const Text('分享给家人'),
            ),
            const SizedBox(height: FigmaSpacing.md),
            Text(
              analysis.disclaimer,
              style: const TextStyle(
                color: FigmaColors.textSecondary,
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TermsSection extends StatelessWidget {
  const _TermsSection({required this.analysis});

  final VisitAnalysis analysis;

  @override
  Widget build(BuildContext context) {
    if (analysis.terms.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '术语解释',
          style: TextStyle(
            color: FigmaColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: FigmaSpacing.md),
        ...analysis.terms.map(
          (term) => Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: FigmaSpacing.sm),
            padding: const EdgeInsets.all(FigmaSpacing.md),
            decoration: BoxDecoration(
              color: FigmaColors.surfaceMuted,
              borderRadius: BorderRadius.circular(FigmaRadius.md),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  term.term,
                  style: const TextStyle(
                    color: FigmaColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: FigmaSpacing.xs),
                Text(
                  term.plainLanguageExplanation,
                  style: const TextStyle(
                    color: FigmaColors.textSecondary,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
