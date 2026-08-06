import 'package:app/enums/mission/prf_mission_ground_suggestion_status.dart';
import 'package:app/features/missions/mission_ground_suggestions/actions/add_mission_ground_suggestion/add_mission_ground_suggestion.dart';
import 'package:app/features/missions/mission_ground_suggestions/actions/update_mission_ground_suggestion/update_mission_ground_suggestion.dart';
import 'package:app/features/missions/mission_ground_suggestions/cubit/ground_suggestion_resource_cubit.dart';
import 'package:app/l10n/arb/app_localizations.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/mission/prf_mission_ground_suggestion.dart';
import 'package:app/utils/helpers/permission_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class GroundSuggestionsFormState {
  GroundSuggestionsFormState();

  void attach(VoidCallback rebuild) {}

  void load(BuildContext context) {
    context.read<GroundSuggestionResourceCubit>().loadAll();
  }

  void dispose() {}
}

class SuggestionStatPill extends StatelessWidget {
  const SuggestionStatPill({
    required this.label,
    required this.value,
    super.key,
  });

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: PRFSpacingTokens.md,
        vertical: PRFSpacingTokens.xs,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$value ',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextSpan(
              text: label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onPrimary.withValues(alpha: 0.85),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildSuggestionsHeader(
  BuildContext context,
  ThemeData theme,
  AppLocalizations l10n,
  int total,
  int pending,
  int completed,
  VoidCallback onBack,
) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          theme.colorScheme.primary,
          theme.colorScheme.primary.withValues(alpha: 0.88),
        ],
      ),
    ),
    child: Column(
      children: [
        PRFBrandedNavBar(
          title: l10n.suggestAMission,
          onBack: onBack,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            PRFSpacingTokens.lg,
            PRFSpacingTokens.xs,
            PRFSpacingTokens.lg,
            PRFSpacingTokens.lg,
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(PRFSpacingTokens.md),
            decoration: BoxDecoration(
              color: theme.colorScheme.onPrimary.withValues(
                alpha: 0.1,
              ),
              borderRadius: BorderRadius.circular(
                PRFRadiusTokens.lg,
              ),
              border: Border.all(
                color: theme.colorScheme.onPrimary.withValues(
                  alpha: 0.15,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.suggestMissionSubTitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onPrimary.withValues(
                      alpha: 0.9,
                    ),
                  ),
                ),
                const SizedBox(height: PRFSpacingTokens.md),
                Wrap(
                  spacing: PRFSpacingTokens.xs,
                  runSpacing: PRFSpacingTokens.xs,
                  children: [
                    SuggestionStatPill(
                      label: l10n.total,
                      value: total,
                    ),
                    SuggestionStatPill(
                      label: PRFMissionGroundSuggestionStatus.pending.name,
                      value: pending,
                    ),
                    SuggestionStatPill(
                      label: l10n.completed,
                      value: completed,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

void triggerAddSuggestion(BuildContext context) {
  PRFBottomSheet.show<void>(
    context,
    title: context.l10n.suggestAMission,
    child: const AddMissionGroundSuggestionView(),
  ).then((_) {
    // Refresh list
    context.read<GroundSuggestionResourceCubit>().loadAll();
  });
}

Future<void> triggerUpdateSuggestion(
  BuildContext context,
  PRFMissionGroundSuggestion suggestion,
) async {
  if (!PermissionHelper.userCan('edit mission ground suggestion')) {
    return;
  }

  await PRFBottomSheet.show<void>(
    context,
    title: context.l10n.editMissionSuggestion,
    child: UpdateMissionGroundSuggestionView(
      missionGroundSuggestion: suggestion,
    ),
  ).then((_) {
    context.read<GroundSuggestionResourceCubit>().loadAll();
  });
}
