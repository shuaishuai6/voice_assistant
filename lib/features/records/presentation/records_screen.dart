import 'package:flutter/material.dart';
import 'package:voice_assistant/app/figma_tokens.dart';
import 'package:voice_assistant/features/records/presentation/record_detail_screen.dart';

class MedicalRecord {
  const MedicalRecord({
    required this.dateLabel,
    required this.title,
    required this.summary,
    required this.footerLabel,
    required this.isToday,
    required this.hasAttachment,
  });

  final String dateLabel;
  final String title;
  final String summary;
  final String footerLabel;
  final bool isToday;
  final bool hasAttachment;
}

const medicalRecords = [
  MedicalRecord(
    dateLabel: '今天',
    title: '皮肤过敏',
    summary: '患者描述在接触某种新型洗涤剂后，双臂出现红色丘疹并伴有剧烈瘙痒。初步诊断为接触性皮炎，建议使',
    footerLabel: '语音记录 2:45',
    isToday: true,
    hasAttachment: false,
  ),
  MedicalRecord(
    dateLabel: '2023年10月12日',
    title: '季节性流感',
    summary: '轻微发烧 38.2°C，伴有干咳和全身乏力。流感检测呈阳性。处方：奥司他韦，多休息，增加水分摄入。',
    footerLabel: '语音记录 2:45',
    isToday: false,
    hasAttachment: false,
  ),
  MedicalRecord(
    dateLabel: '2023年9月28日',
    title: '年度常规体检',
    summary: '各项指标基本正常。血脂略高，建议调整饮食结构，增加有氧运动量。下月进行复查。',
    footerLabel: '2 份附件',
    isToday: false,
    hasAttachment: true,
  ),
];

class RecordsScreen extends StatelessWidget {
  const RecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FigmaColors.background,
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                const _RecordsHeader(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(28, 24, 28, 112),
                    children: [
                      const _SearchBar(),
                      const SizedBox(height: 24),
                      const _SectionTitle(),
                      const SizedBox(height: 16),
                      ...medicalRecords.map(
                        (record) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _RecordCard(record: record),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _RecordsBottomNav(
              onRecordingTap: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecordsHeader extends StatelessWidget {
  const _RecordsHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 28),
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

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0D000000),
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: Color(0xFF6D7A72), size: 18),
                SizedBox(width: 12),
                Text(
                  '搜索诊断、日期或内容',
                  style: TextStyle(
                    color: Color(0xFF6D7A72),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFF6F3F2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.filter_list,
            color: FigmaColors.textPrimary,
            size: 22,
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '最近录入',
          style: TextStyle(
            color: FigmaColors.textPrimary,
            fontSize: 18,
            height: 24 / 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          '查看全部',
          style: TextStyle(
            color: FigmaColors.brandGreen,
            fontSize: 12,
            height: 16 / 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.24,
          ),
        ),
      ],
    );
  }
}

class _RecordCard extends StatelessWidget {
  const _RecordCard({required this.record});

  final MedicalRecord record;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x80F0EDED)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: record.isToday
                      ? FigmaColors.brandGreen.withValues(alpha: 0.10)
                      : const Color(0xFFEAE7E7),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  record.dateLabel,
                  style: TextStyle(
                    color: record.isToday
                        ? FigmaColors.brandGreen
                        : FigmaColors.textSecondary,
                    fontSize: 11,
                    height: 14 / 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(Icons.more_vert, color: Color(0xFF6D7A72), size: 18),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            record.title,
            style: const TextStyle(
              color: FigmaColors.textPrimary,
              fontSize: 18,
              height: 24 / 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            record.summary,
            maxLines: 2,
            overflow: TextOverflow.clip,
            style: const TextStyle(
              color: FigmaColors.textSecondary,
              fontSize: 14,
              height: 20 / 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Container(height: 1, color: const Color(0xFFF0EDED)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    record.hasAttachment ? Icons.attachment : Icons.mic_none,
                    size: 16,
                    color: const Color(0xFF6D7A72),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    record.footerLabel,
                    style: const TextStyle(
                      color: Color(0xFF6D7A72),
                      fontSize: 12,
                      height: 16 / 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.24,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const RecordDetailScreen(),
                    ),
                  );
                },
                child: const Row(
                  children: [
                    Text(
                      '查看详情',
                      style: TextStyle(
                        color: FigmaColors.brandGreen,
                        fontSize: 12,
                        height: 16 / 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.24,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward,
                      color: FigmaColors.brandGreen,
                      size: 14,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RecordsBottomNav extends StatelessWidget {
  const _RecordsBottomNav({required this.onRecordingTap});

  final VoidCallback onRecordingTap;

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
          _NavItem(
            active: false,
            activeAsset: FigmaAssets.greenMic,
            inactiveAsset: FigmaAssets.mutedMic,
            label: '录音',
            onTap: onRecordingTap,
          ),
          const _NavItem(
            active: true,
            activeAsset: FigmaAssets.greenKit,
            inactiveAsset: FigmaAssets.mutedKit,
            label: '记录',
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
              width: active ? 20 : 20,
              height: active ? 20 : 20,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: active
                    ? (label == '录音'
                          ? const Color(0xFF003221)
                          : FigmaColors.textSecondary)
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
