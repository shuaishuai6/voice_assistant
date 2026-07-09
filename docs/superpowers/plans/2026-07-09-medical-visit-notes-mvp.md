# Medical Visit Notes MVP Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the first iOS-focused Flutter MVP for `医嘱备忘`: Figma-matched UI, local recording, local MVP analysis, structured result display, term explanations, and text-only sharing.

**Architecture:** Flutter owns screens, state, domain models, local analysis, and share text generation. Swift owns iOS recording through a MethodChannel so background audio and WAV settings can be controlled natively. The analysis API is intentionally replaceable so later FluidAudio, Apple Speech, or local model work can plug in without rewriting the UI.

**Tech Stack:** Flutter 3.x, Dart 3.10.x, Swift 5.9+, iOS 16+, AVFoundation, MethodChannel, local JSON assets, Flutter widget/unit tests, XCTest for native recorder behavior where practical.

---

## Pre-Implementation Rules

- Do not connect any LLM in the MVP.
- Do not add cloud upload, remote analytics, or network medical processing.
- Do not invent visual colors, spacing, icons, or typography. Use Figma as the UI source of truth.
- If Figma MCP is unavailable, pause UI implementation and request exported screenshots or exact frame/node links.
- Keep all user medical content local to the app sandbox.
- Use product language from the design spec and avoid primary UI labels that imply diagnosis or prescribing.

## Target File Structure

Create or modify these files:

- Modify: `pubspec.yaml` - add local assets and Flutter dependencies only when needed.
- Replace: `lib/main.dart` - bootstrap the production app shell.
- Create: `lib/app/visit_notes_app.dart` - app root, routes, Figma-derived theme.
- Create: `lib/app/figma_tokens.dart` - color, spacing, radius, and typography tokens copied from Figma context.
- Create: `lib/core/disclaimer.dart` - required disclaimer text.
- Create: `lib/features/recording/domain/recording_session.dart` - recording model and status enum.
- Create: `lib/features/recording/domain/recording_service.dart` - platform-independent recording interface.
- Create: `lib/features/recording/data/ios_recording_service.dart` - MethodChannel adapter.
- Create: `lib/features/recording/presentation/recording_controller.dart` - screen state orchestration.
- Create: `lib/features/recording/presentation/recording_screen.dart` - Figma-matched recording UI.
- Create: `lib/features/analysis/domain/conversation_segment.dart` - speaker timeline model.
- Create: `lib/features/analysis/domain/visit_analysis.dart` - structured note model.
- Create: `lib/features/analysis/domain/visit_analysis_service.dart` - analysis interface.
- Create: `lib/features/analysis/data/mock_visit_analysis_service.dart` - deterministic MVP analysis for UI/dev.
- Create: `lib/features/analysis/data/rule_based_visit_analysis_service.dart` - conservative local extraction.
- Create: `lib/features/results/presentation/results_screen.dart` - Figma-matched result page.
- Create: `lib/features/results/presentation/summary_section.dart` - structured note widgets.
- Create: `lib/features/results/presentation/timeline_section.dart` - speaker timeline widgets.
- Create: `lib/features/terms/domain/medical_term.dart` - term model.
- Create: `lib/features/terms/data/medical_term_repository.dart` - local JSON loader and matcher.
- Create: `lib/features/share/share_text_builder.dart` - pure text export.
- Create: `assets/data/medical_terms.zh.json` - local MVP term library.
- Modify: `ios/Runner/Info.plist` - microphone permission and background audio keys.
- Modify: `ios/Runner/AppDelegate.swift` - MethodChannel registration.
- Create: `ios/Runner/AudioRecorderService.swift` - AVFoundation recorder.
- Create: `test/features/...` - Dart unit and widget tests.

## Task 1: Figma Design Gate

**Files:**
- Create: `docs/ui/figma-mvp-audit.md`
- Create after Figma access: `lib/app/figma_tokens.dart`

- [ ] **Step 1: Fetch Figma context**

Use the Figma MCP flow from the `figma` skill:

1. Run `get_design_context` for the exact MVP frames.
2. Run `get_screenshot` for each frame.
3. Download required assets from the MCP server if provided.

Required frames:

- Recording home state.
- Recording active state.
- Analysis/loading state.
- Result page.
- Term explanation state or modal.
- Share action entry point, if designed.

- [ ] **Step 2: Write the UI audit**

Create `docs/ui/figma-mvp-audit.md` with this structure:

