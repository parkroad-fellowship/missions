import 'package:app/enums/mission/prf_soul_decision_type.dart';
import 'package:app/features/home/missions/mission_details/widgets/souls/actions/add_soul/add_soul.dart';
import 'package:app/features/home/missions/mission_details/widgets/souls/actions/update_soul/update_soul.dart';
import 'package:app/features/home/missions/mission_details/widgets/souls/cubit/soul_resource_cubit.dart';
import 'package:app/l10n/arb/app_localizations.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/prayer/prf_soul.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:prf_design/prf_design.dart';

class SoulsViewHandset extends StatefulWidget {
  const SoulsViewHandset({required this.missionUlid, super.key});

  final String missionUlid;

  @override
  State<SoulsViewHandset> createState() => _SoulsViewHandsetState();
}

class _SoulsViewHandsetState extends State<SoulsViewHandset> {
  String get missionUlid => widget.missionUlid;

  Future<void> _showAddSoulSheet() {
    return PRFBottomSheet.show<void>(
      context,
      title: context.l10n.recordSoul,
      child: AddSoulView(missionUlid: missionUlid),
    );
  }

  Future<void> _showEditSoulSheet(PRFSoul soul) {
    return PRFBottomSheet.show<void>(
      context,
      title: context.l10n.edit,
      child: UpdateSoulView(
        soul: soul,
        missionUlid: missionUlid,
      ),
    );
  }

  Future<void> _deleteSoul(PRFSoul soul) async {
    final shouldDelete = await PRFConfirmationDialog.show(
      context,
      title: '${context.l10n.delete} ${context.l10n.souls}',
      message: 'Are you sure you want to continue?',
      confirmLabel: context.l10n.delete,
      isDestructive: true,
    );

    if (shouldDelete != true || !mounted) return;

    await context.read<SoulResourceCubit>().deleteSoul(soul.ulid);
    if (!mounted) return;

    final error = context.read<SoulResourceCubit>().state.mapOrNull(
      error: (state) => state.message,
    );
    if (error != null) {
      PRFSnackbar.error(context, error);
      return;
    }
    PRFSnackbar.success(context, 'Soul deleted');
  }

  @override
  void initState() {
    context.read<SoulResourceCubit>().loadAll(
      filters: {'mission_ulid': missionUlid},
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(
            PRFSpacingTokens.lg,
            PRFSpacingTokens.sm,
            PRFSpacingTokens.lg,
            PRFSpacingTokens.md,
          ),
          padding: const EdgeInsets.all(PRFSpacingTokens.md),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: PRFPrimaryButton(
            onPressed: _showAddSoulSheet,
            title: l10n.recordSoul,
            disabled: false,
          ),
        ),
        Expanded(
          child: BlocBuilder<SoulResourceCubit, ResourceState<PRFSoul>>(
            builder: (context, state) {
              return state.maybeWhen(
                listLoading: () => const Center(
                  child: PRFCircularProgressIndicator(),
                ),
                listLoaded: (souls, _, _) {
                  if (souls.isEmpty) {
                    return Center(
                      child: PRFEmptyView(
                        label: l10n.noSouls,
                        description: l10n.noSoulsDesc,
                        icon: Icons.people_outline_rounded,
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () => context.read<SoulResourceCubit>().loadAll(
                      filters: {'mission_ulid': missionUlid},
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 64),
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          vertical: PRFSpacingTokens.lg,
                        ),
                        itemCount: souls.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 0),
                        itemBuilder: (context, index) =>
                            BeautifulSoulCard(
                                  soul: souls[index],
                                  index: index,
                                  onEdit: () => _showEditSoulSheet(
                                    souls[index],
                                  ),
                                  onDelete: () => _deleteSoul(
                                    souls[index],
                                  ),
                                )
                                .animate(delay: (index * 100).ms)
                                .fadeIn()
                                .slideX(begin: -0.3, end: 0),
                      ),
                    ),
                  );
                },
                error: (message, _) => Center(
                  child: PRFEmptyView(
                    label: l10n.noSouls,
                    description: message,
                    icon: Icons.people_outline_rounded,
                  ),
                ),
                orElse: () => const SizedBox.shrink(),
              );
            },
          ),
        ),
      ],
    );
  }
}

