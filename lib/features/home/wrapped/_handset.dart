import 'dart:async';

import 'package:app/features/home/shared/cubit/member_engagement_resource_cubit.dart';
import 'package:app/features/home/wrapped/_shared.dart';
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
          initial: () => buildWrappedLoadingState(theme),
          listLoading: (_) => buildWrappedLoadingState(theme),
          itemLoading: (_, _) => buildWrappedLoadingState(theme),
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
                page: IntroWrappedPage(
                  memberName: memberEngagement.memberName,
                  year: year,
                ),
              ),
              WrappedPageEntry(
                title: l10n.wrappedMissionsTitle,
                page: MissionsWrappedPage(
                  missionStats: memberEngagement.missionStats,
                ),
              ),
              WrappedPageEntry(
                title: l10n.wrappedImpactTitle,
                page: ImpactWrappedPage(
                  impactStats: memberEngagement.impactStats,
                ),
              ),
              WrappedPageEntry(
                title: l10n.wrappedLearningTitle,
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
                    child: TimelineProgressBar(
                      listenable: _timelineController,
                    ),
                  ),
                  Positioned(
                    top: 60,
                    left: PRFSpacingTokens.lg,
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
              return buildWrappedEmptyState(context, l10n);
            }
            return buildWrappedLoadingState(theme);
          },
          mutating: (_, _) => buildWrappedLoadingState(theme),
          error: (message, _) => buildWrappedErrorState(context, l10n, message),
          itemError: (message, _, _) =>
              buildWrappedErrorState(context, l10n, message),
        );
      },
    );
  }
}