```markdown
# Figma MVP Audit

## Source

- Figma URL:
- Retrieved date:
- Frames:

## Tokens

### Colors

| Token | Value | Used For |
| --- | --- | --- |

### Typography

| Style | Font | Size | Weight | Line Height | Used For |
| --- | --- | --- | --- | --- | --- |

### Spacing And Radius

| Token | Value | Used For |
| --- | --- | --- |

## Required Screens

| Screen | Figma Frame | Implementation File |
| --- | --- | --- |
| Recording idle | | `lib/features/recording/presentation/recording_screen.dart` |
| Recording active | | `lib/features/recording/presentation/recording_screen.dart` |
| Analysis loading | | `lib/features/recording/presentation/recording_screen.dart` |
| Results | | `lib/features/results/presentation/results_screen.dart` |

## Asset Inventory

| Asset | Source | Local Path | Notes |
| --- | --- | --- | --- |
```

- [ ] **Step 3: Create Figma token file**

Create `lib/app/figma_tokens.dart` using actual values from Figma:

```dart
import 'package:flutter/material.dart';

abstract final class FigmaColors {
  static const background = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF111111);
  static const textSecondary = Color(0xFF666666);
  static const doctor = Color(0xFF000000);
  static const patient = Color(0xFF000000);
  static const action = Color(0xFF000000);
  static const danger = Color(0xFF000000);
}

abstract final class FigmaSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
}

abstract final class FigmaRadius {
  static const sm = 4.0;
  static const md = 8.0;
  static const lg = 12.0;
}
```

Replace every `0xFF000000` placeholder with actual Figma values before any UI task is considered done.

- [ ] **Step 4: Verify the gate**

Expected:

- `docs/ui/figma-mvp-audit.md` names every MVP frame.
- `lib/app/figma_tokens.dart` has no placeholder black tokens except colors that are genuinely black in Figma.
- Implementation can proceed only after this check.

## Task 2: Domain Models And Disclaimer

**Files:**
- Create: `lib/core/disclaimer.dart`
- Create: `lib/features/recording/domain/recording_session.dart`
- Create: `lib/features/analysis/domain/conversation_segment.dart`
- Create: `lib/features/analysis/domain/visit_analysis.dart`
- Test: `test/features/analysis/domain/visit_analysis_test.dart`

- [ ] **Step 1: Write model tests**

Create `test/features/analysis/domain/visit_analysis_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:voice_assistant/core/disclaimer.dart';
import 'package:voice_assistant/features/analysis/domain/conversation_segment.dart';
import 'package:voice_assistant/features/analysis/domain/visit_analysis.dart';

void main() {
  test('visit analysis keeps conservative empty section text', () {
    final analysis = VisitAnalysis.empty();

    expect(analysis.medicationItems.single, contains('未明确提到'));
    expect(analysis.examItems.single, contains('未明确提到'));
    expect(analysis.disclaimer, medicalDisclaimer);
  });

  test('conversation segment validates speaker and role values', () {
    const segment = ConversationSegment(
      speakerId: SpeakerId.a,
      role: SpeakerRole.doctor,
      startTime: Duration(seconds: 1),
      endTime: Duration(seconds: 4),
      text: '最近哪里不舒服？',
    );

    expect(segment.speakerLabel, '说话人 A');
    expect(segment.roleLabel, '医生');
    expect(segment.duration, const Duration(seconds: 3));
  });
}
```

- [ ] **Step 2: Run the failing test**

Run:

```bash
flutter test test/features/analysis/domain/visit_analysis_test.dart
```

Expected: fails because model files do not exist yet.

- [ ] **Step 3: Implement disclaimer and models**

Create `lib/core/disclaimer.dart`:

```dart
const medicalDisclaimer =
    '本 App 仅供个人记录就诊信息参考，不提供任何医疗诊断或治疗建议。所有内容以医生口头医嘱为准。';
```

Create `lib/features/analysis/domain/conversation_segment.dart`:

```dart
enum SpeakerId { a, b }

enum SpeakerRole { doctor, patient, unknown }

class ConversationSegment {
  const ConversationSegment({
    required this.speakerId,
    required this.role,
    required this.startTime,
    required this.endTime,
    required this.text,
  });

  final SpeakerId speakerId;
  final SpeakerRole role;
  final Duration startTime;
  final Duration endTime;
  final String text;

  Duration get duration => endTime - startTime;

  String get speakerLabel => switch (speakerId) {
        SpeakerId.a => '说话人 A',
        SpeakerId.b => '说话人 B',
      };

  String get roleLabel => switch (role) {
        SpeakerRole.doctor => '医生',
        SpeakerRole.patient => '患者',
        SpeakerRole.unknown => '未知角色',
      };
}
```

Create `lib/features/analysis/domain/visit_analysis.dart`:

