# PRF Missions — Handset Final Polish Plan

> **STATUS: COMPLETE** — All phases executed. Both packages analyze clean.
> Changes are uncommitted. Static detail screens (event details, nested event
> view) intentionally keep their one-shot entrance staggers: they are arg-fed
> and have no rebuild loops that would replay them.
>
> Flagged for separate follow-up:
> - `events/event_details/event_details/` remains unrouted (polished in place).
> - Event gallery route wiring.
> - Mission status enum i18n.

> Companion to `tablet-upgrade-plan.md` (completed). Scope: all 51 `_handset.dart`
> files. Tiered depth: deep review for ~22 route-level screens, consistency sweep
> for ~29 embedded forms/sheets. Includes visual refinement.
>
> Decisions locked: orphan `events/event_details/event_details/` is polished in
> place (kept correct if ever wired). No commits.

## Audit findings

1. **Controller leaks** — 7 StatefulWidgets never dispose: add_event_subscription,
   update_event_subscription, debrief_note_form, soul_form (x3), session_form (x3),
   add_mission_question, update_mission_question.
2. **Refresh flash** — full-list spinner replaces visible items on pull-to-refresh:
   lms root, course/module/lesson details, giving, faqs, mission_ground_suggestions,
   prayer_requests, events. Fix with the `currentItems` pattern used on tablets.
3. **~45 hardcoded English strings** — expenses (10+), answer_faqs (8), six form
   sheets' validation messages (`'X is required'` / `'Please fix the highlighted
   fields...'`), debrief tooltips + confirmations, gallery audio copy,
   school_missions empty copy, nested event view venue fallback.
4. **Un-gated entrance animations** on nearly every Tier-A screen; landing is the
   only correctly gated screen. Add once-per-instance gating +
   `MediaQuery.disableAnimationsOf` respect.
5. **`pleaseWait` misuse** in ~12 empty states.
6. **Raw error text** in announcements handset (`Center(child: Text(message))`).
7. **Orphan surface**: `events/event_details/event_details/` (711-line handset +
   wrapper) unrouted — polish in place per decision.

## Phases

- H0: this document.
- H1: bugs first — disposals, announcements error view, refresh-flash sweep,
  pleaseWait copy fixes.
- H2: l10n sweep (~45 ARB keys; parameterized `fieldRequired(field)` +
  `fixHighlightedFields` for the shared validation pattern).
- H3: entrance-animation gating across Tier-A screens (reuse
  `buildAnimatedTimelineEntry` where timelines exist).
- H4: visual refinement (Tier A deep / B light): spacing rhythm, hierarchy,
  touch targets >=44px, tokenize stray insets.
- H5: verify analyze clean in both packages; format changed files; final summary.

## Out of scope

- Router wiring for the orphaned EventDetailsView and event gallery (flagged).
- Mission status enum i18n (cross-cutting, flagged in tablet plan).
