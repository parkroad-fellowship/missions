# Missions Wrapped - Quick Reference

## 🎯 Purpose
A Spotify Wrapped-style experience to showcase member engagement data with beautiful animations and gradients.

## 📊 Statistics Showcased

| Category    | Metrics                                          | Conditional |
|-------------|--------------------------------------------------|-------------|
| **Missions**| Total, Schools Reached, Completion %, Streaks   | Always      |
| **Impact**  | Souls Touched, Most Impactful Mission, Decisions| Always      |
| **Learning**| Courses, Lessons, Progress %, Streaks           | Always      |
| **Prayer**  | Prayer Responses, Consistency Days              | If > 0      |
| **Events**  | Events Attended, Upcoming Events                | If > 0      |
| **Summary** | Combined overview of all stats                   | Always      |

## 🎨 Color Themes

```
Intro:    Primary Blue (#17154C) → Secondary Green (#93D500)
Missions: Purple (#4A148C → #6A1B9A)
Impact:   Blue (#1976D2 → #1565C0)
Learning: Green (#388E3C → #2E7D32)
Prayer:   Orange (#E65100 → #FF6F00)
Events:   Red (#D32F2F → #C62828)
Summary:  Mixed gradient (Primary → Purple → Secondary)
```

## ✨ Key Animations

| Element           | Animation Type      | Timing   |
|-------------------|---------------------|----------|
| Icons             | Scale + Elastic     | 0-200ms  |
| Numbers           | Fade + Slide Up     | 200-400ms|
| Labels            | Fade + Slide Up     | 400-600ms|
| Highlight Cards   | Fade + Slide Left   | 600-800ms|
| Call-to-Action    | Shimmer (repeating) | 1500ms+  |

## 🔄 Navigation Flow

```
[Intro] → [Missions] → [Impact] → [Learning] 
   ↓
[Prayer?] → [Events?] → [Summary]
   ↓           ↓
(if data)   (if data)
```

## 🛠️ Files Modified/Created

**Created:**
- `lib/features/home/wrapped/pages/wrapped_pages.dart` (7 page widgets)
- `lib/shared_widgets/wrapped/animated_stat_card.dart`
- `lib/shared_widgets/wrapped/stat_highlight_card.dart`
- `lib/shared_widgets/wrapped/wrapped_page_indicator.dart`
- `docs/WRAPPED_*.md` (3 documentation files)

**Modified:**
- `lib/features/home/wrapped/_handset.dart` (main container)
- `lib/shared_widgets/_index.dart` (exports)

## 🎮 User Interactions

| Action          | Result                           |
|-----------------|----------------------------------|
| Swipe Left      | Next page                        |
| Swipe Right     | Previous page                    |
| Tap Close (X)   | Exit to previous screen          |
| System Back     | Exit wrapped experience          |

## 📦 Component Usage

### AnimatedStatCard
```dart
AnimatedStatCard(
  value: '42',
  label: 'Total Missions',
  icon: Icons.explore_rounded,
  color: Colors.white,
  delay: 400.ms,
)
```

### StatHighlightCard
```dart
StatHighlightCard(
  title: '🔥 5 Mission Streak!',
  subtitle: 'Keep up the amazing work',
  gradient: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
  delay: 800.ms,
)
```

### WrappedPageIndicator
```dart
WrappedPageIndicator(
  currentPage: _currentPage,
  pageCount: pages.length,
)
```

## 🧪 Testing Checklist

- [ ] Swipe navigation works smoothly
- [ ] All animations play correctly
- [ ] Page indicators update properly
- [ ] Close button functions
- [ ] Empty state displays correctly
- [ ] Loading spinner shows during fetch
- [ ] Error state allows retry
- [ ] Conditional pages appear/hide as expected
- [ ] Works on different screen sizes
- [ ] Safe areas respected (notched devices)

## 🚀 How to Access

**In Code:**
```dart
context.router.push(const MissionsWrappedRoute());
```

**User Flow:**
1. Navigate to home/missions section
2. Tap "View My Impact" / "Wrapped" button
3. Wait for data to load
4. Swipe through pages

## 💡 Pro Tips

1. **Best Data**: Feature shines with 20+ missions and varied activities
2. **First-Time Users**: Will see empty state - encourage participation
3. **Yearly Reset**: Data is year-specific, resets each year
4. **Performance**: Pages lazy load, only visible page renders
5. **Customization**: Easy to add new pages or modify colors

## 📈 Metrics to Track

Consider tracking:
- Views per user
- Average pages viewed
- Completion rate (viewed to summary)
- Share rate (if implemented)
- Time spent on each page
- Drop-off points

## 🔮 Future Features

**Phase 2:**
- [ ] Share to social media
- [ ] Download as PDF
- [ ] Audio/haptic feedback
- [ ] Badge system
- [ ] Year selection

**Phase 3:**
- [ ] Comparative rankings
- [ ] Video export
- [ ] Custom themes
- [ ] Personalized insights
- [ ] Achievement unlocks

---

**Total Lines of Code:** ~1,236 lines
**Files Created:** 7 files
**Dependencies Used:** flutter_animate, flutter_bloc, auto_route
**Ready for:** Manual testing and UI review
