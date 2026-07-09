# Figma MVP Audit

## Source

- Figma URL: https://www.figma.com/design/7bUyqy99lLPciIyMhakxlW/%E5%8C%BB%E5%98%B1%E5%A4%87%E5%BF%98?node-id=1-359&t=JVhNJSbKYHkEMAmP-4
- Retrieved date: 2026-07-09
- MCP status: Figma MCP `get_design_context` and `get_screenshot` succeeded for node `1:359`.
- Current implementation source: Figma node `1:359` plus exported PNG assets under `assets/images/`.

## Current Constraint

The Figma MCP asset URLs for several icons returned SVG payloads. The app currently avoids adding an SVG rendering dependency, so the implementation reuses existing PNG assets for the microphone and record icons, and uses Flutter built-in icons for the simple camera/upload/nav glyphs. Layout, visible text, colors, spacing, card sizing, and the main recording button structure follow node `1:359`.

## Tokens

### Colors

| Token | Value | Used For |
| --- | --- | --- |
| Background | `#FCF9F8` | App background and bottom navigation |
| Surface | `#FFFFFF` | Cards and panels |
| Text primary | `#1C1B1B` | Main text |
| Text secondary | `#3D4A42` | Supporting text |
| Brand green | `#006C4B` | Header title, main button gradient start, status dot |
| Accent green | `#00A676` | Main button gradient end, active nav background |
| Soft green | `rgba(0,166,118,0.10)` | Daily processed badge |
| Record red | `#D83B32` | Active stop/record emphasis |

### Typography

| Style | Font | Size | Weight | Line Height | Used For |
| --- | --- | --- | --- | --- | --- |
| Title | System | 28 | 700 | 34 | App title and result title |
| Section | System | 18 | 700 | 24 | Section headings |
| Body | System | 15 | 400 | 22 | Note text |
| Caption | System | 12 | 500 | 16 | Metadata and disclaimers |

### Spacing And Radius

| Token | Value | Used For |
| --- | --- | --- |
| `xs` | 4 | Tight icon/text gaps |
| `sm` | 8 | Compact spacing |
| `md` | 16 | Standard content padding |
| `lg` | 24 | Page spacing |
| `xl` | 32 | Screen section spacing |
| Card radius | 16 | Secondary action cards |
| Main button size | 224 | Recording action |
| Bottom nav height | 78 | Fixed bottom navigation |

## Required Screens

| Screen | Figma Frame | Implementation File |
| --- | --- | --- |
| Recording idle | `1:359` 首页 - 录音 (视觉重构版) | `lib/features/recording/presentation/recording_screen.dart` |
| Recording active | Pending exact frame context | `lib/features/recording/presentation/recording_screen.dart` |
| Analysis loading | Pending exact frame context | `lib/features/recording/presentation/recording_screen.dart` |
| Records list | `1:255` 医疗档案 - 列表 | `lib/features/records/presentation/records_screen.dart` |
| Record detail | `1:122` 诊疗对话 - 时间线 | `lib/features/records/presentation/record_detail_screen.dart` |
| Results | Pending exact frame context | `lib/features/results/presentation/results_screen.dart` |

## Asset Inventory

| Asset | Source | Local Path | Notes |
| --- | --- | --- | --- |
| White medical kit icon | User-exported Figma asset | `assets/images/node-id=1-133.png` | Used on primary action surfaces |
| White microphone icon | User-exported Figma asset | `assets/images/node-id=1-396.png` | Used on main recording button |
| Green microphone icon | User-exported Figma asset | `assets/images/node-id=2-826-1.png` | Used for active/available mic state |
| Muted microphone icon | User-exported Figma asset | `assets/images/node-id=2-826-2.png` | Used for inactive/secondary mic state |
| Green medical kit icon | User-exported Figma asset | `assets/images/node-id=2-832-1.png` | Used for visit note/result state |
| Muted medical kit icon | User-exported Figma asset | `assets/images/node-id=2-832-2.png` | Used for inactive/secondary note state |
