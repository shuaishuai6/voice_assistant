import 'package:flutter/material.dart';
import 'package:voice_assistant/app/figma_tokens.dart';
import 'package:voice_assistant/features/analysis/domain/conversation_segment.dart';

class TimelineSection extends StatelessWidget {
  const TimelineSection({super.key, required this.segments});

  final List<ConversationSegment> segments;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '对话时间线',
          style: TextStyle(
            color: FigmaColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: FigmaSpacing.md),
        ...segments.map((segment) => _TimelineItem(segment: segment)),
      ],
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({required this.segment});

  final ConversationSegment segment;

  @override
  Widget build(BuildContext context) {
    final color = switch (segment.role) {
      SpeakerRole.doctor => FigmaColors.doctor,
      SpeakerRole.patient => FigmaColors.patient,
      SpeakerRole.unknown => FigmaColors.mutedGreen,
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: FigmaSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 9),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: FigmaSpacing.sm),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(FigmaSpacing.md),
              decoration: BoxDecoration(
                color: FigmaColors.surface,
                borderRadius: BorderRadius.circular(FigmaRadius.md),
                border: Border.all(color: FigmaColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${segment.roleLabel} · ${_format(segment.startTime)}',
                    style: TextStyle(
                      color: color,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: FigmaSpacing.xs),
                  Text(
                    segment.text,
                    style: const TextStyle(
                      color: FigmaColors.textPrimary,
                      fontSize: 15,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _format(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
