import 'package:app/features/missions/_shared.dart';
import 'package:app/features/missions/cubit/school_details_resource_cubit.dart';
import 'package:app/features/missions/school_missions/_shared.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/course/prf_school.dart';
import 'package:app/models/remote/mission/prf_mission.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:app/utils/mixins/timezone_mixin.dart';
import 'package:app/utils/router/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class SchoolMissionsTablet extends StatefulWidget {
  const SchoolMissionsTablet({required this.schoolUlid, super.key});

  final String schoolUlid;

  @override
  State<SchoolMissionsTablet> createState() => _SchoolMissionsTabletState();
}

class _SchoolMissionsTabletState extends State<SchoolMissionsTablet>
    with TimezoneMixin {
  late final _form = SchoolMissionsFormState(schoolUlid: widget.schoolUlid);

  // The entrance cascade plays exactly once per screen instance.
  bool _entrancePlayed = false;

  @override
  void initState() {
    super.initState();
    _form
      ..attach(() => setState(() {}))
      ..load(context);
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<SchoolDetailsResourceCubit, ResourceState<PRFSchool>>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: SafeArea(
            child: state.maybeWhen(
              itemLoading: (_, item) {
                if (item != null) return _buildPage(context, item);
                return const Center(child: PRFCircularProgressIndicator());
              },
              itemLoaded: (school, _) => _buildPage(context, school),
              itemError: (message, _, school) {
                if (school != null) return _buildPage(context, school);
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(PRFSpacingTokens.lg),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          message,
                          style: theme.textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: PRFSpacingTokens.md),
                        FilledButton(
                          onPressed: () => _form.load(context, refresh: true),
                          child: Text(context.l10n.retry),
                        ),
                      ],
                    ),
                  ),
                );
              },
              orElse: () => const SizedBox.shrink(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPage(BuildContext context, PRFSchool school) {
    final l10n = context.l10n;
    final missions = List<PRFMission>.from(school.missions)
      ..sort((a, b) => b.startDate.compareTo(a.startDate));

    // The entrance cascade plays exactly once per screen instance; later
    // rebuilds (refresh setState) and scrolled-in cards skip it.
    final animateEntrance = !_entrancePlayed;
    _entrancePlayed = true;

    return PRFTabletSplitScaffold(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PRFTabletHeaderRow(
            title: school.name,
            onBack: () => context.router.maybePop(),
          ),
          Expanded(
            child: missions.isEmpty
                ? _buildEmptyState(context)
                : RefreshIndicator(
                    onRefresh: () async => _form.load(context, refresh: true),
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: PRFSpacingTokens.lg,
                        vertical: PRFSpacingTokens.xl,
                      ),
                      itemCount: missions.length,
                      itemBuilder: (context, index) {
                        final mission = missions[index];
                        final isLast = index == missions.length - 1;

                        return buildAnimatedTimelineEntry(
                          context: context,
                          index: index,
                          animate: animateEntrance,
                          child: TimelineMissionCard(
                            mission: mission,
                            isLast: isLast,
                            onTap: () => context.router.push(
                              MissionsDetailsRoute(
                                missionUlid: mission.ulid,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      sidePanel: PRFBrandPanel(
        children: [
          PRFPanelSectionLabel(l10n.schoolPastMissions),
          const SizedBox(height: PRFSpacingTokens.md),
          Material(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
            child: Padding(
              padding: const EdgeInsets.all(PRFSpacingTokens.lg),
              child: buildSchoolHeader(context, school),
            ),
          ),
          const SizedBox(height: PRFSpacingTokens.xxl),
          Center(
            child: Icon(
              Icons.school_outlined,
              size: 64,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: PRFSpacingTokens.md),
          Text(
            l10n.spiritualLegacy,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: PRFSpacingTokens.sm),
          Text(
            l10n.schoolLegacyBody,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: PRFColors.navy100,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: PRFEmptyView(
        label: l10n.noMissions,
        description: l10n.noPastMissionsForSchool,
      ),
    );
  }
}
