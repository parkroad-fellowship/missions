import 'package:app/enums/mission/prf_soul_decision_type.dart';
import 'package:app/features/home/missions/cubit/get_class_groups_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/souls/cubit/update_soul_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/mission/prf_soul.dart';
import 'package:app/models/remote/member/prf_class_group.dart';
import 'package:app/shared_widgets/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaimon/gaimon.dart';

class UpdateSoulViewHandset extends StatefulWidget {
  const UpdateSoulViewHandset({
    required this.soul,
    required this.missionUlid,
    super.key,
  });

  final PRFLocalSoul soul;
  final String missionUlid;

  @override
  State<UpdateSoulViewHandset> createState() => _UpdateSoulViewHandsetState();
}

class _UpdateSoulViewHandsetState extends State<UpdateSoulViewHandset> {
  final _fullNameController = TextEditingController();
  final _admissionNumberController = TextEditingController();
  final _notesController = TextEditingController();

  bool _isLoading = false;

  PRFClassGroup? selectedClassGroup;
  PRFSoulDecisionType? selectedDecisionType;
  String? _initialClassGroupUlid;

  bool get _isFormValid {
    return selectedClassGroup != null &&
        selectedDecisionType != null &&
        _fullNameController.text.trim().isNotEmpty;
  }

  @override
  void initState() {
    super.initState();

    // Pre-populate fields with existing soul data
    _fullNameController.text = widget.soul.fullName;
    _admissionNumberController.text = widget.soul.admissionNumber ?? '';
    _notesController.text = widget.soul.notes ?? '';
    selectedDecisionType = widget.soul.decisionType;
    _initialClassGroupUlid = widget.soul.classGroup.ulid;

    _fullNameController.addListener(() => setState(() {}));
    _admissionNumberController.addListener(() => setState(() {}));

    context.read<GetClassGroupsCubit>().getClassGroups(
      missionUlid: widget.missionUlid,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Update Soul',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 24),

            // Decision Type
            _buildFormSection(
              title: l10n.decisionType,
              isRequired: true,
              child: _buildDecisionTypeSelector(theme),
            ),

            // Class Group
            _buildFormSection(
              title: l10n.classGroup,
              isRequired: true,
              child: BlocBuilder<GetClassGroupsCubit, GetClassGroupsState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    orElse: () => const SizedBox.shrink(),
                    loading: () => const Center(
                      child: LinearProgressIndicator(),
                    ),
                    loaded: (classes) {
                      // Match initial class group by ulid
                      if (selectedClassGroup == null &&
                          _initialClassGroupUlid != null) {
                        final match = classes
                            .where(
                              (c) => c.ulid == _initialClassGroupUlid,
                            )
                            .firstOrNull;
                        if (match != null) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            setState(() {
                              selectedClassGroup = match;
                            });
                          });
                        }
                      }
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          return DropdownMenu<PRFClassGroup>(
                            width: constraints.maxWidth,
                            initialSelection: selectedClassGroup,
                            hintText: l10n.selectClass,
                            dropdownMenuEntries: classes
                                .map(
                                  (classGroup) =>
                                      DropdownMenuEntry<PRFClassGroup>(
                                        value: classGroup,
                                        label: classGroup.name,
                                      ),
                                )
                                .toList(),
                            onSelected: (classGroup) => setState(() {
                              selectedClassGroup = classGroup;
                            }),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),

            // Full Name
            _buildFormSection(
              title: l10n.fullName,
              isRequired: true,
              child: PRFNameInput(
                hintText: l10n.enterName,
                controller: _fullNameController,
                enabled: !_isLoading,
              ),
            ),

            // Admission Number
            _buildFormSection(
              title: l10n.admissionNumber,
              child: PRFTextInput(
                hintText: l10n.enterAdmissionNumber,
                controller: _admissionNumberController,
                enabled: !_isLoading,
              ),
            ),

            // Notes
            _buildFormSection(
              title: l10n.note,
              child: PRFTextAreaInput(
                hintText: l10n.addDecisionNote,
                controller: _notesController,
                enabled: !_isLoading,
                maxLines: 6,
              ),
            ),

            const SizedBox(height: 24),

            // Submit Button
            BlocConsumer<UpdateSoulCubit, UpdateSoulState>(
              listener: (context, state) {
                state.mapOrNull(
                  loading: (_) {
                    setState(() {
                      _isLoading = true;
                    });
                  },
                  loaded: (_) {
                    setState(() {
                      _isLoading = false;
                    });
                    Gaimon.success();
                    Navigator.of(context).pop();
                    PRFSnackbar.success(context, l10n.soulRecorded);
                  },
                  error: (error) {
                    setState(() {
                      _isLoading = false;
                    });
                    Gaimon.error();
                    PRFSnackbar.error(context, error.message);
                  },
                );
              },
              builder: (context, state) {
                return PRFPrimaryButton(
                  onPressed: _submitForm,
                  title: 'Update',
                  disabled: !_isFormValid,
                  isLoading: _isLoading,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDecisionTypeSelector(ThemeData theme) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: PRFSoulDecisionType.values.map((decisionType) {
        final isSelected = selectedDecisionType == decisionType;
        return GestureDetector(
          onTap: () => setState(() => selectedDecisionType = decisionType),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              decisionType.name,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFormSection({
    required String title,
    required Widget child,
    bool isRequired = false,
  }) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(
            alpha: 0.06,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              if (isRequired)
                Text(
                  ' *',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Future<void> _submitForm() async {
    final l10n = context.l10n;

    if (selectedClassGroup == null) {
      PRFSnackbar.warning(context, l10n.selectClass);
      Gaimon.warning();
      return;
    }

    if (selectedDecisionType == null) {
      PRFSnackbar.warning(context, l10n.selectDecisionType);
      Gaimon.warning();
      return;
    }

    if (_fullNameController.text.trim().isEmpty) {
      PRFSnackbar.warning(context, l10n.enterName);
      Gaimon.warning();
      return;
    }

    await context.read<UpdateSoulCubit>().updateSoul(
      soulUlid: widget.soul.ulid,
      missionUlid: widget.missionUlid,
      classGroupUlid: selectedClassGroup!.ulid,
      fullName: _fullNameController.text.trim(),
      decisionType: selectedDecisionType!.apiKey,
      notes: _notesController.text.trim(),
      admissionNumber: _admissionNumberController.text.trim(),
    );
  }
}
