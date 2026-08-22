import 'package:app/enums/mission/prf_soul_decision_type.dart';
import 'package:app/features/missions/cubit/class_group_resource_cubit.dart';
import 'package:app/features/missions/mission_details/widgets/souls/cubit/soul_resource_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/member/prf_class_group.dart';
import 'package:app/models/remote/prayer/prf_soul.dart';
import 'package:app/models/remote/prayer/prf_soul_dto.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaimon/gaimon.dart';
import 'package:prf_design/prf_design.dart';

class SoulFormViewHandset extends StatefulWidget {
  const SoulFormViewHandset({
    required this.missionUlid,
    this.soul,
    super.key,
  });

  final String missionUlid;
  final PRFSoul? soul;

  @override
  State<SoulFormViewHandset> createState() => _SoulFormViewHandsetState();
}

class _SoulFormViewHandsetState extends State<SoulFormViewHandset> {
  final _fullNameController = TextEditingController();
  final _admissionNumberController = TextEditingController();
  final _notesController = TextEditingController();

  bool _isLoading = false;
  bool get _isEditing => widget.soul != null;

  PRFClassGroup? selectedClassGroup;
  PRFSoulDecisionType? selectedDecisionType;
  String? _initialClassGroupUlid;

  // Structured validation
  bool _showValidation = false;
  String? _fullNameError;
  String? _classGroupError;
  String? _decisionTypeError;

  bool get _isFormValid {
    return selectedClassGroup != null &&
        selectedDecisionType != null &&
        _fullNameController.text.trim().isNotEmpty;
  }

  @override
  void initState() {
    super.initState();

    if (_isEditing) {
      _fullNameController.text = widget.soul!.fullName;
      _admissionNumberController.text = widget.soul!.admissionNumber ?? '';
      _notesController.text = widget.soul!.notes ?? '';
      selectedDecisionType = widget.soul!.decisionType;
      _initialClassGroupUlid = widget.soul!.classGroup?.ulid;
    } else {
      selectedDecisionType = PRFSoulDecisionType.salvation;
    }

    _fullNameController.addListener(_onFormChanged);
    _admissionNumberController.addListener(_onFormChanged);

    context.read<ClassGroupResourceCubit>().loadAll();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _admissionNumberController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onFormChanged() {
    if (_showValidation) {
      _validateForm();
    }
    setState(() {});
  }

  void _clearErrors() {
    _fullNameError = null;
    _classGroupError = null;
    _decisionTypeError = null;
  }

  bool _validateForm() {
    _clearErrors();

    if (_fullNameController.text.trim().isEmpty) {
      _fullNameError = context.l10n.fieldRequired(context.l10n.fullName);
    }
    if (selectedClassGroup == null) {
      _classGroupError = context.l10n.fieldRequired(context.l10n.classGroup);
    }
    if (selectedDecisionType == null) {
      _decisionTypeError = context.l10n.fieldRequired(context.l10n.decisionType);
    }

    setState(() => _showValidation = true);

    return _fullNameError == null &&
        _classGroupError == null &&
        _decisionTypeError == null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(PRFSpacingTokens.lg),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEditing ? l10n.updateSoulTitle : l10n.recordSoul,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: PRFSpacingTokens.xl),

            // Decision Type
            PRFFormSection(
              icon: Icons.category,
              title: l10n.decisionType,
              isRequired: true,
              child: _buildDecisionTypeSelector(theme),
            ),

            // Class Group
            PRFFormSection(
              icon: Icons.group_outlined,
              title: l10n.classGroup,
              isRequired: true,
              child:
                  BlocBuilder<
                    ClassGroupResourceCubit,
                    ResourceState<PRFClassGroup>
                  >(
                    builder: (context, state) {
                      return state.maybeWhen(
                        orElse: () => const SizedBox.shrink(),
                        listLoading: (_) => const Center(
                          child: PRFLinearProgressIndicator(),
                        ),
                        listLoaded: (classes, _, _) {
                          // Match initial class group by ulid when editing
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
                          return PRFSearchableList<PRFClassGroup>(
                            entries: classes
                                .map(
                                  (classGroup) =>
                                      PRFSearchableListEntry<PRFClassGroup>(
                                        value: classGroup,
                                        label: classGroup.name,
                                      ),
                                )
                                .toList(),
                            onSelected: (classGroup) => setState(() {
                              selectedClassGroup = classGroup;
                              if (_showValidation) _validateForm();
                            }),
                            selection: selectedClassGroup,
                            hintText: l10n.selectClass,
                            emptyText: l10n.noClassGroupsFound,
                          );
                        },
                      );
                    },
                  ),
            ),

            // Full Name
            PRFFormSection(
              icon: Icons.person_outline,
              title: l10n.fullName,
              isRequired: true,
              child: PRFTextField(
                hintText: l10n.enterName,
                controller: _fullNameController,
                enabled: !_isLoading,
                errorText: _showValidation ? _fullNameError : null,
              ),
            ),

            // Admission Number
            PRFFormSection(
              icon: Icons.badge_outlined,
              title: l10n.admissionNumber,
              child: PRFTextField(
                hintText: l10n.enterAdmissionNumber,
                controller: _admissionNumberController,
                enabled: !_isLoading,
              ),
            ),

            // Notes
            PRFFormSection(
              icon: Icons.edit_note,
              title: l10n.note,
              child: PRFTextField(
                type: PRFTextFieldType.textArea,
                hintText: l10n.addDecisionNote,
                controller: _notesController,
                enabled: !_isLoading,
                maxLines: 6,
              ),
            ),

            const SizedBox(height: PRFSpacingTokens.xl),

            // Submit Button
            BlocConsumer<SoulResourceCubit, ResourceState<PRFSoul>>(
              listener: (context, state) {
                state.mapOrNull(
                  mutating: (_) {
                    setState(() {
                      _isLoading = true;
                    });
                  },
                  listLoaded: (_) {
                    if (!_isLoading) return;
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
                return PRFButton(
                  onPressed: _submitForm,
                  title: _isEditing ? l10n.update : l10n.record,
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
            duration: PRFMotionTokens.standard,
            padding: const EdgeInsets.symmetric(
              horizontal: PRFSpacingTokens.lg,
              vertical: PRFSpacingTokens.md,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
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

  Future<void> _submitForm() async {
    if (!_validateForm()) {
      Gaimon.warning();
      PRFSnackbar.error(
        context,
        context.l10n.fixHighlightedFields,
      );
      return;
    }

    final dto = PRFSoulDTO(
      missionUlid: widget.missionUlid,
      classGroupUlid: selectedClassGroup!.ulid,
      fullName: _fullNameController.text.trim(),
      admissionNumber: _admissionNumberController.text.trim(),
      decisionType: selectedDecisionType!.apiKey,
      notes: _notesController.text.trim(),
    );

    if (_isEditing) {
      await context.read<SoulResourceCubit>().updateSoul(
        ulid: widget.soul!.ulid,
        data: dto,
      );
    } else {
      await context.read<SoulResourceCubit>().createSoul(data: dto);
    }
  }
}