```dart
import 'package:voice_assistant/core/disclaimer.dart';
import 'package:voice_assistant/features/analysis/domain/conversation_segment.dart';
import 'package:voice_assistant/features/terms/domain/medical_term.dart';

class VisitAnalysis {
  const VisitAnalysis({
    required this.summaryTitle,
    required this.doctorAdvice,
    required this.medicationItems,
    required this.examItems,
    required this.followUpPlan,
    required this.careNotes,
    required this.conversation,
    required this.terms,
    this.disclaimer = medicalDisclaimer,
  });

  factory VisitAnalysis.empty() {
    return const VisitAnalysis(
      summaryTitle: '就诊回顾',
      doctorAdvice: ['本次记录中未明确提到医生建议。'],
      medicationItems: ['本次记录中未明确提到用药信息。'],
      examItems: ['本次记录中未明确提到检查项目。'],
      followUpPlan: ['本次记录中未明确提到复查安排。'],
      careNotes: ['本次记录中未明确提到注意事项。'],
      conversation: <ConversationSegment>[],
      terms: <MedicalTerm>[],
    );
  }

  final String summaryTitle;
  final List<String> doctorAdvice;
  final List<String> medicationItems;
  final List<String> examItems;
  final List<String> followUpPlan;
  final List<String> careNotes;
  final List<ConversationSegment> conversation;
  final List<MedicalTerm> terms;
  final String disclaimer;
}
```

Create `lib/features/terms/domain/medical_term.dart`:

```dart
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
```

- [ ] **Step 4: Run test**

Run:

```bash
flutter test test/features/analysis/domain/visit_analysis_test.dart
```

Expected: pass.

## Task 3: Local Term Library

**Files:**
- Modify: `pubspec.yaml`
- Create: `assets/data/medical_terms.zh.json`
- Create: `lib/features/terms/data/medical_term_repository.dart`
- Test: `test/features/terms/data/medical_term_repository_test.dart`

- [ ] **Step 1: Add asset to `pubspec.yaml`**

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/data/medical_terms.zh.json
```

- [ ] **Step 2: Create MVP term data**

Create `assets/data/medical_terms.zh.json`:

```json
[
  {
    "term": "心电图",
    "plainLanguageExplanation": "一种记录心脏电活动的检查，常用于观察心律和心肌供血线索。",
    "aliases": ["ECG"],
    "category": "检查"
  },
  {
    "term": "超声",
    "plainLanguageExplanation": "使用声波观察身体内部结构的检查，常见于腹部、心脏、血管等部位。",
    "aliases": ["B超", "彩超"],
    "category": "检查"
  },
  {
    "term": "复查",
    "plainLanguageExplanation": "按照医生建议在之后某个时间再次检查或回诊，用来观察恢复或变化。",
    "aliases": ["复诊"],
    "category": "就诊安排"
  }
]
```

- [ ] **Step 3: Write repository test**

Create `test/features/terms/data/medical_term_repository_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:voice_assistant/features/terms/data/medical_term_repository.dart';

void main() {
  test('matches known terms by term and alias', () async {
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

    expect(repository.matchTerms('医生建议做一个B超检查'), hasLength(1));
    expect(repository.matchTerms('医生建议做一个B超检查').single.term, '超声');
  });
}
```

- [ ] **Step 4: Implement repository**

Create `lib/features/terms/data/medical_term_repository.dart`:

```dart
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:voice_assistant/features/terms/domain/medical_term.dart';

class MedicalTermRepository {
  MedicalTermRepository(this._terms);

