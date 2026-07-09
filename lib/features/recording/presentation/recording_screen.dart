import 'package:flutter/material.dart';
import 'package:voice_assistant/app/figma_tokens.dart';
import 'package:voice_assistant/core/disclaimer.dart';
import 'package:voice_assistant/features/analysis/domain/visit_analysis_service.dart';
import 'package:voice_assistant/features/recording/domain/recording_service.dart';
import 'package:voice_assistant/features/recording/domain/recording_session.dart';
import 'package:voice_assistant/features/recording/presentation/recording_controller.dart';
import 'package:voice_assistant/features/results/presentation/results_screen.dart';
import 'package:voice_assistant/features/share/share_service.dart';

class RecordingScreen extends StatefulWidget {
  const RecordingScreen({
    super.key,
    required this.recordingService,
    required this.analysisService,
    required this.shareService,
  });

  final RecordingService recordingService;
  final VisitAnalysisService analysisService;
  final ShareService shareService;

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  late final RecordingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = RecordingController(widget.recordingService);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FigmaColors.background,
      body: SafeArea(
        child: ValueListenableBuilder<RecordingSession>(
          valueListenable: _controller,
          builder: (context, session, _) {
            return Padding(
              padding: const EdgeInsets.all(FigmaSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _Header(),
                  const SizedBox(height: FigmaSpacing.xl),
                  Expanded(child: _MainActionArea(session: session)),
                  if (session.errorMessage != null) ...[
                    const SizedBox(height: FigmaSpacing.md),
                    _ErrorBanner(message: session.errorMessage!),
                  ],
                  const SizedBox(height: FigmaSpacing.lg),
                  _RecordActionButton(
                    session: session,
                    onPressed: () => _handlePrimaryAction(session),
                  ),
                  const SizedBox(height: FigmaSpacing.lg),
                  const _Disclaimer(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _handlePrimaryAction(RecordingSession session) async {
    switch (session.status) {
      case RecordingStatus.idle:
      case RecordingStatus.failed:
      case RecordingStatus.completed:
        await _controller.start();
        return;
      case RecordingStatus.recording:
        await _controller.stop();
        final path = _controller.value.audioFilePath;
        if (!mounted || path == null) {
          return;
        }
        _controller.markAnalyzing();
        try {
          final analysis = await widget.analysisService.analyzeRecording(path);
          if (!mounted) {
            return;
          }
          await Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => ResultsScreen(
                analysis: analysis,
                shareService: widget.shareService,
              ),
            ),
          );
          if (mounted) {
            setState(() {});
          }
          return;
        } catch (_) {
          _controller.markFailed('本地分析暂时没有完成，请稍后重试。');
          return;
        }
      case RecordingStatus.requestingPermission:
      case RecordingStatus.stopping:
      case RecordingStatus.analyzing:
        break;
    }
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: FigmaColors.action,
            borderRadius: BorderRadius.circular(FigmaRadius.md),
          ),
          child: Center(
            child: Image.asset(FigmaAssets.whiteKit, width: 28, height: 28),
          ),
        ),
        const SizedBox(width: FigmaSpacing.md),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '医嘱备忘',
                style: TextStyle(
                  color: FigmaColors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: FigmaSpacing.xs),
              Text(
                '本机记录就诊回顾',
                style: TextStyle(
                  color: FigmaColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MainActionArea extends StatelessWidget {
  const _MainActionArea({required this.session});

  final RecordingSession session;

  @override
  Widget build(BuildContext context) {
    final isRecording = session.status == RecordingStatus.recording;
    final isAnalyzing = session.status == RecordingStatus.analyzing;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 184,
            height: 184,
            decoration: BoxDecoration(
              color: isRecording ? FigmaColors.danger : FigmaColors.action,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (isRecording ? FigmaColors.danger : FigmaColors.action)
                      .withValues(alpha: 0.18),
                  blurRadius: 32,
                  offset: const Offset(0, 18),
                ),
              ],
            ),
            child: Center(
              child: isAnalyzing
                  ? const SizedBox(
                      width: 48,
                      height: 48,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 4,
                      ),
                    )
                  : Image.asset(FigmaAssets.whiteMic, width: 72, height: 112),
            ),
          ),
          const SizedBox(height: FigmaSpacing.xl),
          Text(
            _statusTitle(session.status),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: FigmaColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: FigmaSpacing.sm),
          Text(
            _statusDescription(session.status),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: FigmaColors.textSecondary,
              fontSize: 15,
              height: 1.45,
            ),
          ),
          if (isRecording) ...[
            const SizedBox(height: FigmaSpacing.xl),
            const _Waveform(),
          ],
        ],
      ),
    );
  }

  String _statusTitle(RecordingStatus status) {
    return switch (status) {
      RecordingStatus.recording => '正在记录',
      RecordingStatus.requestingPermission => '请求麦克风权限',
      RecordingStatus.stopping => '正在保存',
      RecordingStatus.analyzing => '分析中',
      RecordingStatus.failed => '未能开始记录',
      RecordingStatus.completed => '已保存记录',
      RecordingStatus.idle => '开始记录',
    };
  }

  String _statusDescription(RecordingStatus status) {
    return switch (status) {
      RecordingStatus.recording => '就诊过程中可以锁屏或切到后台。',
      RecordingStatus.requestingPermission => '请允许麦克风权限。',
      RecordingStatus.stopping => '录音正在保存到本机。',
      RecordingStatus.analyzing => '正在生成本地就诊回顾。',
      RecordingStatus.failed => '请检查权限后再次尝试。',
      RecordingStatus.completed => '可以开始一段新的记录。',
      RecordingStatus.idle => '点击下方按钮开始本地录音。',
    };
  }
}

class _Waveform extends StatelessWidget {
  const _Waveform();

  @override
  Widget build(BuildContext context) {
    const heights = [18.0, 34.0, 26.0, 48.0, 30.0, 42.0, 22.0, 36.0];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: heights
          .map(
            (height) => Container(
              width: 6,
              height: height,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: FigmaColors.action,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _RecordActionButton extends StatelessWidget {
  const _RecordActionButton({required this.session, required this.onPressed});

  final RecordingSession session;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final disabled = switch (session.status) {
      RecordingStatus.requestingPermission ||
      RecordingStatus.stopping ||
      RecordingStatus.analyzing => true,
      _ => false,
    };
    final isRecording = session.status == RecordingStatus.recording;
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: FilledButton.icon(
        onPressed: disabled ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: isRecording
              ? FigmaColors.danger
              : FigmaColors.action,
          foregroundColor: Colors.white,
          disabledBackgroundColor: FigmaColors.mutedGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(FigmaRadius.action),
          ),
        ),
        icon: Image.asset(
          isRecording ? FigmaAssets.whiteKit : FigmaAssets.whiteMic,
          width: isRecording ? 24 : 20,
          height: isRecording ? 24 : 32,
        ),
        label: Text(
          isRecording ? '停止录音' : '开始录音',
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(FigmaSpacing.md),
      decoration: BoxDecoration(
        color: FigmaColors.warningSurface,
        borderRadius: BorderRadius.circular(FigmaRadius.md),
      ),
      child: Text(
        message,
        style: const TextStyle(color: FigmaColors.warningText, fontSize: 14),
      ),
    );
  }
}

class _Disclaimer extends StatelessWidget {
  const _Disclaimer();

  @override
  Widget build(BuildContext context) {
    return const Text(
      medicalDisclaimer,
      style: TextStyle(
        color: FigmaColors.textSecondary,
        fontSize: 12,
        height: 1.4,
      ),
    );
  }
}
