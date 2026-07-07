import 'dart:async';

import 'package:app/features/home/shared/cubit/member_engagement_resource_cubit.dart';
import 'package:app/features/home/wrapped/pages/wrapped_pages.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/member/prf_member_engagement.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class MissionsWrappedHandset extends StatefulWidget {
  const MissionsWrappedHandset({super.key});

  @override
  State<MissionsWrappedHandset> createState() => _MissionsWrappedHandsetState();
}

class _MissionsWrappedHandsetState extends State<MissionsWrappedHandset>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _timelineController;
  int _currentPage = 0;
  int _pageCount = 0;
  bool _closeButtonVisible = true;
  Timer? _closeButtonTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _timelineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..addStatusListener(_onTimelineStatus);
    _timelineController.forward();
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

  void _advanceToNextPage() {
    if (!mounted || !_pageController.hasClients) return;
    final nextPage = _currentPage + 1;
    if (nextPage < _pageCount) {
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _onPageChanged(int index) {
    if (!mounted) return;
    setState(() => _currentPage = index);
    _timelineController.reset();
    if (index < _pageCount - 1) {
      _timelineController.forward();
    }
    _resetCloseButtonTimer();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _closeButtonVisible = true);
    _resetCloseButtonTimer();

    final screenWidth = MediaQuery.of(context).size.width;
    final tapX = details.localPosition.dx;

    if (tapX < screenWidth * 0.4) {
      if (_currentPage > 0) {
        _pageController.previousPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        );
      }
    } else {
      if (_currentPage < _pageCount - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        );
      }
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
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return BlocBuilder<
      MemberEngagementResourceCubit,
      ResourceState<PRFMemberEngagement>
    >(
      builder: (context, state) {
        return state.when(
          initial: () => _buildLoadingState(theme),
          listLoading: (_) => _buildLoadingState(theme),
          itemLoading: (_, _) => _buildLoadingState(theme),
          listLoaded: (memberEngagementList, _, _) {
            if (memberEngagementList.isEmpty) {
              return _buildEmptyState();
            }
            final memberEngagement = memberEngagementList.first;
            final year = DateTime.now().year;

            if (_hasInsufficientData(memberEngagement)) {
              return _buildInsufficientDataPage();
            }

            final pageEntries = <_WrappedPageEntry>[
              _WrappedPageEntry(
                title: l10n.wrappedTagline,
                page: IntroWrappedPage(
                  memberName: memberEngagement.memberName,
                  year: year,
                ),
              ),
              _WrappedPageEntry(
                title: l10n.wrappedMissionsTitle,
                page: MissionsWrappedPage(
                  missionStats: memberEngagement.missionStats,
                ),
              ),
              _WrappedPageEntry(
                title: l10n.wrappedImpactTitle,
                page: ImpactWrappedPage(
                  impactStats: memberEngagement.impactStats,
                ),
              ),
              _WrappedPageEntry(
                title: l10n.wrappedLearningTitle,
                page: LearningWrappedPage(
                  learningStats: memberEngagement.learningStats,
                ),
              ),
            ];

            if (memberEngagement.prayerStats.prayerResponses > 0 ||
                memberEngagement.prayerStats.prayerConsistencyDays > 0) {
              pageEntries.add(
                _WrappedPageEntry(
                  title: l10n.wrappedPrayerTitle,
                  page: PrayerWrappedPage(
                    prayerStats: memberEngagement.prayerStats,
                  ),
                ),
              );
            }

            if (memberEngagement.eventStats.eventsAttended > 0) {
              pageEntries.add(
                _WrappedPageEntry(
                  title: l10n.wrappedEventsTitle,
                  page: EventsWrappedPage(
                    eventStats: memberEngagement.eventStats,
                  ),
                ),
              );
            }

            pageEntries.add(
              _WrappedPageEntry(
                title: l10n.wrappedSummaryTitle,
                page: SummaryWrappedPage(
                  memberEngagement: memberEngagement,
                  year: year,
                ),
              ),
            );

            _pageCount = pageEntries.length;
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
              appBar: const PRFAppBar(title: 'Wrapped'),
              body: Stack(
                children: [
                  Listener(
                    onPointerDown: (_) => _timelineController.stop(),
                    onPointerUp: (_) {
                      if (_currentPage < _pageCount - 1) {
                        _timelineController.forward();
                      }
                    },
                    onPointerCancel: (_) {
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
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: _TimelineProgressBar(
                      listenable: _timelineController,
                    ),
                  ),
                  Positioned(
                    top: 60,
                    left: 16,
                    child: AnimatedOpacity(
                      opacity: _closeButtonVisible ? 1.0 : 0.0,
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
                  ),
                ],
              ),
            );
          },
          itemLoaded: (_, memberEngagementList) {
            if (memberEngagementList.isEmpty) {
              return _buildEmptyState();
            }
            return _buildLoadingState(theme);
          },
          mutating: (_, _) => _buildLoadingState(theme),
          error: (message, _) => _buildErrorState(message),
          itemError: (message, _, _) => _buildErrorState(message),
        );
      },
    );
  }

  Widget _buildInsufficientDataPage() {
    return Scaffold(
      appBar: const PRFAppBar(title: 'Wrapped'),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(PRFSpacingTokens.lg),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: PRFColors.white),
                    onPressed: () => context.router.maybePop(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CinematicSlide(
                children: [
                  Icon(
                    Icons.inbox_rounded,
                    size: 48,
                    color: PRFColors.white.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: PRFSpacingTokens.md),
                  Text(
                    'Not enough data yet',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: PRFColors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: PRFSpacingTokens.sm),
                  Text(
                    'Complete missions, courses, and more\nto unlock your Wrapped next season!',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: PRFColors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Scaffold(
      appBar: const PRFAppBar(title: 'Wrapped'),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.primary.withValues(alpha: 0.7),
            ],
          ),
        ),
        child: const Center(
          child: PRFCircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final l10n = context.l10n;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(PRFSpacingTokens.lg),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.router.maybePop(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PRFEmptyView(
                label: l10n.wrappedNoImpactDataTitle,
                description: l10n.wrappedNoImpactDataDescription,
                icon: Icons.insights_rounded,
                actionLabel: l10n.wrappedGoBack,
                onActionPressed: () => context.router.maybePop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    final l10n = context.l10n;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(PRFSpacingTokens.lg),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.router.maybePop(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PRFEmptyView(
                label: l10n.wrappedSomethingWentWrong,
                description: message,
                icon: Icons.error_outline_rounded,
                actionLabel: l10n.wrappedTryAgain,
                onActionPressed: () {
                  context.read<MemberEngagementResourceCubit>().loadEngagement(
                    year: DateTime.now().year,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineProgressBar extends AnimatedWidget {
  const _TimelineProgressBar({
    required super.listenable,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (listenable as Animation<double>).value;
    return SizedBox(
      width: double.infinity,
      height: 2,
      child: Stack(
        children: [
          Container(color: PRFColors.white.withValues(alpha: 0.15)),
          FractionallySizedBox(
            widthFactor: progress.clamp(0.0, 1.0),
            child: Container(color: PRFColors.white.withValues(alpha: 0.7)),
          ),
        ],
      ),
    );
  }
}

class _WrappedPageEntry {
  const _WrappedPageEntry({
    required this.title,
    required this.page,
  });

  final String title;
  final Widget page;
}