  factory MedicalTermRepository.fromJsonString(String source) {
    final decoded = jsonDecode(source) as List<dynamic>;
    return MedicalTermRepository(
      decoded.map((item) {
        final map = item as Map<String, dynamic>;
        return MedicalTerm(
          term: map['term'] as String,
          plainLanguageExplanation:
              map['plainLanguageExplanation'] as String,
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
    return _terms.where((term) {
      if (text.contains(term.term)) {
        return true;
      }
      return term.aliases.any(text.contains);
    }).toList(growable: false);
  }
}
```

- [ ] **Step 5: Run test**

Run:

```bash
flutter test test/features/terms/data/medical_term_repository_test.dart
```

Expected: pass.

## Task 4: MVP Analysis Services

**Files:**
- Create: `lib/features/analysis/domain/visit_analysis_service.dart`
- Create: `lib/features/analysis/data/mock_visit_analysis_service.dart`
- Create: `lib/features/analysis/data/rule_based_visit_analysis_service.dart`
- Test: `test/features/analysis/data/rule_based_visit_analysis_service_test.dart`

- [ ] **Step 1: Write analysis tests**

Create `test/features/analysis/data/rule_based_visit_analysis_service_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:voice_assistant/features/analysis/data/rule_based_visit_analysis_service.dart';
import 'package:voice_assistant/features/analysis/domain/conversation_segment.dart';

void main() {
  test('extracts conservative sections from conversation text', () async {
    final service = RuleBasedVisitAnalysisService();

    final analysis = await service.analyzeSegments(const [
      ConversationSegment(
        speakerId: SpeakerId.a,
        role: SpeakerRole.doctor,
        startTime: Duration.zero,
        endTime: Duration(seconds: 4),
        text: '建议先做心电图检查。',
      ),
      ConversationSegment(
        speakerId: SpeakerId.a,
        role: SpeakerRole.doctor,
        startTime: Duration(seconds: 5),
        endTime: Duration(seconds: 9),
        text: '这个药饭后吃，一天两次。',
      ),
      ConversationSegment(
        speakerId: SpeakerId.a,
        role: SpeakerRole.doctor,
        startTime: Duration(seconds: 10),
        endTime: Duration(seconds: 15),
        text: '一周后复查，注意休息。',
      ),
    ]);

    expect(analysis.examItems.single, contains('心电图'));
    expect(analysis.medicationItems.single, contains('饭后'));
    expect(analysis.followUpPlan.single, contains('复查'));
    expect(analysis.careNotes.single, contains('注意'));
  });
}
```

- [ ] **Step 2: Implement service interface**

Create `lib/features/analysis/domain/visit_analysis_service.dart`:

```dart
import 'package:voice_assistant/features/analysis/domain/conversation_segment.dart';
import 'package:voice_assistant/features/analysis/domain/visit_analysis.dart';

abstract interface class VisitAnalysisService {
  Future<VisitAnalysis> analyzeRecording(String audioFilePath);
  Future<VisitAnalysis> analyzeSegments(List<ConversationSegment> segments);
}
```

- [ ] **Step 3: Implement mock service**

Create `lib/features/analysis/data/mock_visit_analysis_service.dart`:

```dart
import 'package:voice_assistant/features/analysis/domain/conversation_segment.dart';
import 'package:voice_assistant/features/analysis/domain/visit_analysis.dart';
import 'package:voice_assistant/features/analysis/domain/visit_analysis_service.dart';
import 'package:voice_assistant/features/terms/domain/medical_term.dart';

class MockVisitAnalysisService implements VisitAnalysisService {
  @override
  Future<VisitAnalysis> analyzeRecording(String audioFilePath) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    return analyzeSegments(_mockSegments);
  }

  @override
  Future<VisitAnalysis> analyzeSegments(List<ConversationSegment> segments) async {
    return VisitAnalysis(
      summaryTitle: '就诊回顾',
      doctorAdvice: const ['医生建议先观察症状变化，并结合检查结果判断后续安排。'],
      medicationItems: const ['如需用药，请以医生现场说明和药品标签为准。'],
      examItems: const ['建议完成心电图检查。'],
      followUpPlan: const ['一周后根据结果复查。'],
      careNotes: const ['注意休息，若症状加重请及时就医。'],
      conversation: segments,
      terms: const [
        MedicalTerm(
          term: '心电图',
          plainLanguageExplanation: '一种记录心脏电活动的检查。',
          aliases: ['ECG'],
          category: '检查',
        ),
      ],
    );
  }

  static const _mockSegments = [
    ConversationSegment(
      speakerId: SpeakerId.a,
      role: SpeakerRole.doctor,
      startTime: Duration(seconds: 0),
      endTime: Duration(seconds: 4),
      text: '最近哪里不舒服？',
    ),
    ConversationSegment(
      speakerId: SpeakerId.b,
      role: SpeakerRole.patient,
      startTime: Duration(seconds: 5),
      endTime: Duration(seconds: 11),
      text: '胸口有点闷，走快了会更明显。',
    ),
    ConversationSegment(
      speakerId: SpeakerId.a,
      role: SpeakerRole.doctor,
      startTime: Duration(seconds: 12),
      endTime: Duration(seconds: 18),
      text: '建议先做心电图检查，一周后根据结果复查。',
    ),
  ];
}
```

- [ ] **Step 4: Implement rule-based service**

Create `lib/features/analysis/data/rule_based_visit_analysis_service.dart`:

```dart
import 'package:voice_assistant/features/analysis/domain/conversation_segment.dart';
import 'package:voice_assistant/features/analysis/domain/visit_analysis.dart';
import 'package:voice_assistant/features/analysis/domain/visit_analysis_service.dart';

class RuleBasedVisitAnalysisService implements VisitAnalysisService {
  @override
  Future<VisitAnalysis> analyzeRecording(String audioFilePath) async {
    return VisitAnalysis.empty();
  }

  @override
  Future<VisitAnalysis> analyzeSegments(List<ConversationSegment> segments) async {
    final texts = segments.map((segment) => segment.text).toList();
    return VisitAnalysis(
      summaryTitle: '就诊回顾',
      doctorAdvice: _findAny(texts, const ['建议', '需要', '可以']),
      medicationItems: _findAny(texts, const ['药', '片', '胶囊', '每日', '一天', '饭后', '饭前']),
      examItems: _findAny(texts, const ['检查', '化验', 'CT', '超声', '心电图', '抽血']),
      followUpPlan: _findAny(texts, const ['复查', '复诊', '下周', '一周', '一个月', '三个月']),
      careNotes: _findAny(texts, const ['注意', '少吃', '避免', '休息', '观察']),
      conversation: segments,
      terms: const [],
    );
  }

  List<String> _findAny(List<String> texts, List<String> keywords) {
    final matches = texts
        .where((text) => keywords.any(text.contains))
        .toList(growable: false);
    if (matches.isNotEmpty) {
      return matches;
    }
    return const ['本次记录中未明确提到。'];
  }
}
```

- [ ] **Step 5: Run tests**

Run:

```bash
flutter test test/features/analysis/data/rule_based_visit_analysis_service_test.dart
```

Expected: pass.

## Task 5: iOS Recording MethodChannel

**Files:**
- Modify: `ios/Runner/Info.plist`
- Modify: `ios/Runner/AppDelegate.swift`
- Create: `ios/Runner/AudioRecorderService.swift`
- Create: `lib/features/recording/domain/recording_session.dart`
- Create: `lib/features/recording/domain/recording_service.dart`
- Create: `lib/features/recording/data/ios_recording_service.dart`
- Test: `test/features/recording/data/ios_recording_service_test.dart`

- [ ] **Step 1: Add iOS permissions**

Add these keys to `ios/Runner/Info.plist`:

```xml
<key>NSMicrophoneUsageDescription</key>
<string>用于在就诊时记录医生建议和个人就诊信息，录音仅保存在本机。</string>
<key>UIBackgroundModes</key>
<array>
  <string>audio</string>
</array>
```

- [ ] **Step 2: Create Dart service contract**

Create `lib/features/recording/domain/recording_session.dart`:

```dart
enum RecordingStatus {
  idle,
  requestingPermission,
  recording,
  stopping,
  analyzing,
  completed,
  failed,
}

class RecordingSession {
  const RecordingSession({
    required this.id,
    required this.startedAt,
    this.endedAt,
    this.audioFilePath,
    this.status = RecordingStatus.idle,
    this.errorMessage,
  });

  final String id;
  final DateTime startedAt;
  final DateTime? endedAt;
  final String? audioFilePath;
  final RecordingStatus status;
  final String? errorMessage;

  Duration get duration {
    final end = endedAt ?? DateTime.now();
    return end.difference(startedAt);
  }
}
```

Create `lib/features/recording/domain/recording_service.dart`:

```dart
abstract interface class RecordingService {
  Future<bool> requestPermission();
  Future<String> startRecording();
  Future<String> stopRecording();
}
```

- [ ] **Step 3: Write MethodChannel adapter test**

Create `test/features/recording/data/ios_recording_service_test.dart`:

```dart
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voice_assistant/features/recording/data/ios_recording_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('voice_assistant/audio_recorder');

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('startRecording delegates to platform channel', () async {
    final calls = <String>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      calls.add(call.method);
      if (call.method == 'startRecording') {
        return '/tmp/visit.wav';
      }
      return null;
    });

    final service = IosRecordingService();
    final path = await service.startRecording();

    expect(path, '/tmp/visit.wav');
    expect(calls, ['startRecording']);
  });
}
```

- [ ] **Step 4: Implement Dart adapter**

Create `lib/features/recording/data/ios_recording_service.dart`:

```dart
import 'package:flutter/services.dart';
import 'package:voice_assistant/features/recording/domain/recording_service.dart';

