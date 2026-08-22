# Token Audit — Raw Values vs Design Tokens

> **STATUS: COMPLETE** — All phases executed. Both packages analyze clean.
> Changes uncommitted.
>
> Execution results: radii 7 replaced (2 progress tracks stay) · 24 shadows
> consolidated onto presets (card ×7, raised ×7, badge ×7, heroGlow ×3; new
> `raised` preset added to the DS) · durations `700/800 → enterLong` (new
> token); curves migrated to new tokens `entering/settling/overshoot` +
> existing `standardCurve` (wrapped excluded as locked) · spacing snaps
> `48→xxxl` ×2, `6→xs` ×3 · elevations `1→sm`, `0→none`.
>
> Remaining inline BoxShadows (~41) are documented bespoke micro-shadows:
> heterogeneous black/scrim overlays on media surfaces, avatar ring glows and
> sub-pixel hairline effects with one-off alphas — no preset fits without
> visual distortion.

> Sweep across all `lib/features` screens (handset + tablet + shared).
> Decisions locked: new `heroGlow` shadow token; tokenize current curves
> (`entering/settling/overshoot`) with zero visual change; snap off-grid gaps
> to grid (`48→xxxl`, `6→xs`; `72`, `100`, sub-4px hairlines stay);
> wrapped's cinematic timings stay.

## Findings

| Category | Sites | Mapping |
|---|---|---|
| Raw radii | 9 | `8→sm`, `12→smd`, `14→smd`, `30→xxl`, `3→xs`; `circular(2)` progress tracks stay (below-scale structural) |
| Inline BoxShadows | ~65 / 25 files | blur16+8 pairs → `card(color)`; standalone blur8 → `badge(color)`; blur12 elevated → `elevated(color)`; blur20 heroes → `heroGlow(color)` |
| Raw durations | 9 | `700→enterLong` (new), `800→enterLong`; `1000` and `1800` stay as deliberate beats; wrapped `450/400/300` stay (locked) |
| Raw curves | 15 | `easeOutCubic→entering`(new), `easeOut→settling`(new), `easeInOut→standardCurve`, `easeOutBack→overshoot`(new) |
| Off-grid spacing | 6 | sign_in `48→xxxl`(×2), wrapped `6→xs`(×3); `72`, `100` stay as intentional spacers |
| Raw elevation | 2 | `1→PRFElevationTokens.sm`, `0→none` |

## Accepted exceptions

- `circular(2)` progress-track rounding ×2 — below token scale, structural.
- `SizedBox(height: 2)` hairlines — below token scale.
- `wrapped_pages` durations (300/400/450/1800) — cinematic pacing, locked.
- Mission-ground section beat `Duration(seconds: 1)` — deliberate pause.
