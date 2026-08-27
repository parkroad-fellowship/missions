import 'dart:async';

import 'package:app/features/home/shared/cubit/member_engagement_resource_cubit.dart';
import 'package:app/features/home/wrapped/_shared.dart';
import 'package:app/features/home/wrapped/pages/wrapped_pages.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/member/prf_member_engagement.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaimon/gaimon.dart';
import 'package:prf_design/prf_design.dart';

class MissionsWrappedHandset extends StatefulWidget {
  const MissionsWrappedHandset({super.key});

  @override
  State<MissionsWrappedHandset> createState() => _MissionsWrappedHandsetState();
}

class _MissionsWrappedHandsetState extends State<MissionsWrappedHandset>
    with SingleTickerProviderStateMixin {
  static const Duration _pageTransition = Duration(milliseconds: 400);
  static const Duration _navCooldown = Duration(milliseconds: 250);
  static const double _backZoneFraction = 0.25;

  late PageController _pageController;
  late AnimationController _timelineController;
  List<Duration> _durations = const [];
  int _currentPage = 0;
  int _pageCount = 0;
  bool _timelineStarted = false;
  bool _closeButtonVisible = true;
  bool _holding = false;
  DateTime _lastNavAt = DateTime.fromMillisecondsSinceEpoch(0);
  Timer? _closeButtonTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _timelineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..addStatusListener(_onTimelineStatus);
    _resetCloseButtonTimer();
  }

  @override
  void dispose() {
    _closeButtonTimer?.cancel();
    _timelineController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onTimelineStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _advanceToNextPage();
    }
  }

  bool get _isPageTransitioning {
    if (!_pageController.hasClients) return false;
    final page = _pageController.page ?? 0;
    return (page - page.roundToDouble()).abs() > 0.01;
  }

  bool get _isInNavCooldown =>
      DateTime.now().difference(_lastNavAt) < _navCooldown;

  void _advanceToNextPage() {
    if (!mounted || !_pageController.hasClients) return;
    final nextPage = _currentPage + 1;
    if (nextPage < _pageCount) {
      _lastNavAt = DateTime.now();
      _pageController.animateToPage(
        nextPage,
        duration: _pageTransition,
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _onPageChanged(int index) {
    if (!mounted) return;
    setState(() => _currentPage = index);
    _timelineController.reset();
    if (index < _durations.length) {
      _timelineController.duration = _durations[index];
    }
    if (index < _pageCount - 1) {
      _timelineController.forward();
    }
    _resetCloseButtonTimer();
  }

  void _goToPreviousPage() {
    if (_currentPage <= 0) return;
    _lastNavAt = DateTime.now();
    Gaimon.light();
    _pageController.previousPage(
      duration: _pageTransition,
      curve: Curves.easeOutCubic,
    );
  }

  void _goToNextPage() {
    if (_currentPage >= _pageCount - 1) return;
    _lastNavAt = DateTime.now();
    Gaimon.light();
    _pageController.nextPage(
      duration: _pageTransition,
      curve: Curves.easeOutCubic,
    );
  }

  void _skipToSummary() {
    final target = _pageCount - 1;
    if (target < 0 || _currentPage == target) return;
    _lastNavAt = DateTime.now();
    Gaimon.light();
    _pageController.animateToPage(
      target,
      duration: const Duration(milliseconds: 550),
      curve: Curves.easeOutCubic,
    );
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _closeButtonVisible = true);
    _resetCloseButtonTimer();

    if (_isPageTransitioning || _isInNavCooldown) return;

    final screenWidth = MediaQuery.of(context).size.width;
    final tapX = details.localPosition.dx;

    if (tapX < screenWidth * _backZoneFraction) {
      _goToPreviousPage();
    } else {
      _goToNextPage();
    }
  }

  void _resetCloseButtonTimer() {
    _closeButtonTimer?.cancel();
    _closeButtonTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _closeButtonVisible = false);
    });
  }

  bool _hasInsufficientData(PRFMemberEngagement m) {
    return m.missionStats.totalMissions == 0 &&
        m.impactStats.soulsTouched == 0 &&
        m.learningStats.coursesCompleted == 0 &&
        m.prayerStats.prayerResponses == 0 &&
        m.eventStats.eventsAttended == 0;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<
      MemberEngagementResourceCubit,
      ResourceState<PRFMemberEngagement>
    >(
      builder: (context, state) {
        return state.when(
          initial: () => buildWrappedLoadingState(context),
          listLoading: (_) => buildWrappedLoadingState(context),
          itemLoading: (_, _) => buildWrappedLoadingState(context),
          listLoaded: (memberEngagementList, _, _) {
            if (memberEngagementList.isEmpty) {
              return buildWrappedEmptyState(context, l10n);
            }
            final memberEngagement = memberEngagementList.first;
            final year = DateTime.now().year;

            if (_hasInsufficientData(memberEngagement)) {
              return buildInsufficientDataPage(context, l10n);
            }

            final pageEntries = <WrappedPageEntry>[
              WrappedPageEntry(
                title: l10n.wrappedTagline,
                duration: const Duration(seconds: 6),
                page: IntroWrappedPage(
                  memberName: memberEngagement.memberName,
                  year: year,
                ),
              ),
              WrappedPageEntry(
                title: l10n.wrappedMissionsTitle,
                duration: const Duration(seconds: 8),
                page: MissionsWrappedPage(
                  missionStats: memberEngagement.missionStats,
                ),
              ),
              WrappedPageEntry(
                title: l10n.wrappedImpactTitle,
                duration: const Duration(seconds: 11),
                page: ImpactWrappedPage(
                  impactStats: memberEngagement.impactStats,
                ),
              ),
              WrappedPageEntry(
                title: l10n.wrappedLearningTitle,
                duration: const Duration(seconds: 11),
                page: LearningWrappedPage(
                  learningStats: memberEngagement.learningStats,
                ),
              ),
            ];

            if (memberEngagement.prayerStats.prayerResponses > 0 ||
                memberEngagement.prayerStats.prayerConsistencyDays > 0) {
              pageEntries.add(
                WrappedPageEntry(
                  title: l10n.wrappedPrayerTitle,
                  duration: const Duration(seconds: 8),
                  page: PrayerWrappedPage(
                    prayerStats: memberEngagement.prayerStats,
                  ),
                ),
              );
            }

            if (memberEngagement.eventStats.eventsAttended > 0) {
              pageEntries.add(
                WrappedPageEntry(
                  title: l10n.wrappedEventsTitle,
                  duration: const Duration(seconds: 8),
                  page: EventsWrappedPage(
                    eventStats: memberEngagement.eventStats,
                  ),
                ),
              );
            }

            pageEntries.add(
              WrappedPageEntry(
                title: l10n.wrappedSummaryTitle,
                page: SummaryWrappedPage(
                  memberEngagement: memberEngagement,
                  year: year,
                ),
              ),
            );

            _pageCount = pageEntries.length;
            _durations = pageEntries.map((entry) => entry.duration).toList();
            if (!_timelineStarted) {
              _timelineStarted = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted || _durations.isEmpty) return;
                final index = _currentPage.clamp(0, _durations.length - 1);
                _timelineController.duration = _durations[index];
                _timelineController.forward(from: 0);
              });
            }
            final pages = List<Widget>.generate(
              pageEntries.length,
              (index) => Semantics(
                label: l10n.wrappedPageSemantics(
                  index + 1,
                  pageEntries[index].title,
                ),
                child: pageEntries[index].page,
              ),
            );

            return Scaffold(
              body: Stack(
                children: [
                  Listener(
                    onPointerDown: (_) {
                      _timelineController.stop();
                      if (!_holding) setState(() => _holding = true);
                    },
                    onPointerUp: (_) {
                      if (_holding) setState(() => _holding = false);
                      if (_currentPage < _pageCount - 1) {
                        _timelineController.forward();
                      }
                    },
                    onPointerCancel: (_) {
                      if (_holding) setState(() => _holding = false);
                      if (_currentPage < _pageCount - 1) {
                        _timelineController.forward();
                      }
                    },
                    child: GestureDetector(
                      onTapUp: _onTapUp,
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: _onPageChanged,
                        children: pages,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: WrappedTimeline(
                      listenable: _timelineController,
                      pageCount: _pageCount,
                      currentPage: _currentPage,
                    ),
                  ),
                  if (_holding && _currentPage < _pageCount - 1)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: SafeArea(
                        child: Align(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: PRFSpacingTokens.xl,
                            ),
                            child: _PausedChip(label: l10n.wrappedPaused),
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 0,
                    left: PRFSpacingTokens.sm,
                    right: PRFSpacingTokens.sm,
                    child: SafeArea(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AnimatedOpacity(
                            opacity: _closeButtonVisible ? 1.0 : 0.45,
                            duration: const Duration(milliseconds: 300),
                            child: Semantics(
                              label: l10n.wrappedCloseSemantics,
                              button: true,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: PRFColors.white,
                                  size: 20,
                                ),
                                onPressed: () => context.router.maybePop(),
                              ),
                            ),
                          ),
                          AnimatedOpacity(
                            opacity: _closeButtonVisible ? 1.0 : 0.45,
                            duration: const Duration(milliseconds: 300),
                            child: Semantics(
                              label: l10n.wrappedSkipToSummarySemantics,
                              button: true,
                              child: TextButton(
                                onPressed: _currentPage >= _pageCount - 1
                                    ? null
                                    : _skipToSummary,
                                child: Text(
                                  l10n.wrappedSkipToSummary,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: PRFColors.white.withValues(
                                      alpha: PRFOpacities.high,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          itemLoaded: (_, memberEngagementList) {
            if (memberEngagementList.isEmpty) {
              return buildWrappedEmptyState(context, l10n);
            }
            return buildWrappedLoadingState(context);
          },
          mutating: (_, _) => buildWrappedLoadingState(context),
          error: (message, _) => buildWrappedErrorState(context, l10n, message),
          itemError: (message, _, _) =>
              buildWrappedErrorState(context, l10n, message),
        );
      },
    );
  }
}

class _PausedChip extends StatelessWidget {
  const _PausedChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: PRFSpacingTokens.md,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: PRFColors.black.withValues(alpha: PRFOpacities.muted),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: PRFColors.white.withValues(alpha: PRFOpacities.muted),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.pause_rounded, size: 14, color: PRFColors.white),
          const SizedBox(width: PRFSpacingTokens.xs),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: PRFColors.white.withValues(alpha: PRFOpacities.high),
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 150.ms);
  }
}