class IosRecordingService implements RecordingService {
  static const _channel = MethodChannel('voice_assistant/audio_recorder');

  @override
  Future<bool> requestPermission() async {
    final result = await _channel.invokeMethod<bool>('requestPermission');
    return result ?? false;
  }

  @override
  Future<String> startRecording() async {
    final path = await _channel.invokeMethod<String>('startRecording');
    if (path == null || path.isEmpty) {
      throw StateError('Recording did not return a file path.');
    }
    return path;
  }

  @override
  Future<String> stopRecording() async {
    final path = await _channel.invokeMethod<String>('stopRecording');
    if (path == null || path.isEmpty) {
      throw StateError('Stop recording did not return a file path.');
    }
    return path;
  }
}
```

- [ ] **Step 5: Implement Swift recorder**

Create `ios/Runner/AudioRecorderService.swift`:

```swift
import AVFoundation
import Foundation

final class AudioRecorderService: NSObject {
  private var recorder: AVAudioRecorder?
  private var currentURL: URL?

  func requestPermission(completion: @escaping (Bool) -> Void) {
    AVAudioSession.sharedInstance().requestRecordPermission { granted in
      DispatchQueue.main.async {
        completion(granted)
      }
    }
  }

  func startRecording() throws -> String {
    let session = AVAudioSession.sharedInstance()
    try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
    try session.setActive(true)

    let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let fileName = "visit-\(Int(Date().timeIntervalSince1970)).wav"
    let url = documents.appendingPathComponent(fileName)

    let settings: [String: Any] = [
      AVFormatIDKey: kAudioFormatLinearPCM,
      AVSampleRateKey: 48000.0,
      AVNumberOfChannelsKey: 1,
      AVLinearPCMBitDepthKey: 16,
      AVLinearPCMIsFloatKey: false,
      AVLinearPCMIsBigEndianKey: false
    ]

    let recorder = try AVAudioRecorder(url: url, settings: settings)
    recorder.isMeteringEnabled = true
    recorder.record()

    self.recorder = recorder
    self.currentURL = url
    return url.path
  }

