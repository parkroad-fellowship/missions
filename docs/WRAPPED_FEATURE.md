# Missions Wrapped Feature

## Overview
The Missions Wrapped feature provides a Spotify Wrapped-like experience to showcase member engagement statistics in a creative and visually appealing manner. Users can swipe through full-screen animated pages that highlight their yearly impact, missions, learning, and more.

## Architecture

### Components

#### 1. **Shared Widgets** (`lib/shared_widgets/wrapped/`)
Reusable components for the wrapped experience:

- **AnimatedStatCard**: Displays a single statistic with icon, value, and label. Features fade-in and slide animations.
- **StatHighlightCard**: Horizontal card with gradient background for highlighting special achievements.
- **WrappedPageIndicator**: Animated page indicator showing current position in the story.

#### 2. **Wrapped Pages** (`lib/features/home/wrapped/pages/`)
Individual page components for different stat categories:

- **IntroWrappedPage**: Welcome screen with member name and year
- **MissionsWrappedPage**: Mission statistics (total, schools, completion rate, streaks)
- **ImpactWrappedPage**: Impact statistics (souls touched, most impactful mission, decision types)
- **LearningWrappedPage**: Learning progress (courses, lessons, progress %, streaks)
- **SummaryWrappedPage**: Year-end summary with combined stats

#### 3. **Main Container** (`lib/features/home/wrapped/_handset.dart`)
Orchestrates the wrapped experience with PageView navigation and state management.

## Features

### Animations (flutter_animate)
- Fade In, Slide, Scale, Shimmer effects
- Staggered delays for sequential revelation
- Elastic and bounce curves for playful feel

### Navigation
- Swipe between pages
- Visual page indicators
- Close button overlay
- System back support

## Design Decisions

**Why PageView?** Full-screen immersive experience matching Spotify Wrapped
**Color Scheme:** Distinct gradients per category for visual variety
**Animation Timing:** Staggered 200ms intervals for smooth flow

## Future Enhancements
- Share functionality (export as image/video)
- Badges for achievements
- Comparative stats
- Audio/haptic feedback
- Auto-play mode
- Historical year selection
