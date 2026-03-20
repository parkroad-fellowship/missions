import 'package:app/features/home/shared/cubit/member_engagement_resource_cubit.dart';
import 'package:app/features/home/wrapped/pages/wrapped_pages.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/member/prf_member_engagement.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class MissionsWrappedHandset extends StatefulWidget {
  const MissionsWrappedHandset({super.key});

  @override
  State<MissionsWrappedHandset> createState() => _MissionsWrappedHandsetState();
}

class _MissionsWrappedHandsetState extends State<MissionsWrappedHandset> {
  late PageController _pageController;
  int _currentPage = 0;

  Future<void> _skipToSummary(int summaryIndex) async {
    await _pageController.animateToPage(
      summaryIndex,
      duration: const Duration(milliseconds: 550),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
          listLoading: () => _buildLoadingState(theme),
          listLoaded: (memberEngagementList, _, _) {
            if (memberEngagementList.isEmpty) {
              return _buildEmptyState();
            }
            final memberEngagement = memberEngagementList.first;
            final year = DateTime.now().year;
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

            // Add prayer page if there are prayer responses
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

            // Add events page if there are events attended
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

            // Always add summary as the last page
            pageEntries.add(
              _WrappedPageEntry(
                title: l10n.wrappedSummaryTitle,
                page: SummaryWrappedPage(
                  memberEngagement: memberEngagement,
                  year: year,
                ),
              ),
            );

            final pageCount = pageEntries.length;
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
                  PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    children: pages,
                  ),
                  Positioned(
                    top: 60,
                    left: 0,
                    right: 0,
                    child:
                        WrappedStoryPageIndicator(
                              currentPage: _currentPage,
                              pageCount: pageCount,
                            )
                            .animate()
                            .fadeIn(
                              delay: 2000.ms,
                              duration: PRFMotionTokens.enterShort,
                            )
                            .slideY(begin: -0.5, end: 0),
                  ),
                  Positioned(
                    top: 60,
                    left: 16,
                    child:
                        Semantics(
                              label: l10n.wrappedCloseSemantics,
                              button: true,
                              child: IconButton(
                                icon: Container(
                                  padding: const EdgeInsets.all(
                                    PRFSpacingTokens.sm,
                                  ),
                                  decoration: BoxDecoration(
                                    color: PRFColors.black.withValues(
                                      alpha: 0.35,
                                    ),
                                    border: Border.all(
                                      color: PRFColors.white.withValues(
                                        alpha: 0.24,
                                      ),
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: PRFColors.white,
                                  ),
                                ),
                                onPressed: () => context.router.maybePop(),
                              ),
                            )
                            .animate()
                            .fadeIn(
                              delay: 2000.ms,
                              duration: PRFMotionTokens.enterShort,
                            )
                            .scale(delay: PRFMotionTokens.standard),
                  ),
                  if (_currentPage < pageCount - 1)
                    Positioned(
                      top: 60,
                      right: 16,
                      child:
                          Semantics(
                                label: l10n.wrappedSkipToSummarySemantics,
                                button: true,
                                child: TextButton.icon(
                                  onPressed: () =>
                                      _skipToSummary(pageCount - 1),
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: PRFSpacingTokens.md,
                                      vertical: PRFSpacingTokens.sm,
                                    ),
                                    backgroundColor: PRFColors.black.withValues(
                                      alpha: 0.35,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        PRFRadiusTokens.xl,
                                      ),
                                      side: BorderSide(
                                        color: PRFColors.white.withValues(
                                          alpha: 0.24,
                                        ),
                                      ),
                                    ),
                                  ),
                                  icon: const Icon(
                                    Icons.skip_next_rounded,
                                    color: PRFColors.white,
                                    size: 18,
                                  ),
                                  label: Text(
                                    l10n.wrappedSkipToSummary,
                                    style: theme.textTheme.labelLarge?.copyWith(
                                      color: PRFColors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              )
                              .animate()
                              .fadeIn(
                                delay: 1200.ms,
                                duration: PRFMotionTokens.enterShort,
                              )
                              .slideX(begin: 0.2, end: 0),
                    ),
                ],
              ),
            );
          },
          mutating: (_, _) => _buildLoadingState(theme),
          mutated: (_, _, _) => _buildLoadingState(theme),
          error: (message, _) => _buildErrorState(message),
        );
      },
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Scaffold(
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

class _WrappedPageEntry {
  const _WrappedPageEntry({
    required this.title,
    required this.page,
  });

  final String title;
  final Widget page;
}
