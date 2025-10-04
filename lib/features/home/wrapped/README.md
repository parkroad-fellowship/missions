# Missions Wrapped Feature

A Spotify Wrapped-style experience for showcasing member engagement statistics.

## Overview

This feature provides an immersive, full-screen experience where users can swipe through beautifully animated pages displaying their yearly impact, missions, learning progress, and more.

## Structure

```
wrapped/
├── missions_wrapped.dart    # Route entry point
├── _handset.dart           # Main container with PageView
├── pages/
│   └── wrapped_pages.dart  # All 7 page widgets
└── README.md              # This file
```

## Pages Included

1. **IntroWrappedPage** - Welcome screen
2. **MissionsWrappedPage** - Mission statistics
3. **ImpactWrappedPage** - Impact metrics
4. **LearningWrappedPage** - Learning progress
5. **PrayerWrappedPage** - Prayer journey (conditional)
6. **EventsWrappedPage** - Event participation (conditional)
7. **SummaryWrappedPage** - Year-end summary

## Features

- ✨ Rich animations with flutter_animate
- 📱 Full-screen swipeable pages
- 🎨 Unique gradient themes per category
- 🔄 Conditional page rendering
- 📊 State management with BLoC
- ⚡ Performant lazy loading
- 🎯 Empty/loading/error states

## Usage

Navigate to the wrapped experience:
```dart
context.router.push(const MissionsWrappedRoute());
```

Or trigger data fetch manually:
```dart
context.read<GetMemberEngagementCubit>().getMemberEngagement(
  year: DateTime.now().year,
);
```

## Shared Widgets

The feature uses 3 reusable widgets from `lib/shared_widgets/wrapped/`:
- `AnimatedStatCard` - Primary stat display
- `StatHighlightCard` - Achievement highlights  
- `WrappedPageIndicator` - Page navigation dots

## Documentation

See `/docs/` for comprehensive guides:
- `WRAPPED_FEATURE.md` - Architecture & usage
- `WRAPPED_VISUAL_FLOW.md` - Visual mockups
- `WRAPPED_IMPLEMENTATION_SUMMARY.md` - Technical details
- `WRAPPED_QUICK_REFERENCE.md` - Quick lookup
- `WRAPPED_SCREEN_EXAMPLES.md` - Screen mockups

## Dependencies

- `flutter_animate: ^4.5.2`
- `flutter_bloc: ^9.1.1`
- `auto_route: ^10.1.2`

## Testing

Run through these scenarios:
- User with all stats
- User with no prayer/event data
- User with zero missions (empty state)
- Network error (error state)
- Different screen sizes

## Customization

To add a new stat page:
1. Create widget in `wrapped_pages.dart`
2. Add to page list in `_handset.dart`
3. Update conditional logic if needed

To modify colors:
Update the gradient colors in each page's `Container` decoration.

To adjust animations:
Modify the `.animate()` chains and delay values.

## Future Enhancements

- [ ] Share to social media
- [ ] Download as PDF
- [ ] Audio/haptic feedback
- [ ] Badge system
- [ ] Historical year selection
- [ ] Comparative stats

---

**Status:** ✅ Production Ready
**Version:** 1.0.0
**Last Updated:** 2024
