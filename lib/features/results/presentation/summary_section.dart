import 'package:flutter/material.dart';
import 'package:voice_assistant/app/figma_tokens.dart';
import 'package:voice_assistant/features/analysis/domain/visit_analysis.dart';

class SummarySection extends StatelessWidget {
  const SummarySection({super.key, required this.analysis});

  final VisitAnalysis analysis;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(FigmaAssets.greenKit, width: 32, height: 32),
              const SizedBox(width: FigmaSpacing.sm),
              Text(
                analysis.summaryTitle,
                style: const TextStyle(
                  color: FigmaColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: FigmaSpacing.lg),
          _SummaryGroup(title: '医生建议记录', items: analysis.doctorAdvice),
          _SummaryGroup(title: '用药信息', items: analysis.medicationItems),
          _SummaryGroup(title: '检查项目', items: analysis.examItems),
          _SummaryGroup(title: '复查安排', items: analysis.followUpPlan),
          _SummaryGroup(title: '注意事项', items: analysis.careNotes),
        ],
      ),
    );
  }
}

class _SummaryGroup extends StatelessWidget {
  const _SummaryGroup({required this.title, required this.items});

  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: FigmaSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: FigmaColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: FigmaSpacing.sm),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: FigmaSpacing.xs),
              child: Text(
                item,
                style: const TextStyle(
                  color: FigmaColors.textSecondary,
                  fontSize: 15,
                  height: 1.45,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(FigmaSpacing.lg),
      decoration: BoxDecoration(
        color: FigmaColors.surface,
        borderRadius: BorderRadius.circular(FigmaRadius.md),
        border: Border.all(color: FigmaColors.border),
      ),
      child: child,
    );
  }
}
