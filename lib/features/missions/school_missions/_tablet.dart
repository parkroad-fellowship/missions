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

class SchoolMissionsTablet extends StatefulWidget {
  const SchoolMissionsTablet({required this.schoolUlid, super.key});

  final String schoolUlid;

  @override
  State<SchoolMissionsTablet> createState() => _SchoolMissionsTabletState();
}

class _SchoolMissionsTabletState extends State<SchoolMissionsTablet>
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
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child:
            BlocBuilder<SchoolDetailsResourceCubit, ResourceState<PRFSchool>>(
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
                              onPressed: () =>
                                  _form.load(context, refresh: true),
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
      ),
    );
  }

  Widget _buildPage(BuildContext context, PRFSchool school) {
    final theme = Theme.of(context);
    final missions = List<PRFMission>.from(school.missions)
      ..sort((a, b) => b.startDate.compareTo(a.startDate));

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left Column - Past missions list (flex: 3)
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: PRFSpacingTokens.lg,
                      vertical: PRFSpacingTokens.lg,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => context.router.maybePop(),
                        ),
                        const SizedBox(width: PRFSpacingTokens.xs),
                        Expanded(
                          child: Text(
                            school.name,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: missions.isEmpty
                        ? _buildEmptyState(context)
                        : RefreshIndicator(
                            onRefresh: () async =>
                                _form.load(context, refresh: true),
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

                                return TimelineMissionCard(
                                      mission: mission,
                                      isLast: isLast,
                                      onTap: () => context.router.push(
                                        MissionsDetailsRoute(
                                          missionUlid: mission.ulid,
                                        ),
                                      ),
                                    )
                                    .animate()
                                    .fadeIn(
                                      delay: Duration(
                                        milliseconds: index * 100,
                                      ),
                                      duration: PRFMotionTokens.enterShort,
                                    )
                                    .slideX(
                                      begin: 0.3,
                                      end: 0,
                                      curve: Curves.easeOutCubic,
                                    );
                              },
                            ),
                          ),
                  ),
                ],
              ),
            ),

            // Vertical Divider
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: theme.colorScheme.outline.withValues(alpha: 0.12),
            ),

            // Right Column - School Summary Panel & Guidance Sidebar (flex: 2)
            Expanded(
              flex: 2,
              child: Container(
                margin: const EdgeInsets.all(PRFSpacingTokens.lg),
                padding: const EdgeInsets.all(PRFSpacingTokens.xl),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.12),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'School Past Missions',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: PRFSpacingTokens.xl),

                    // School card summary
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(PRFSpacingTokens.xl),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
                      ),
                      child: buildSchoolHeader(context, school),
                    ),

                    const Spacer(),

                    // Helpful advice card
                    Center(
                      child: Icon(
                        Icons.school_outlined,
                        size: 64,
                        color: theme.colorScheme.primary.withValues(alpha: 0.5),
                      ),
                    ),
                    const SizedBox(height: PRFSpacingTokens.md),
                    Text(
                      'Spiritual Legacy',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: PRFSpacingTokens.sm),
                    Text(
                      'Explore all historical missions carried out by PRF at this school. Touch lives, follow up with student enquiries, and review past statistics.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
