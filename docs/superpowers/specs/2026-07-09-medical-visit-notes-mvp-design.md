# Medical Visit Notes MVP Design

> This spec defines the first usable local-only MVP for the Flutter iOS app currently named `voice_assistant`.

## Goal

Build an iOS-first Flutter MVP for recording an outpatient doctor-patient conversation, processing it locally, and presenting a structured visit note that follows the provided Figma UI exactly for layout, color, typography, and feature surface.

## Confirmed MVP Scope

The MVP includes:

- One-tap recording entry point.
- iOS microphone permission flow.
- Background-capable local recording.
- WAV recording target: PCM 16-bit, 48 kHz, mono.
- Recording timer and UI feedback defined by the Figma design.
- Local analysis pipeline interface.
- MVP analysis implementation that can run without a large language model.
- Two-speaker timeline data model.
- Structured visit note sections shown by the UI.
- Local medical term explanation list.
- iOS system share sheet for sharing text only.
- Local-only privacy posture and medical disclaimer.

The MVP excludes:

- Cloud upload of audio, transcript, notes, analytics, or medical content.
- Any LLM integration, local or remote.
- Production-grade medical natural language understanding.
- iCloud sync.
- Android implementation.
- Full historical record management unless the Figma MVP UI explicitly requires it.

## UI Source Of Truth

The Figma design is the visual and functional source of truth:

https://www.figma.com/design/7bUyqy99lLPciIyMhakxlW/%E5%8C%BB%E5%98%B1%E5%A4%87%E5%BF%98?m=auto&t=j9fOzromOIdEIvRV-6

Before UI implementation starts, the implementer must fetch:

- Figma design context for the exact MVP frames.
- Figma screenshot references for those frames.
- Any image or SVG assets exposed by the Figma MCP server.

If Figma MCP access is unavailable, UI implementation must pause and ask for exported screenshots, color tokens, frame names, or node-specific links. No custom palette should be invented. Colors, spacing, corner radii, typography, button states, and icons must follow the Figma design.

## Product Language And Compliance Posture

The app must present itself as a personal visit record tool, not a diagnostic or prescribing product.

Preferred language:

- 医嘱备忘
- 就诊回顾
- 个人记录
- 医生建议记录
- 记录摘要

Avoid using these as primary feature labels:

- 诊断
- 治疗
- 处方
- AI 诊断

Required disclaimer:

> 本 App 仅供个人记录就诊信息参考，不提供任何医疗诊断或治疗建议。所有内容以医生口头医嘱为准。

The disclaimer must appear in a visible place in the app. It should also be included at the end of shared text.

## User Flow

1. User opens the app.
2. User sees the Figma-defined recording home screen.
3. User taps the main recording button.
4. App requests microphone permission if needed.
5. App records locally and shows recording state, timer, and Figma-defined visual feedback.
6. User taps stop.
7. App shows the Figma-defined analysis/loading state.
8. App runs the MVP local analysis pipeline.
9. App shows the Figma-defined result page.
10. User reviews structured note, speaker timeline, term explanations, and share action.

## Architecture

The MVP uses Flutter for UI and state orchestration, with a small iOS-native layer for audio recording and platform actions.

```
Flutter UI
  |
  | MethodChannel
  v
iOS Native Swift Services
  - AudioRecorderService
  - ShareService adapter if Flutter plugin is not used
  |
  v
Local files in app sandbox

Dart Domain Layer
  - RecordingSession
  - VisitAnalysis
  - ConversationSegment
  - MedicalTerm

Dart Analysis Layer
  - VisitAnalysisService interface
  - MockVisitAnalysisService for MVP UI/dev
  - RuleBasedVisitAnalysisService when transcript/timeline input exists
```

The analysis interface must be designed so FluidAudio, Apple Speech, or a later local model can replace the MVP implementation without rewriting UI screens.

## Data Models

### Recording Session

Fields:

- `id`
- `startedAt`
- `endedAt`
- `duration`
- `audioFilePath`
- `status`
- `meteringSamples`

Statuses:

- `idle`
- `requestingPermission`
- `recording`
- `stopping`
- `analyzing`
- `completed`
- `failed`

### Conversation Segment

Fields:

