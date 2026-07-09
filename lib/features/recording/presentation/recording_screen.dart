import 'package:flutter/material.dart';
import 'package:voice_assistant/app/figma_tokens.dart';
import 'package:voice_assistant/features/analysis/domain/visit_analysis_service.dart';
import 'package:voice_assistant/features/recording/domain/recording_service.dart';
import 'package:voice_assistant/features/recording/domain/recording_session.dart';
import 'package:voice_assistant/features/recording/presentation/recording_controller.dart';
import 'package:voice_assistant/features/records/presentation/records_screen.dart';
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
      body: ValueListenableBuilder<RecordingSession>(
        valueListenable: _controller,
        builder: (context, session, _) {
          return Stack(
            children: [
              const _FigmaBackground(),
              SafeArea(
                bottom: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _TopAppBar(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(28, 32, 28, 128),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _GreetingSection(),
                            const SizedBox(height: 32),
                            _RecordingButtonArea(
                              session: session,
                              onPressed: () => _handlePrimaryAction(session),
                            ),
                            if (session.errorMessage != null) ...[
                              const SizedBox(height: 24),
                              _ErrorBanner(message: session.errorMessage!),
                            ],
                            const SizedBox(height: 32),
                            const _SecondaryActionsGrid(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: _BottomNavigationBar(
                  onRecordsTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const RecordsScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
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
        } catch (_) {
          _controller.markFailed('本地分析暂时没有完成，请稍后重试。');
        }
        return;
      case RecordingStatus.requestingPermission:
      case RecordingStatus.stopping:
      case RecordingStatus.analyzing:
        return;
    }
  }
}

class _FigmaBackground extends StatelessWidget {
  const _FigmaBackground();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        color: FigmaColors.background,
        gradient: RadialGradient(
          center: Alignment.topRight,
          radius: 1.2,
          colors: [Color(0x265BDDA8), Color(0x00FFFFFF)],
          stops: [0, 0.55],
        ),
      ),
      child: SizedBox.expand(),
    );
  }
}

class _TopAppBar extends StatelessWidget {
  const _TopAppBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      color: FigmaColors.background,
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Image.asset(FigmaAssets.greenKit, width: 24, height: 24),
          const SizedBox(width: 12),
          const Text(
            '诊断备忘录',
            style: TextStyle(
              color: FigmaColors.brandGreen,
              fontSize: 20,
              height: 1.3,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _GreetingSection extends StatelessWidget {
  const _GreetingSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '下午好',
          style: TextStyle(
            color: FigmaColors.textPrimary,
            fontSize: 20,
            height: 1.3,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
          decoration: BoxDecoration(
            color: FigmaColors.accentGreen.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: FigmaColors.accentGreen.withValues(alpha: 0.20),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: FigmaColors.brandGreen,
                size: 14,
              ),
              const SizedBox(width: 8),
              Text(
                '今日已处理 12 份病历录音',
                style: TextStyle(
                  color: FigmaColors.brandGreen,
                  fontSize: 12,
                  height: 16 / 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.24,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RecordingButtonArea extends StatelessWidget {
  const _RecordingButtonArea({required this.session, required this.onPressed});

  final RecordingSession session;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isBusy = switch (session.status) {
      RecordingStatus.requestingPermission ||
      RecordingStatus.stopping ||
      RecordingStatus.analyzing => true,
      _ => false,
    };
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(
            height: 360,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 336,
                    height: 336,
                    decoration: BoxDecoration(
                      color: FigmaColors.accentGreen.withValues(alpha: 0.10),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      color: FigmaColors.accentGreen.withValues(alpha: 0.14),
                      shape: BoxShape.circle,
                    ),
                  ),
                  GestureDetector(
                    onTap: isBusy ? null : onPressed,
                    child: Container(
                      width: 224,
                      height: 224,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            FigmaColors.brandGreen,
                            FigmaColors.accentGreen,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x4D006C4B),
                            blurRadius: 30,
                            offset: Offset(0, 10),
                          ),
                          BoxShadow(
                            color: Color(0x1A006C4B),
                            blurRadius: 40,
                            offset: Offset(0, 20),
                          ),
                        ],
                      ),
                      child: isBusy
                          ? const Center(
                              child: SizedBox(
                                width: 44,
                                height: 44,
                                child: CircularProgressIndicator(
                                  strokeWidth: 4,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  FigmaAssets.whiteMic,
                                  width: 38,
                                  height: 58,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  session.status == RecordingStatus.recording
                                      ? '停止记录'
                                      : '开始记录',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    height: 24 / 18,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.9,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            _statusLine(session.status),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: FigmaColors.textSecondary,
              fontSize: 16,
              height: 24 / 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: FigmaColors.brandGreen,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'SYSTEM READY',
                style: TextStyle(
                  color: Color(0x99006C4B),
                  fontSize: 11,
                  height: 14 / 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _statusLine(RecordingStatus status) {
    return switch (status) {
      RecordingStatus.recording => '正在为您捕捉诊室细节',
      RecordingStatus.requestingPermission => '正在请求麦克风权限',
      RecordingStatus.stopping => '正在保存录音',
      RecordingStatus.analyzing => '正在生成就诊回顾',
      RecordingStatus.failed => '请检查权限后再次尝试',
      RecordingStatus.completed => '进入诊室，AI 为您捕捉细节',
      RecordingStatus.idle => '进入诊室，AI 为您捕捉细节',
    };
  }
}

class _SecondaryActionsGrid extends StatelessWidget {
  const _SecondaryActionsGrid();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _ActionCard(
            icon: Icons.camera_alt,
            iconColor: Color(0xFF0B2441),
            iconBackground: Color(0xFFD4E3FF),
            title: '拍处方单',
            subtitle: 'OCR 自动识别',
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _ActionCard(
            icon: Icons.upload_file,
            iconColor: Color(0xFF4F2B0C),
            iconBackground: Color(0xFFFFDDBB),
            title: '上传音频',
            subtitle: '支持 MP3/WAV',
          ),
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.70),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.50)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              color: FigmaColors.textPrimary,
              fontSize: 16,
              height: 20 / 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              color: FigmaColors.textSecondary,
              fontSize: 12,
              height: 16 / 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.24,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNavigationBar extends StatelessWidget {
  const _BottomNavigationBar({required this.onRecordsTap});

  final VoidCallback onRecordsTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78 + MediaQuery.paddingOf(context).bottom,
      padding: EdgeInsets.fromLTRB(
        72,
        8,
        72,
        8 + MediaQuery.paddingOf(context).bottom,
      ),
      decoration: const BoxDecoration(
        color: FigmaColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 6,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const _NavItem(
            active: true,
            activeAsset: FigmaAssets.greenMic,
            inactiveAsset: FigmaAssets.mutedMic,
            label: '录音',
          ),
          _NavItem(
            active: false,
            activeAsset: FigmaAssets.greenKit,
            inactiveAsset: FigmaAssets.mutedKit,
            label: '记录',
            onTap: onRecordsTap,
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.active,
    required this.activeAsset,
    required this.inactiveAsset,
    required this.label,
    this.onTap,
  });

  final bool active;
  final String activeAsset;
  final String inactiveAsset;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 88,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: active ? FigmaColors.accentGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              active ? activeAsset : inactiveAsset,
              width: active ? 14 : 20,
              height: active ? 19 : 20,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: active
                    ? const Color(0xFF003221)
                    : FigmaColors.textSecondary,
                fontSize: 12,
                height: 16 / 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.24,
              ),
            ),
          ],
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
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: FigmaColors.warningSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        message,
        style: const TextStyle(color: FigmaColors.warningText, fontSize: 14),
      ),
    );
  }
}
