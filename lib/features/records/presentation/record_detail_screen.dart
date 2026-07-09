import 'package:flutter/material.dart';
import 'package:voice_assistant/app/figma_tokens.dart';

class RecordDetailScreen extends StatelessWidget {
  const RecordDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FigmaColors.background,
      body: Stack(
        children: [
          Column(
            children: [
              SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    _DetailHeader(onBack: () => Navigator.of(context).pop()),
                    const _TabSwitcher(),
                  ],
                ),
              ),
              const Expanded(child: _ConversationTimeline()),
            ],
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: _AudioPlayerSection(),
          ),
        ],
      ),
    );
  }
}

class _DetailHeader extends StatelessWidget {
  const _DetailHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.chevron_left),
            color: FigmaColors.brandGreen,
            iconSize: 30,
            tooltip: '返回',
          ),
          const SizedBox(width: 6),
          const Text(
            '2026年1月23日 周五',
            style: TextStyle(
              color: FigmaColors.brandGreen,
              fontSize: 20,
              height: 26 / 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabSwitcher extends StatelessWidget {
  const _TabSwitcher();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F3F2),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: FigmaColors.background,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0D000000),
                      blurRadius: 1,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: const Text(
                  '对话记录',
                  style: TextStyle(
                    color: FigmaColors.brandGreen,
                    fontSize: 16,
                    height: 24 / 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const Expanded(
              child: Center(
                child: Text(
                  'AI 总结',
                  style: TextStyle(
                    color: FigmaColors.textSecondary,
                    fontSize: 16,
                    height: 24 / 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConversationTimeline extends StatelessWidget {
  const _ConversationTimeline();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 188),
      children: const [
        _DoctorMessage(time: '00:02', text: '您好，请描述一下您的症状。\n这种情况持续多久了？'),
        _PatientMessage(
          time: '00:15',
          text: '医生，我最近头皮这里有点红肿发痒，大概是从上周三开始的。尤其是洗头之后感觉更明显。',
        ),
        _DoctorMessage(time: '00:48', text: '有没有脱屑或者渗液的情况？\n平时使用什么类型的洗发水？'),
        _PatientMessage(
          time: '01:02',
          text: '有一点点白色的皮屑，但是没有渗水。洗发水就是超市买的普通去屑型的。',
        ),
        _DoctorMessage(
          time: '01:25',
          text: '明白了。听起来像是脂溢性皮炎。我会先给您开一个处方洗发剂，您先用两周看看。另外饮食要清淡一些。',
        ),
      ],
    );
  }
}

class _DoctorMessage extends StatelessWidget {
  const _DoctorMessage({required this.time, required this.text});

  final String time;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Avatar(color: FigmaColors.accentGreen, icon: Icons.medical_services),
          const SizedBox(width: 16),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      '医生 (Speaker A)',
                      style: TextStyle(
                        color: FigmaColors.brandGreen,
                        fontSize: 16,
                        height: 24 / 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      time,
                      style: const TextStyle(
                        color: Color(0xFF6D7A72),
                        fontSize: 16,
                        height: 24 / 16,
                      ),
                    ),
                  ],
                ),
                Container(
                  constraints: const BoxConstraints(maxWidth: 250),
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                  decoration: const BoxDecoration(
                    color: Color(0x1A00A676),
                    border: Border(
                      left: BorderSide(color: FigmaColors.brandGreen, width: 4),
                    ),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x0D000000),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: Color(0xFF003221),
                      fontSize: 16,
                      height: 26 / 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PatientMessage extends StatelessWidget {
  const _PatientMessage({required this.time, required this.text});

  final String time;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      time,
                      style: const TextStyle(
                        color: Color(0xFF6D7A72),
                        fontSize: 16,
                        height: 24 / 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '患者 (Speaker B)',
                      style: TextStyle(
                        color: Color(0xFF0060AC),
                        fontSize: 16,
                        height: 24 / 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                Container(
                  constraints: const BoxConstraints(maxWidth: 250),
                  padding: const EdgeInsets.fromLTRB(16, 16, 20, 16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      right: BorderSide(color: Color(0xFF0060AC), width: 4),
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x0D000000),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Text(
                    text,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: FigmaColors.textSecondary,
                      fontSize: 16,
                      height: 26 / 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          const _Avatar(color: Color(0xFF68ABFF), icon: Icons.person),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.color, required this.icon});

  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }
}

class _AudioPlayerSection extends StatelessWidget {
  const _AudioPlayerSection();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(
          16,
          9,
          16,
          32 + MediaQuery.paddingOf(context).bottom,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.86),
          border: const Border(top: BorderSide(color: Color(0x1ABCCAC0))),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _Waveform(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: 48,
                  child: Text(
                    '01:47',
                    style: TextStyle(
                      color: Color(0xFF6D7A72),
                      fontSize: 16,
                      height: 24 / 16,
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.replay_10,
                      color: FigmaColors.brandGreen,
                      size: 28,
                    ),
                    const SizedBox(width: 32),
                    Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        color: FigmaColors.brandGreen,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x1A000000),
                            blurRadius: 15,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 32),
                    const Icon(
                      Icons.forward_10,
                      color: FigmaColors.brandGreen,
                      size: 28,
                    ),
                  ],
                ),
                const SizedBox(
                  width: 48,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.speed,
                      color: FigmaColors.textSecondary,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: const LinearProgressIndicator(
                value: 0.65,
                minHeight: 4,
                color: FigmaColors.brandGreen,
                backgroundColor: Color(0x4DBCCAC0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Waveform extends StatelessWidget {
  const _Waveform();

  @override
  Widget build(BuildContext context) {
    const heights = [
      16.0,
      24.0,
      12.0,
      32.0,
      20.0,
      40.0,
      28.0,
      36.0,
      16.0,
      24.0,
      8.0,
      32.0,
      20.0,
      48.0,
      28.0,
      16.0,
      36.0,
      12.0,
      20.0,
      28.0,
      16.0,
    ];
    return SizedBox(
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < heights.length; i++)
            Container(
              width: 4,
              height: heights[i],
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: FigmaColors.brandGreen.withValues(
                  alpha: i == 5 || i == 13 ? 1 : 0.2 + (i % 5) * 0.1,
                ),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
        ],
      ),
    );
  }
}
