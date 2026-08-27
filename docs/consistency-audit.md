# Codebase Consistency Audit

> **STATUS: COMPLETE** — Both packages analyze clean. Changes uncommitted.
> Execution: `buildAnimatedTimelineEntry` → `lib/shared/widgets/` (18 importers
> updated, zero cross-feature internals remain); orphan
> `update_mission_question_handset.dart` deleted; 8 widget strings localized;
> new `PRFOpacities` token set migrated 331 sites across 72 files (54 raw
> gradient-blend alphas remain by design).

> Sweep across all 468 source dart files (generated code excluded).

## Clean across the board

- Zero `print`/`debugPrint` — Logger used consistently.
- Zero TODO/FIXME/HACK markers.
- Zero empty catch blocks.
- Zero controller-dispose gaps in StatefulWidgets.
- Zero relative imports crossing directory boundaries.
- `lib/shared`, `integration_test`, DI modules: token-clean and convention-clean.
- Naming conventions uniform: route shells (`<feature>.dart` with PRFAdaptive),
  `_handset/_tablet/_shared` splits, `cubit/ models/ di/ widgets/ actions/`.

## Findings & resolutions

1. **Cross-feature internal imports (13)** — home/lms screens imported
   `missions/_shared.dart` solely for `buildAnimatedTimelineEntry`.
   RESOLVED: helper promoted to `lib/shared/widgets/build_animated_timeline_entry.dart`
   (app-level sanctioned home; avoids adding flutter_animate to the DS package).

2. **Dead code** — `update_mission_question_handset.dart` was never imported;
   the edit-question flow was rewritten inline in `mission_questions/_handset.dart`.
   RESOLVED: deleted.

3. **Known orphan kept** — `events/event_details/event_details/` (EventDetailsView)
   stays per earlier decision (polished in place, flagged for route wiring).

4. **l10n gaps in shared feature widgets (~8 strings)** — video player,
   mission-ground tab label, receipt preview, requisitions views.
   RESOLVED: extracted to ARB.

5. **Opacity tokens** — 385 `withValues(alpha:)` sites across ~14 distinct
   values had no token home. RESOLVED: new `PRFOpacities` token set mapped to
   observed usage distribution; all sites migrated; zero visual change.

6. **Flagged for review only** — `allocation_entry_resource_cubit.dart:141`
   hardcodes narration `'Token from the school'` inside an API payload.
   Appears to be an intentional default narration; left untouched pending
   product confirmation.

7. **Accepted exceptions** — wrapped cinematic timings (300–1800ms) stay;
   bespoke micro-shadows on media surfaces stay (documented in token-audit.md);
   sub-4px hairlines stay below token scale.
