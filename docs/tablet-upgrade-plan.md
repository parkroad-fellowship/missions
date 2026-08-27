# PRF Missions — Tablet Upgrade Plan

> **STATUS: COMPLETE** — All phases executed. Both packages analyze clean.
> Changes are uncommitted by request. Tablet layout language documented in DESIGN.md §6.
>
> Flagged for separate follow-up:
> - Event gallery route appears unwired/unrouted (no router references found).
> - Auth sign-in debug credentials (`_shared.dart` kDebugMode block) — release hygiene review.
> - Mission status enum names render English-only (`status.name`) — future i18n sweep across handsets too.

**Baseline implementations:** `lib/features/home/landing/_tablet.dart` + `lib/features/missions/_tablet.dart`
**Scope:** All 22 `_tablet.dart` screens · **Design system:** editable (`../../prf_design_system`)

**Locked decisions**

- All light `surfaceContainerHighest` sidebars unify on the navy Living Root brand panel.
- `home/wrapped` stays a letterboxed cinematic stage (cosmetic token cleanup only).
- Event gallery gets polish only; its orphan-route status is flagged separately.
- This plan lives in `docs/tablet-upgrade-plan.md`.

## Findings summary

| Tier | Files | State |
|---|---|---|
| Baselines | landing, missions | Gold standard reference |
| Compliant | auth/sign_in, event gallery (on merits) | Minor string/polish gaps |
| Special case | wrapped | Deliberate 9:16 letterbox |
| Partial | 17 screens | Systemic deviations below |

### Systemic issues

1. Navy Living Root panel exists in only 3 screens; ~14 hand-roll light sidebars.
2. ~45 hardcoded English strings, concentrated in right panels.
3. Non-scrollable spacer-based panels overflow at short heights / large text scale.
4. Grids measure the window instead of the pane; fixed aspect ratios risk clipping at 800–1280px.
5. State-machine holes: announcements (no back button, raw error text), answer_faqs (no error branch), lesson_details (rail collapses mid-load), student_enquiries (blank initial state).
6. Bugs: enquiry_replies leaks controllers + socket channel; prayer_requests Total==ActiveNow; account sign-out listener navigates on every emission; stat pills white-on-white on light panels; giving hardcodes 'Complete' though l10n.complete exists.

## Phase 0 — Design-system foundations (`prf_design_system`)

New shared widgets exported from the package:

| Widget | Replaces |
|---|---|
| `PRFTabletSplitScaffold` | Scaffold > SafeArea > Center > ConstrainedBox(1100) > Row[flex 3 \| VerticalDivider(outline @0.12) \| flex 2] boilerplate x17 |
| `PRFTabletHeaderRow` | back IconButton + Expanded(title) + inline spinner slot pattern |
| `PRFBrandPanel` | navy DecoratedBox(lg radius) + ClipRRect + Stack[ExcludeSemantics(PRFRootMotifPainter)] + scrollable body + uppercase section-label API |

Bonus: stat pills are styled for dark surfaces — moving them onto navy panels fixes their white-on-white illegibility.

Verify: `flutter analyze` in both packages.

## Phase 1 — Behavioral bugs first (no restyle)

- enquiry_replies: dispose `_enquiryReplyController` / `_scrollController`; tear down socket channel; scroll-to-bottom only on message-count change.
- prayer_requests: real ActiveNow source (Total and ActiveNow currently identical).
- student_enquiries: fix `pleaseWait` misused as filtered-empty copy; blank initial state.
- announcements: fix `pleaseWaitForOS` misuse; raw `Text(message)` error; double loading indication.
- account: sign-out listener navigates on every emission via orElse.
- lms course/module details: await refresh chains.
- events: refresh flash during pull-to-refresh; adopt missions' `currentItems` pattern.
- answer_faqs: silent error branch; empty state unreachable by refresh.

## Phase 2 — Missions family (4 screens)

`mission_details` · `school_missions` · `mission_ground_suggestions` · `answer_faqs`

- Adopt Phase 0 components; navy panels; ~27 ARB keys (tab labels Overview/Feedback Data/Finance, humanized status, school past missions copy, ground suggestions copy, FAQ hub copy).
- Scrollable panel bodies; pane-aware grids; entrance gating.
- mission_details: loading/error scaffolds gain back-nav + retry; keep contextual FAB-in-rail UX.

## Phase 3 — Home family (7 screens)

`faqs` · `announcements` · `giving` · `account` · `student_enquiries` · `prayer_requests` · `wrapped` (cosmetic only)

- Adopt Phase 0 components; ~18 ARB keys.
- announcements: header row restores missing back button; proper error view.
- giving: use existing `l10n.complete`; add Pending key; pane-measured grid.
- account: Expanded title; entrance-animation gating; scrollable navy panel.
- student_enquiries / prayer_requests: pane-aware grids; scrollable panels; entrance gating.
- wrapped: tokenize Colors.black; extract constants.

## Phase 4 — Events + LMS family (8 screens)

`events` · `event_details` · `gallery` · `lms` · `course_details` · `module_details` · `lesson_details`

- Same component adoption; ~15 ARB keys.
- events: scrollable navy right panel (Spacer overflow risk).
- lesson_details: keep back-nav visible during loads; empty -> PRFEmptyView not spinner; no-resources fallback.
- gallery: audio strings to ARB; error column -> PRFEmptyView. FLAG: appears unwired/unrouted.
- event_details: Expanded title; optional refresh pass.

## Phase 5 — Polish & verify

1. ARB extraction complete (~60 keys) -> regenerate l10n.
2. `flutter analyze` clean in both `app` and `prf_design_system`.
3. Screenshot sweep: 600 / 800 / 1024 / 1280 widths x both orientations, light + dark.
4. Update DESIGN.md with a "Tablet layout language" section documenting the split-scaffold + brand-panel system.

## Out of scope (flagged for separate decision)

- Gallery orphan route wiring.
- Auth debug-credential release hygiene (`_shared.dart` kDebugMode block).
