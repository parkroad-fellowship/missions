import 'package:app/features/missions/mission_details/widgets/record_sections.dart';
import 'package:app/features/missions/mission_details/widgets/souls/actions/soul_form/soul_form.dart';
import 'package:app/features/missions/mission_details/widgets/souls/cubit/soul_resource_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/prayer/prf_soul.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:app/utils/mixins/timezone_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class SoulsViewHandset extends StatefulWidget {
  const SoulsViewHandset({required this.missionUlid, super.key});

  final String missionUlid;

  @override
  State<SoulsViewHandset> createState() => _SoulsViewHandsetState();
}

class _SoulsViewHandsetState extends State<SoulsViewHandset>
    with TimezoneMixin {
  String get missionUlid => widget.missionUlid;

  Future<void> _showAddSoulSheet() {
    return PRFBottomSheet.show<void>(
      context,
      title: context.l10n.recordSoul,
      child: SoulFormView(missionUlid: missionUlid),
    );
  }

  Future<void> _showEditSoulSheet(PRFSoul soul) {
    return PRFBottomSheet.show<void>(
      context,
      title: context.l10n.edit,
      child: SoulFormView(
        missionUlid: missionUlid,
        soul: soul,
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

    return BlocBuilder<SoulResourceCubit, ResourceState<PRFSoul>>(
      builder: (context, state) {
        final souls = state.maybeWhen(
          listLoaded: (items, _, _) => items,
          mutating: (items, _) => items,
          mutated: (items, _, _) => items,
          error: (_, items) => items,
          orElse: () => <PRFSoul>[],
        );

        return MissionResourceTabView(
          sectionTitle: 'Souls',
          addButtonLabel: l10n.recordSoul,
          addButtonIcon: Icons.favorite_outline,
          emptyLabel: l10n.noSouls,
          emptyDescription: l10n.noSoulsDesc,
          isLoading: state.maybeWhen(
            listLoading: (_) => true,
            orElse: () => false,
          ),
          error: state.mapOrNull(error: (e) => e.message),
          isEmpty: souls.isEmpty,
          onRefresh: () => context.read<SoulResourceCubit>().loadAll(
            filters: {'mission_ulid': missionUlid},
          ),
          onAdd: _showAddSoulSheet,
          items: [
            for (int index = 0; index < souls.length; index++)
              MissionResourceCard(
                    title: souls[index].fullName,
                    subtitle: souls[index].notes?.trim().isNotEmpty ?? false
                        ? souls[index].notes
                        : 'Captured ${DateFormatter.formatDateTime(souls[index].createdAt, timezone)}',
                    editTooltip: 'Edit soul',
                    onEdit: () => _showEditSoulSheet(souls[index]),
                    deleteTooltip: 'Delete soul',
                    onDelete: () => _deleteSoul(souls[index]),
                  )
                  .animate(delay: (index * 100).ms)
                  .fadeIn()
                  .slideX(begin: -0.3, end: 0),
          ],
        );
      },
    );
  }
}