- `speakerId`: `A` or `B`
- `role`: `doctor`, `patient`, or `unknown`
- `startTime`
- `endTime`
- `text`

### Visit Analysis

Fields:

- `summaryTitle`
- `doctorAdvice`
- `medicationItems`
- `examItems`
- `followUpPlan`
- `careNotes`
- `conversation`
- `terms`
- `disclaimer`

Sections that are not mentioned in the source text must say that the recording did not clearly mention them. The MVP must not invent medical facts.

### Medical Term

Fields:

- `term`
- `plainLanguageExplanation`
- `aliases`
- `category`

## MVP Analysis Strategy

The first MVP does not use an LLM.

Implementation order:

1. Use a mock local analysis service to make the full UI testable immediately.
2. Add a rule-based service that accepts transcript-like text or seeded segments.
3. Keep interfaces ready for later replacement with FluidAudio speaker diarization and Apple Speech transcription.

The rule-based service should extract only conservative signals:

- Medication expressions containing words such as `药`, `片`, `胶囊`, `每日`, `一天`, `饭后`, `饭前`.
- Exam expressions containing words such as `检查`, `化验`, `CT`, `超声`, `心电图`, `抽血`.
- Follow-up expressions containing words such as `复查`, `复诊`, `下周`, `一个月`, `三个月`.
- Care note expressions containing words such as `注意`, `少吃`, `避免`, `休息`, `观察`.

When no clear item is detected, the section should display a neutral empty state.

## iOS Recording Requirements

The native recorder must target:

- Format: WAV container.
- Encoding: Linear PCM.
- Sample rate: 48,000 Hz.
- Bit depth: 16-bit.
- Channels: 1.
- Storage: app sandbox.

The iOS project must include:

- `NSMicrophoneUsageDescription`
- Background audio mode, if background recording is implemented in the MVP build.

The recording service should expose:

- `requestPermission`
- `startRecording`
- `stopRecording`
- `getRecordingState`
- metering events or polling support

## Flutter State And Navigation

Use a small explicit state layer rather than hiding recording logic in widgets.

Recommended structure:

- `lib/main.dart`: app bootstrap.
- `lib/app/visit_notes_app.dart`: app shell and theme wiring from Figma tokens.
- `lib/features/recording/`: recording screen, state controller, recording service interface.
- `lib/features/analysis/`: analysis service interface and MVP implementations.
- `lib/features/results/`: result page widgets.
- `lib/features/terms/`: term model and local repository.
- `lib/platform/`: MethodChannel adapters.
- `assets/data/medical_terms.zh.json`: local term library.

## Testing Strategy

MVP tests should cover:

- Recording state transitions.
- MethodChannel adapter command mapping.
- Analysis section extraction for medication, exams, follow-up, and care notes.
- Share text generation includes no audio file path and includes the disclaimer.
- Result page renders all sections from mock data.
- Medical term matching finds known terms and ignores unknown words.

Manual verification should cover:

- Real iPhone recording start/stop.
- Permission denial behavior.
- Background recording behavior.
- Figma visual parity on common iPhone viewport sizes.
- Share sheet content.

## Key Risks

### Figma Access

Risk: Figma MCP is unavailable or the shared link does not point to exact frames.

Response: pause UI implementation and request exact frame links or exported screenshots plus tokens.

### Background Recording

Risk: iOS background behavior can differ across devices and app lifecycle states.

Response: implement native lifecycle logging and test on a real iPhone before claiming support.

### Analysis Expectations

Risk: users may expect clinically accurate summaries.

Response: MVP uses conservative extraction, neutral empty states, and visible disclaimer. It must not invent information.

### Later Speaker Diarization

Risk: FluidAudio integration and performance claims need current package and device validation.

Response: keep interfaces replaceable and defer production diarization to the next technical spike after the MVP UI/recording loop works.

## Acceptance Criteria

The MVP is accepted when:

- The app runs on iOS 16+ simulator for UI flows.
- A real iPhone can record and stop audio locally.
- Recorded files are stored in the app sandbox.
- The recording and result flows match the Figma UI frames.
- The result page displays structured note sections, timeline, terms, and share action.
- Shared text contains only the structured note and disclaimer.
- No code path uploads audio, transcript, or note content.
- The analysis implementation uses no LLM.
