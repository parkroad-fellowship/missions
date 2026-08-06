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
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class SchoolMissionsHandset extends StatefulWidget {
  const SchoolMissionsHandset({required this.schoolUlid, super.key});

  final String schoolUlid;

  @override
  State<SchoolMissionsHandset> createState() => _SchoolMissionsHandsetState();
}

class _SchoolMissionsHandsetState extends State<SchoolMissionsHandset>
    with TimezoneMixin {
  late final _form = SchoolMissionsFormState(schoolUlid: widget.schoolUlid);

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

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: BlocBuilder<SchoolDetailsResourceCubit, ResourceState<PRFSchool>>(
        builder: (context, state) {
          return state.maybeWhen(
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
          );
        },
      ),
    );
  }

  Widget _buildPage(BuildContext context, PRFSchool school) {
    final missions = List<PRFMission>.from(school.missions)
      ..sort((a, b) => b.startDate.compareTo(a.startDate));

    return Column(
      children: [
        PRFBrandedNavBar(
          title: school.name,
          onBack: () => context.router.maybePop(),
        ),
        Expanded(
          child: missions.isEmpty
              ? _buildEmptyState(context)
              : RefreshIndicator(
                  onRefresh: () async => _form.load(context, refresh: true),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(
                      PRFSpacingTokens.lg,
                      PRFSpacingTokens.sm,
                      PRFSpacingTokens.lg,
                      PRFSpacingTokens.xl,
                    ),
                    children: [
                      buildSchoolHeader(context, school),
                      const SizedBox(height: PRFSpacingTokens.md),
                      ...missions.asMap().entries.map((entry) {
                        final index = entry.key;
                        final mission = entry.value;
                        final isLast = index == missions.length - 1;

                        return TimelineMissionCard(
                              mission: mission,
                              isLast: isLast,
                              onTap: () => context.router.push(
                                MissionsDetailsRoute(missionUlid: mission.ulid),
                              ),
                            )
                            .animate()
                            .fadeIn(
                              delay: Duration(milliseconds: index * 100),
                              duration: PRFMotionTokens.enterShort,
                            )
                            .slideX(
                              begin: 0.3,
                              end: 0,
                              curve: Curves.easeOutCubic,
                            );
                      }),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: PRFEmptyView(
        label: l10n.noMissions,
        description: 'No past missions for this school.',
      ),
    );
  }
}
