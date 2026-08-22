---
name: PRF Missions
description: Purpose-built design system for Parkroad Fellowship's community mobile app
colors:
  primary: "#1A2253"
  primary-light: "#D7E0FF"
  primary-container: "#EDF1FF"
  primary-dark: "#111636"
  secondary: "#9DE35D"
  secondary-light: "#EAFCD2"
  secondary-container: "#F6FEEB"
  secondary-dark: "#67973B"
  neutral-50: "#F7F9FC"
  neutral-100: "#F0F3F8"
  neutral-200: "#E6EAF2"
  neutral-300: "#D6DDE9"
  neutral-400: "#B5C0D3"
  neutral-500: "#8F9BB3"
  neutral-600: "#6B758D"
  neutral-700: "#4B5368"
  neutral-800: "#2F3547"
  neutral-900: "#171C29"
  success: "#0FA678"
  success-light: "#E8FBF4"
  warning: "#F59E0B"
  warning-light: "#FFF4E4"
  error: "#D14343"
  error-light: "#FFFE9EA"
  info: "#2E7AF8"
  info-light: "#EAF1FF"
  purple: "#6E4CEB"
  blue: "#296DFF"
  orange: "#EB8B2D"
  emerald: "#12B886"
typography:
  display:
    fontFamily: "Manrope, sans-serif"
    fontSize: "38px"
    fontWeight: 800
    lineHeight: 1.1
    letterSpacing: "-0.9px"
  headline:
    fontFamily: "Manrope, sans-serif"
    fontSize: "24px"
    fontWeight: 700
    lineHeight: 1.25
  title:
    fontFamily: "Manrope, sans-serif"
    fontSize: "17px"
    fontWeight: 700
    lineHeight: 1.35
  body:
    fontFamily: "Manrope, sans-serif"
    fontSize: "15px"
    fontWeight: 500
    lineHeight: 1.5
  label:
    fontFamily: "Manrope, sans-serif"
    fontSize: "14px"
    fontWeight: 700
    lineHeight: 1.35
rounded:
  xs: "6px"
  sm: "10px"
  md: "16px"
  lg: "20px"
  xl: "24px"
  full: "999px"
spacing:
  xs: "6px"
  sm: "10px"
  md: "14px"
  lg: "18px"
  xl: "24px"
  xxl: "30px"
  xxxl: "40px"
components:
  button-primary:
    backgroundColor: "{colors.primary}"
    textColor: "#FFFFFF"
    rounded: "{rounded.md}"
    padding: "14px 20px"
    height: "52px"
  button-primary-dark:
    backgroundColor: "{colors.secondary}"
    textColor: "{colors.primary-900}"
    rounded: "{rounded.md}"
    padding: "14px 20px"
    height: "52px"
  button-outlined:
    backgroundColor: "transparent"
    textColor: "{colors.primary}"
    rounded: "{rounded.md}"
    padding: "14px 20px"
    height: "52px"
  card:
    backgroundColor: "#FFFFFF"
    rounded: "{rounded.lg}"
    padding: "{spacing.lg}"
  input:
    backgroundColor: "#FFFFFF"
    rounded: "{rounded.md}"
    padding: "14px 18px"
  chip:
    backgroundColor: "{colors.neutral-100}"
    rounded: "{rounded.sm}"
    padding: "{spacing.sm} {spacing.md}"
---

# Design System: PRF Missions

## 1. Overview

**Creative North Star: "The Living Root"**

PRF Missions is rooted in faith and reaches outward through action. The design system reflects this: a grounded navy foundation anchors every screen, while lime green moments signal where faith becomes active participation. The system rejects the generic church-app template and the cold SaaS aesthetic — it should feel like an extension of Parkroad Fellowship itself, warm but not sentimental, purposeful but not corporate.