class BeautifulSoulCard extends StatelessWidget {
  const BeautifulSoulCard({
    required this.soul,
    required this.index,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final PRFSoul soul;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(PRFSpacingTokens.xl),
      margin: const EdgeInsets.symmetric(
        horizontal: PRFSpacingTokens.lg,
        vertical: PRFSpacingTokens.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
        boxShadow: PRFShadowTokens.card(theme.colorScheme.shadow),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: .1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with avatar and name
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(PRFSpacingTokens.md),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
                ),
                child: _buildAvatarIcon(theme),
              ),
              const SizedBox(width: PRFSpacingTokens.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      soul.fullName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: PRFSpacingTokens.xs),
              // Decision Type Badge
              _buildDecisionTypeBadge(theme),
            ],
          ),
          const SizedBox(height: PRFSpacingTokens.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 72,
                child: PRFSecondaryButton(
                  onPressed: onEdit,
                  title: context.l10n.edit,
                  disabled: false,
                ),
              ),
              const SizedBox(width: PRFSpacingTokens.xs),
              SizedBox(
                width: 76,
                child: PRFDestroyButton(
                  onPressed: onDelete,
                  title: context.l10n.delete,
                  disabled: false,
                ),
              ),
            ],
          ),

          const SizedBox(height: PRFSpacingTokens.lg),

          // Additional Information Section
          _buildAdditionalInfo(theme, l10n),

          // Notes Section (if available)
          if (soul.notes != null && soul.notes!.isNotEmpty) ...[
            const SizedBox(height: PRFSpacingTokens.md),
            _buildNotesSection(theme),
          ],

          // Date Information
          const SizedBox(height: PRFSpacingTokens.md),
          _buildDateInfo(theme),
        ],
      ),
    ).animate(effects: const [SaturateEffect()]);
  }

  Widget _buildAvatarIcon(ThemeData theme) {
    final initials = StringFormatter.getUserNameInitials(soul.fullName);

    return Text(
      initials,
      style: theme.textTheme.titleMedium?.copyWith(
        color: theme.colorScheme.onPrimaryContainer,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildDecisionTypeBadge(ThemeData theme) {
    final decisionColor = _getDecisionTypeColor(theme);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: PRFSpacingTokens.sm,
        vertical: PRFSpacingTokens.xs,
      ),
      decoration: BoxDecoration(
        color: decisionColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
        border: Border.all(
          color: decisionColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getDecisionTypeIcon(),
            size: 14,
            color: decisionColor,
          ),
          const SizedBox(width: PRFSpacingTokens.xs),
          Text(
            soul.decisionType.name,
            style: theme.textTheme.bodySmall?.copyWith(
              color: decisionColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfo(ThemeData theme, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(PRFSpacingTokens.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildInfoItem(
              theme,
              l10n.classGroup,
              soul.classGroup?.name ?? 'N/A',
              Icons.class_rounded,
            ),
          ),
          if (soul.admissionNumber != null &&
              soul.admissionNumber!.isNotEmpty) ...[
            const SizedBox(width: PRFSpacingTokens.lg),
            Expanded(
              child: _buildInfoItem(
                theme,
                l10n.admissionNumber,
                soul.admissionNumber!,
                Icons.badge,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 14,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: PRFSpacingTokens.xs),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(PRFSpacingTokens.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
        border: Border.all(
          color: theme.colorScheme.secondary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.note_alt,
                size: 14,
                color: theme.colorScheme.secondary,
              ),
              const SizedBox(width: PRFSpacingTokens.xs),
              Text(
                'Notes',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: PRFSpacingTokens.xs),
          Text(
            soul.notes!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDateInfo(ThemeData theme) {
    final formattedDate = DateFormat(
      'MMM dd, yyyy • HH:mm',
    ).format(soul.createdAt);

    return Row(
      children: [
        Icon(
          Icons.access_time,
          size: 14,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: PRFSpacingTokens.xs),
        Text(
          'Recorded: $formattedDate',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Color _getDecisionTypeColor(ThemeData theme) {
    switch (soul.decisionType) {
      case PRFSoulDecisionType.salvation:
        return theme.colorScheme.tertiary;
      case PRFSoulDecisionType.rededication:
        return theme.colorScheme.secondary;
      case PRFSoulDecisionType.camp:
        return theme.colorScheme.primary;
      case PRFSoulDecisionType.prayer:
        return theme.colorScheme.primaryContainer;
      case PRFSoulDecisionType.other:
        return theme.colorScheme.outline;
    }
  }

  IconData _getDecisionTypeIcon() {
    switch (soul.decisionType) {
      case PRFSoulDecisionType.salvation:
        return Icons.favorite;
      case PRFSoulDecisionType.rededication:
        return Icons.refresh;
      case PRFSoulDecisionType.camp:
        return Icons.house_rounded;
      case PRFSoulDecisionType.prayer:
        return Icons.back_hand_rounded;
      case PRFSoulDecisionType.other:
        return Icons.more_horiz;
    }
  }
}
