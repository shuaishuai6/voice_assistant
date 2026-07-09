# Figma MVP Audit

## Source

- Figma URL: https://www.figma.com/design/7bUyqy99lLPciIyMhakxlW/%E5%8C%BB%E5%98%B1%E5%A4%87%E5%BF%98?m=auto&t=j9fOzromOIdEIvRV-6
- Retrieved date: 2026-07-09
- MCP status: Figma MCP tools are not available in this session.
- Current implementation source: exported assets under `assets/images/` plus product requirements.

## Current Constraint

The available exported assets include icon states only, not full-page screenshots or structured Figma frame data. UI implementation will use these assets and the visible brand direction from them, but exact Figma parity still requires frame screenshots or MCP design context before final visual sign-off.

## Tokens

### Colors

| Token | Value | Used For |
| --- | --- | --- |
| Background | `#F8FBF8` | App background |
| Surface | `#FFFFFF` | Cards and panels |
| Text primary | `#123128` | Main text |
| Text secondary | `#6B7D75` | Supporting text |
| Brand green | `#00513E` | Primary actions and doctor timeline |
| Muted green | `#6F8078` | Inactive icon state |
| Patient green | `#4BA06D` | Patient timeline |
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
| Card radius | 8 | Repeated content cards |
| Button radius | 28 | Large recording action |

## Required Screens

| Screen | Figma Frame | Implementation File |
| --- | --- | --- |
| Recording idle | Pending exact frame context | `lib/features/recording/presentation/recording_screen.dart` |
| Recording active | Pending exact frame context | `lib/features/recording/presentation/recording_screen.dart` |
| Analysis loading | Pending exact frame context | `lib/features/recording/presentation/recording_screen.dart` |
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