The palette carries a deliberate tension: deep navy (#1A2253) communicates trust, stability, and rootedness; lime green (#9DE35D) injects energy, growth, and forward motion. This is not a system that whispers — it speaks with quiet confidence. Every interaction should feel intentional, not filler. The app earns its place on a member's phone by making participation in fellowship life effortless and meaningful.

**Key Characteristics:**
- **Rooted confidence:** Navy anchors every surface; nothing floats without purpose
- **Active energy:** Lime green appears only where action happens — buttons, states, calls to participation
- **Clean minimalism:** Functional, not decorative; every element earns its space
- **Warm clarity:** Approachable without being soft; professional without being cold

## 2. Colors

The palette is built on a deep navy foundation with a vibrant lime green accent, grounded by a comprehensive neutral scale. Trust and action are carried by two deliberate color roles.

### Primary
- **Deep Navy** (#1A2253): The foundational anchor. Used for primary buttons (light mode), app bar text, headings, and the dominant surface tint. This color IS the brand — it appears on every screen as the visual weight that holds everything together.

### Secondary
- **Living Lime** (#9DE35D): The action spark. Used for primary buttons (dark mode), selected states, success indicators, and interactive highlights. Reserved for moments of participation — it should appear on ≤20% of any given screen to maintain its impact.

### Neutral
- **Cloud** (#F7F9FC): Scaffold background, light surfaces
- **Mist** (#F0F3F8): Card backgrounds, subtle fills
- **Fog** (#E6EAF2): Borders, dividers
- **Slate** (#D6DDE9): Disabled states, muted borders
- **Stone** (#B5C0D3): Placeholder text, inactive icons
- **Ash** (#8F9BB3): Secondary text, captions
- **Charcoal** (#6B758D): Body small text, metadata
- **Slate Deep** (#4B5368): Dark mode borders, muted text
- **Night** (#2F3547): Dark mode surfaces
- **Obsidian** (#171C29): Dark mode scaffold

### Status
- **Emerald** (#0FA678): Success states, completed missions
- **Amber** (#F59E0B): Warnings, pending states
- **Crimson** (#D14343): Errors, destructive actions
- **Azure** (#2E7AF8): Informational, links, contact states

### Accent
- **Violet** (#6E4CEB): Mission states, events
- **Cerulean** (#296DFF): Contact, initiated states
- **Tangerine** (#EB8B2D): Scheduled, pending states
- **Jade** (#12B886): Active, ongoing indicators

### Named Rules

**The Living Root Rule.** Navy is the root — it appears on every surface, in every mode, as the visual anchor. Lime green is the living growth — it appears only where action happens. If lime green is decorating a surface rather than calling to action, it's being misused.

**The Trust-Then-Action Rule.** Navy communicates trust (read, understand, feel grounded). Lime communicates action (tap, give, participate). Every screen should have more navy than lime. The ratio IS the hierarchy.

## 3. Typography

**Display Font:** Manrope (with system fallback)
**Body Font:** Manrope (with system fallback)
**Label Font:** Manrope (with system fallback)

**Character:** Manrope is a geometric sans-serif with a warm, approachable personality. Its clean lines and generous x-height make it highly legible on mobile screens. The single-family approach creates visual cohesion — hierarchy is built through weight and size, not font switching. This is a system that speaks clearly, not loudly.

### Hierarchy
- **Display Large** (800 weight, 38px, 1.1 line-height): Hero statements, mission titles. The voice of the app — confident, rooted, purposeful.
- **Display Medium** (700 weight, 32px, 1.15 line-height): Section headers, primary headings.
- **Display Small** (700 weight, 28px, 1.2 line-height): Card titles, feature headers.
- **Headline Large** (700 weight, 24px, 1.25 line-height): Screen titles, prominent labels.
- **Headline Medium** (700 weight, 20px, 1.3 line-height): Sub-section headers.
- **Headline Small** (600 weight, 18px, 1.35 line-height): Tertiary headings, list item titles.
- **Title Large** (700 weight, 17px, 1.35 line-height): Navigation labels, dialog titles.
- **Title Medium** (600 weight, 15px, 1.4 line-height): Button text, chip labels.
- **Title Small** (600 weight, 14px, 1.4 line-height): Compact labels, badges.
- **Body Large** (500 weight, 16px, 1.5 line-height): Primary reading text, descriptions. Max line length: 65ch.
- **Body Medium** (500 weight, 15px, 1.5 line-height): Secondary reading text, form content.
- **Body Small** (500 weight, 13px, 1.45 line-height): Captions, metadata, timestamps. Color: Charcoal (#6B758D).
- **Label Large** (700 weight, 14px, 1.35 line-height): Form labels, section markers.
- **Label Medium** (700 weight, 13px, 1.35 line-height): Compact labels, tags.
- **Label Small** (600 weight, 12px, 1.3 line-height): Fine print, legal. Color: Charcoal (#6B758D).

### Named Rules

**The One Voice Rule.** Manrope is the only typeface. Hierarchy is expressed through weight (500 → 800) and size (12px → 38px), never through font family switching. If you're reaching for a second font, you're solving the wrong problem.

**The Confident Scale Rule.** Display sizes start at 38px. Body text stays at 15-16px. The gap between display and body is intentional — it creates a clear hierarchy where headlines command attention and body text delivers substance. Don't compress the scale to fill space.

## 4. Elevation

The system is flat by default with subtle depth used sparingly for interactive feedback. Depth is conveyed through tonal layering (surface color shifts between light and dark mode) rather than heavy shadows. Shadows appear only on elevated elements: cards, floating buttons, and snackbars.

### Shadow Vocabulary
- **Card Shadow** (`box-shadow: 0 4px 16px rgba(0,0,0,0.08), 0 2px 8px rgba(0,0,0,0.04)`): Ambient lift for cards and containers. Never dramatic — just enough to separate from the scaffold.
- **Elevated Shadow** (`box-shadow: 0 8px 24px rgba(0,0,0,0.12), 0 4px 12px rgba(0,0,0,0.06)`): Floating elements, modals, dialogs. Reserved for overlays that demand attention.
- **Badge Shadow** (`box-shadow: 0 4px 8px rgba(0,0,0,0.30)`): Notification badges, floating indicators. High-contrast shadow for small, important elements.

### Named Rules

**The Flat-By-Default Rule.** Surfaces are flat at rest. Shadows appear only as a response to elevation (cards, modals) or state (pressed, focused). If every element has a shadow, nothing is elevated. Reserve depth for hierarchy.

## 5. Components

Every component should feel clean, minimal, and functional — getting out of the way so the member can focus on what matters: participating in fellowship life.

### Buttons
- **Shape:** Gently curved (16px radius)
- **Primary (Light):** Deep Navy (#1A2253) background, white text. Full-width, 52px height. Padding: 14px vertical, 20px horizontal. Weight 700, 15px. The workhorse — used for every primary action.
- **Primary (Dark):** Living Lime (#9DE35D) background, navy text. Same dimensions. The dark-mode inversion keeps the action color vibrant against dark surfaces.
- **Hover/Focus:** Subtle overlay shift (8% white in light, 14% navy in dark). Focus ring uses primary color at 12% opacity. Pressed state: 98.5% scale, 92% opacity.
- **Outlined:** Transparent background, neutral border (#D6DDE9), primary text. Border: 1.2px. Used for secondary actions. Dark mode border: #4B5368.
- **Disabled:** 42% opacity background, 72% opacity text. Clearly communicates inactivity without visual noise.

### Cards / Containers
- **Corner Style:** 20px radius (generous, approachable)
- **Background:** White (#FFFFFF) in light, Night (#0D112A) in dark
- **Shadow Strategy:** Card shadow by default. Flat in dark mode (tonal layering replaces shadows).
- **Border:** 1px Fog (#E6EAF2) in light, 1px Slate Deep (#4B5368) in dark
- **Internal Padding:** 18px (lg spacing)

### Inputs / Fields
- **Style:** Filled, white background (#FFFFFF), Fog border (#D6DDE9), 16px radius, 1.2px stroke
- **Focus:** Border shifts to primary (#1A2253), stroke widens to 1.8px. Dark mode focus: lime green (#9DE35D).
- **Padding:** 14px vertical, 18px horizontal
- **Error:** Crimson border (#D14343), error text style (12px, w600)
- **Disabled:** Slate fill (#D6DDE9), muted text

### Chips
- **Style:** Mist background (#F0F3F8), 10px radius
- **Selected:** Deep Navy (#1A2253) background, white text
- **Disabled:** Slate fill (#D6DDE9)
- **Typography:** Label Medium (13px, w700)

### Navigation (App Bar)
- **Style:** Cloud background (#F7F9FC) in light, Obsidian (#090B1F) in dark. Zero elevation — flat and clean.
- **Typography:** Headline Small (18px, w700), Deep Navy text in light, white in dark.
- **Icon Color:** Primary (#1A2253) in light, white in dark. Size: 22px.

### SnackBar
- **Light:** Deep Navy (#1A2253) background, white text, 16px radius
- **Dark:** Living Lime (#9DE35D) background, navy text. The dark-mode snackbar is a deliberate brand moment.

### Dialog
- **Background:** White
- **Shape:** 20px radius (matches cards for visual consistency)
- **Title:** Title Large (17px, w700)
- **Content:** Body Medium (15px, w500)

### Divider
- **Color:** Fog (#E6EAF2) in light, Slate Deep (#4B5368) in dark
- **Thickness:** 1px. Structural, not decorative.

## 6. Tablet Layout Language

Tablet (≥600dp) is a first-class surface. Screens restructure — they never
stretch a phone layout. The canonical geometry ships as shared components in
`prf_design_system` (`src/widgets/layouts/`).

### Split Scaffold — `PRFTabletSplitScaffold`
- **Stage:** `Scaffold > SafeArea > Center > ConstrainedBox(maxWidth: 1100)`; content centers beyond the cap instead of stretching to uncomfortable reading widths.
- **Columns:** content `flex: 3` | hairline divider (`outline` @ 12% alpha) | side panel `flex: 2`.
- The content column owns the header row, tabs, search and the primary scrollable list/grid.
- Grids size against the **pane**, not the window: use `SliverGridDelegateWithMaxCrossAxisExtent` (~340 for cards, ~220 for media thumbnails). Never `MediaQuery.width >= 1024 ? 2 : 1`.

### Header Row — `PRFTabletHeaderRow`
- Back `IconButton` + **Expanded**(title, headlineMedium w700) + inline 24px loading slot + trailing actions.
- The title absorbs long localizations; the spinner keeps counts from flashing zero mid-reload.

### Brand Panel — `PRFBrandPanel`
- Navy (#1A2253) card at radius lg, clipped, with the Living Root motif painted behind a **scrollable** body (padding xl inside, lg outside).
- Section labels: uppercase labelMedium, navy100, w700, letterSpacing .6 (`PRFPanelSectionLabel`).
- Body text white/navy100; stat chips on translucent white @ 12%; lime green appears only where tapping does something.
- Light-surface widgets reused inside the panel sit on a `surface` card for legibility.

### Motion & states
- Entrance cascades play **once per screen instance** (gated flag); rebuilds and scrolled-in cards never replay.
- Pull-to-refresh keeps existing items visible; full-area spinners only when nothing has loaded yet.
- Every list screen covers load / error / empty (+ CTA) states via `PRFCircularProgressIndicator`, `PRFEmptyView`, `RefreshIndicator`.

## 7. Do's and Don'ts

### Do:
- **Do** use Deep Navy (#1A2253) as the visual anchor on every screen — it IS the brand
- **Do** reserve Living Lime (#9DE35D) for actions and interactive states — its rarity is its power
- **Do** keep buttons full-width and confident — 52px height, 16px radius, Manrope w700
- **Do** use tonal layering (surface color shifts) instead of heavy shadows for depth
- **Do** maintain the trust-then-action ratio: more navy than lime, always
- **Do** use the full neutral scale for hierarchy — Cloud for scaffold, Mist for surfaces, Fog for borders
- **Do** support dark mode as a first-class citizen — the lime-green-inversion is a deliberate brand moment

### Don't:
- **Don't** use generic church app templates — PRF Missions is purpose-built, not off-the-shelf
- **Don't** apply a corporate SaaS aesthetic — no cold, enterprise-looking interfaces
- **Don't** chase trendy design patterns — keep it timeless, not fleeting
- **Don't** use gradient text (`background-clip: text`) — decorative, never meaningful
- **Don't** apply glassmorphism as default — blurs and glass cards are rare and purposeful, or nothing
- **Don't** create identical card grids with icon + heading + text repeated endlessly
- **Don't** use tiny uppercase tracked eyebrows above every section — one kicker as a deliberate brand system is voice; an eyebrow on every section is AI grammar
- **Don't** use numbered section markers as default scaffolding (01 / 02 / 03) — numbers earn their place when the section IS a sequence
- **Don't** exceed 65ch body line length — readability is non-negotiable
- **Don't** use side-stripe borders (`border-left` > 1px) as colored accents — rewrite with full borders or background tints
- **Don't** let lime green decorate surfaces — it calls to action, it doesn't wallpaper
- **Don't** compress the type scale — the gap between display (38px) and body (15px) IS the hierarchy
- **Don't** stretch a phone layout across a tablet — restructure with `PRFTabletSplitScaffold`
- **Don't** hand-roll light side panels where the navy brand panel belongs — one panel language, everywhere
- **Don't** size grids from window width — measure the pane they live in