  func stopRecording() throws -> String {
    guard let recorder = recorder, let url = currentURL else {
      throw NSError(domain: "AudioRecorderService", code: 1, userInfo: [
        NSLocalizedDescriptionKey: "No active recording."
      ])
    }

    recorder.stop()
    self.recorder = nil
    self.currentURL = nil
    try AVAudioSession.sharedInstance().setActive(false)
    return url.path
  }
}
```

Modify `ios/Runner/AppDelegate.swift` to register the channel:

```swift
import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  private let audioRecorderService = AudioRecorderService()

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(
      name: "voice_assistant/audio_recorder",
      binaryMessenger: controller.binaryMessenger
    )

    channel.setMethodCallHandler { [weak self] call, result in
      guard let self else { return }
      switch call.method {
      case "requestPermission":
        self.audioRecorderService.requestPermission { granted in
          result(granted)
        }
      case "startRecording":
        do {
          result(try self.audioRecorderService.startRecording())
        } catch {
          result(FlutterError(code: "START_FAILED", message: error.localizedDescription, details: nil))
        }
      case "stopRecording":
        do {
          result(try self.audioRecorderService.stopRecording())
        } catch {
          result(FlutterError(code: "STOP_FAILED", message: error.localizedDescription, details: nil))
        }
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

- [ ] **Step 6: Run Dart adapter test**

Run:

```bash
flutter test test/features/recording/data/ios_recording_service_test.dart
```

Expected: pass.

## Task 6: Recording State Controller

**Files:**
- Create: `lib/features/recording/presentation/recording_controller.dart`
- Test: `test/features/recording/presentation/recording_controller_test.dart`

- [ ] **Step 1: Write controller test**

Create `test/features/recording/presentation/recording_controller_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:voice_assistant/features/recording/domain/recording_service.dart';
import 'package:voice_assistant/features/recording/domain/recording_session.dart';
import 'package:voice_assistant/features/recording/presentation/recording_controller.dart';

class FakeRecordingService implements RecordingService {
  bool permission = true;

  @override
  Future<bool> requestPermission() async => permission;

  @override
  Future<String> startRecording() async => '/tmp/visit.wav';

  @override
  Future<String> stopRecording() async => '/tmp/visit.wav';
}

void main() {
  test('start and stop recording update state', () async {
    final controller = RecordingController(FakeRecordingService());

    await controller.start();
    expect(controller.value.status, RecordingStatus.recording);

    await controller.stop();
    expect(controller.value.status, RecordingStatus.completed);
    expect(controller.value.audioFilePath, '/tmp/visit.wav');
  });
}
```

- [ ] **Step 2: Implement controller**

Create `lib/features/recording/presentation/recording_controller.dart`:

```dart
import 'package:flutter/foundation.dart';
import 'package:voice_assistant/features/recording/domain/recording_service.dart';
import 'package:voice_assistant/features/recording/domain/recording_session.dart';

class RecordingController extends ValueNotifier<RecordingSession> {
  RecordingController(this._recordingService)
      : super(
          RecordingSession(
            id: 'idle',
            startedAt: DateTime.now(),
          ),
        );

  final RecordingService _recordingService;

  Future<void> start() async {
    value = RecordingSession(
      id: 'pending',
      startedAt: DateTime.now(),
      status: RecordingStatus.requestingPermission,
    );

    final granted = await _recordingService.requestPermission();
    if (!granted) {
      value = RecordingSession(
        id: 'failed',
        startedAt: DateTime.now(),
        status: RecordingStatus.failed,
        errorMessage: '需要麦克风权限才能记录就诊内容。',
      );
      return;
    }

    final path = await _recordingService.startRecording();
    value = RecordingSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      startedAt: DateTime.now(),
      audioFilePath: path,
      status: RecordingStatus.recording,
    );
  }

  Future<void> stop() async {
    final current = value;
    value = RecordingSession(
      id: current.id,
      startedAt: current.startedAt,
      audioFilePath: current.audioFilePath,
      status: RecordingStatus.stopping,
    );
    final path = await _recordingService.stopRecording();
    value = RecordingSession(
      id: current.id,
      startedAt: current.startedAt,
      endedAt: DateTime.now(),
      audioFilePath: path,
      status: RecordingStatus.completed,
    );
  }
}
```

- [ ] **Step 3: Run controller test**

Run:

```bash
flutter test test/features/recording/presentation/recording_controller_test.dart
```

Expected: pass.

## Task 7: Flutter App Shell And Figma-Matched Screens

**Files:**
- Replace: `lib/main.dart`
- Create: `lib/app/visit_notes_app.dart`
- Create: `lib/features/recording/presentation/recording_screen.dart`
- Create: `lib/features/results/presentation/results_screen.dart`
- Create: `lib/features/results/presentation/summary_section.dart`
- Create: `lib/features/results/presentation/timeline_section.dart`
- Test: `test/widget_test.dart`

- [ ] **Step 1: Replace Flutter demo bootstrap**

Replace `lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:voice_assistant/app/visit_notes_app.dart';

void main() {
  runApp(const VisitNotesApp());
}
```

- [ ] **Step 2: Create app shell**

Create `lib/app/visit_notes_app.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:voice_assistant/app/figma_tokens.dart';
import 'package:voice_assistant/features/analysis/data/mock_visit_analysis_service.dart';
import 'package:voice_assistant/features/recording/data/ios_recording_service.dart';
import 'package:voice_assistant/features/recording/presentation/recording_screen.dart';

class VisitNotesApp extends StatelessWidget {
  const VisitNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '医嘱备忘',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: FigmaColors.action,
          surface: FigmaColors.background,
        ),
        scaffoldBackgroundColor: FigmaColors.background,
        useMaterial3: true,
      ),
      home: RecordingScreen(
        recordingService: IosRecordingService(),
        analysisService: MockVisitAnalysisService(),
      ),
    );
  }
}
```

- [ ] **Step 3: Implement UI from Figma**

Implement these screens from Figma context:

- `RecordingScreen`
- analysis/loading state inside `RecordingScreen` or a dedicated widget if the Figma design has a separate frame.
- `ResultsScreen`
- `SummarySection`
- `TimelineSection`

Implementation requirements:

- Use only `FigmaColors`, `FigmaSpacing`, and `FigmaRadius` for design constants.
- Match Figma text labels exactly.
- Do not add explanatory onboarding text unless present in Figma.
- Show the required disclaimer where the Figma design places it or in the closest visible compliance location.
- Use fixed dimensions or responsive constraints for major controls so labels and buttons do not shift during state changes.

- [ ] **Step 4: Write widget smoke test**

Replace `test/widget_test.dart` with:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:voice_assistant/app/visit_notes_app.dart';

void main() {
  testWidgets('app renders the recording entry screen', (tester) async {
    await tester.pumpWidget(const VisitNotesApp());

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('医嘱备忘'), findsWidgets);
  });
}
```

- [ ] **Step 5: Run widget test**

Run:

```bash
flutter test test/widget_test.dart
```

Expected: pass after Figma-matched text is wired.

## Task 8: Share Text Builder

**Files:**
- Create: `lib/features/share/share_text_builder.dart`
- Test: `test/features/share/share_text_builder_test.dart`

- [ ] **Step 1: Write test**

Create `test/features/share/share_text_builder_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:voice_assistant/features/analysis/domain/visit_analysis.dart';
import 'package:voice_assistant/features/share/share_text_builder.dart';

void main() {
  test('share text contains note content and disclaimer only', () {
    final text = ShareTextBuilder().build(VisitAnalysis.empty());

    expect(text, contains('就诊回顾'));
    expect(text, contains('本 App 仅供个人记录'));
    expect(text, isNot(contains('.wav')));
    expect(text, isNot(contains('/tmp/')));
  });
}
```

- [ ] **Step 2: Implement builder**

Create `lib/features/share/share_text_builder.dart`:

```dart
import 'package:voice_assistant/features/analysis/domain/visit_analysis.dart';

class ShareTextBuilder {
  String build(VisitAnalysis analysis) {
    return [
      analysis.summaryTitle,
      '',
      '医生建议记录',
      ...analysis.doctorAdvice.map((item) => '- $item'),
      '',
      '用药信息',
      ...analysis.medicationItems.map((item) => '- $item'),
      '',
      '检查项目',
      ...analysis.examItems.map((item) => '- $item'),
      '',
      '复查安排',
      ...analysis.followUpPlan.map((item) => '- $item'),
      '',
      '注意事项',
      ...analysis.careNotes.map((item) => '- $item'),
      '',
      analysis.disclaimer,
    ].join('\n');
  }
}
```

- [ ] **Step 3: Wire share action**

Use the share mechanism chosen by the project:

- Prefer Flutter `share_plus` if dependency addition is acceptable.
- Otherwise expose a native iOS share MethodChannel.

Share only the string from `ShareTextBuilder`.

- [ ] **Step 4: Run test**

Run:

```bash
flutter test test/features/share/share_text_builder_test.dart
```

Expected: pass.

## Task 9: Integration Verification

**Files:**
- Modify as needed based on failures.
- Create: `docs/qa/mvp-verification.md`

- [ ] **Step 1: Run static analysis**

Run:

```bash
flutter analyze
```

Expected: no errors.

- [ ] **Step 2: Run all Flutter tests**

Run:

```bash
flutter test
```

Expected: all tests pass.

- [ ] **Step 3: Run iOS simulator build**

Run:

```bash
flutter build ios --simulator --debug --no-codesign
```

Expected: build succeeds.

- [ ] **Step 4: Run on real iPhone**

Run:

```bash
flutter devices
flutter run -d <device-id>
```

Manual checks:

- Microphone permission prompt appears.
- Denying permission shows a clear Figma-matched error state.
- Recording starts.
- Lock screen or background transition does not immediately stop recording.
- Stop returns a local `.wav` path.
- Analysis state appears.
- Result screen appears.
- Share sheet shares only text.

- [ ] **Step 5: Write verification notes**

Create `docs/qa/mvp-verification.md`:

```markdown
# MVP Verification

## Automated Checks

| Check | Date | Result | Notes |
| --- | --- | --- | --- |
| flutter analyze | | | |
| flutter test | | | |
| iOS simulator build | | | |

## Real Device Checks

| Device | iOS Version | Date | Result | Notes |
| --- | --- | --- | --- | --- |

## Figma Visual Parity

| Screen | Viewport | Result | Notes |
| --- | --- | --- | --- |

## Known Issues

- None recorded.
```

## Task 10: MVP Completion Review

**Files:**
- Modify: `README.md`

- [ ] **Step 1: Update README**

Replace the generated Flutter README with:

```markdown
# 医嘱备忘

本项目是一个 Flutter iOS MVP，用于本地记录就诊对话并生成个人就诊回顾。MVP 不接入大模型，不上传录音、转写或总结内容。

## MVP 功能

- 一键本地录音
- iOS 麦克风权限处理
- 本地结构化就诊回顾
- 双人对话时间线展示
- 医学术语通俗解释
- 纯文本分享

## 隐私说明

所有 MVP 数据处理均在设备本地完成。分享功能只分享结构化文本，不分享原始录音。

## 免责声明

本 App 仅供个人记录就诊信息参考，不提供任何医疗诊断或治疗建议。所有内容以医生口头医嘱为准。

## 开发验证

```bash
flutter analyze
flutter test
flutter build ios --simulator --debug --no-codesign
```
```

- [ ] **Step 2: Final review checklist**

Confirm:

- No LLM dependency exists.
- No network upload path exists.
- UI token values came from Figma.
- Recording channel is registered.
- Share text has no audio path.
- Disclaimer appears in app and shared text.
- Automated tests and iOS build are recorded in `docs/qa/mvp-verification.md`.

## Future Post-MVP Work

Do not include these in MVP unless the user explicitly expands scope:

- FluidAudio speaker diarization spike.
- Apple Speech local transcription spike.
- Real two-speaker role inference.
- Local small model summarization.
- History list and record management.
- iCloud sync.
- Android implementation.
