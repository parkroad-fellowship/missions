import 'package:app/features/home/shared/cubit/member_engagement_resource_cubit.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:app/models/remote/member/prf_member_engagement.dart';
import 'package:app/features/home/wrapped/pages/wrapped_pages.dart';
import 'package:prf_design/prf_design.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MissionsWrappedHandset extends StatefulWidget {
  const MissionsWrappedHandset({super.key});

  @override
  State<MissionsWrappedHandset> createState() => _MissionsWrappedHandsetState();
}

class _MissionsWrappedHandsetState extends State<MissionsWrappedHandset> {
  late PageController _pageController;
  int _currentPage = 0;

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

    return BlocBuilder<MemberEngagementResourceCubit, ResourceState<PRFMemberEngagement>>(
      builder: (context, state) {
        return state.when(
          initial: () => _buildLoadingState(theme),
          listLoading: () => _buildLoadingState(theme),
          empty: _buildEmptyState,
          listLoaded: (memberEngagement) {
            final year = DateTime.now().year;
            final pages = <Widget>[
              IntroWrappedPage(
                memberName: memberEngagement.memberName,
                year: year,
              ),
              MissionsWrappedPage(
                missionStats: memberEngagement.missionStats,
              ),
              ImpactWrappedPage(
                impactStats: memberEngagement.impactStats,
              ),
              LearningWrappedPage(
                learningStats: memberEngagement.learningStats,
              ),
            ];

            // Add prayer page if there are prayer responses
            if (memberEngagement.prayerStats.prayerResponses > 0 ||
                memberEngagement.prayerStats.prayerConsistencyDays > 0) {
              pages.add(
                PrayerWrappedPage(
                  prayerStats: memberEngagement.prayerStats,
                ),
              );
            }

            // Add events page if there are events attended
            if (memberEngagement.eventStats.eventsAttended > 0) {
              pages.add(
                EventsWrappedPage(
                  eventStats: memberEngagement.eventStats,
                ),
              );
            }

            // Always add summary as the last page
            pages.add(
              SummaryWrappedPage(
                memberEngagement: memberEngagement,
                year: year,
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
                        WrappedPageIndicator(
                              currentPage: _currentPage,
                              pageCount: pages.length,
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
                        IconButton(
                              icon: Container(
                                padding: const EdgeInsets.all(
                                  PRFSpacingTokens.sm,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () => context.router.maybePop(),
                            )
                            .animate()
                            .fadeIn(
                              delay: 2000.ms,
                              duration: PRFMotionTokens.enterShort,
                            )
                            .scale(delay: PRFMotionTokens.standard),
                  ),
                ],
              ),
            );
          },
          error: _buildErrorState,
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
                label: 'No Impact Data Yet',
                description:
                    'Start participating in missions and '
                    'activities to see your impact wrapped!',
                icon: Icons.insights_rounded,
                actionLabel: 'Go Back',
                onActionPressed: () => context.router.maybePop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
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
                label: 'Something Went Wrong',
                description: message,
                icon: Icons.error_outline_rounded,
                actionLabel: 'Try Again',
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
