import 'package:app/features/home/missions/mission_details/widgets/souls/cubit/soul_resource_cubit.dart';
import 'package:app/models/remote/prayer/prf_soul.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:app/enums/mission/prf_soul_decision_type.dart';
import 'package:app/features/home/missions/cubit/class_group_resource_cubit.dart';

import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/member/prf_class_group.dart';
import 'package:prf_design/prf_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaimon/gaimon.dart';

class AddSoulViewHandset extends StatefulWidget {
  const AddSoulViewHandset({required this.missionUlid, super.key});

  final String missionUlid;

  @override
  State<AddSoulViewHandset> createState() => _AddSoulViewHandsetState();
}

class _AddSoulViewHandsetState extends State<AddSoulViewHandset> {
  final _fullNameController = TextEditingController();
  final _admissionNumberController = TextEditingController();
  final _notesController = TextEditingController();

  bool _isLoading = false;

  PRFClassGroup? selectedClassGroup;
  PRFSoulDecisionType? selectedDecisionType;

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
    _fullNameController.addListener(_onFormChanged);
    _admissionNumberController.addListener(_onFormChanged);

    // Have salvation selected by default
    selectedDecisionType = PRFSoulDecisionType.salvation;

    context.read<ClassGroupResourceCubit>().loadAll(
      filters: {'mission_ulid': widget.missionUlid},
    );
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
      _fullNameError = 'Full name is required';
    }
    if (selectedClassGroup == null) {
      _classGroupError = 'Class group is required';
    }
    if (selectedDecisionType == null) {
      _decisionTypeError = 'Decision type is required';
    }

    setState(() => _showValidation = true);

    return _fullNameError == null &&
        _classGroupError == null &&
        _decisionTypeError == null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
            Theme.of(context).colorScheme.surface,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: PRFSpacingTokens.lg),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: PRFSpacingTokens.lg),

              // Header Card
              Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(PRFSpacingTokens.xl),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.person_add_outlined,
                          size: 32,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        const SizedBox(height: PRFSpacingTokens.sm),
                        Text(
                          l10n.recordSoul,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: PRFSpacingTokens.xs),
                        Text(
                          l10n.addSoulSubTitle,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimary.withValues(alpha: 0.9),
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                  .animate()
                  .slideY(begin: -0.3)
                  .fadeIn(duration: PRFMotionTokens.enterShort),

              const SizedBox(height: PRFSpacingTokens.xl),

              // Form Card
              Container(
                padding: const EdgeInsets.all(PRFSpacingTokens.xl),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.shadow.withValues(alpha: 0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    PRFFormSection(
                      icon: Icons.category,
                      title: l10n.decisionType,
                      isRequired: true,
                      child: _buildDecisionTypeSelector(Theme.of(context)),
                    ).animate(delay: 100.ms).slideX(begin: -0.2).fadeIn(),
                    PRFFormSection(
                      icon: Icons.group_outlined,
                      title: l10n.classGroup,
                      isRequired: true,
                      child:
                          BlocBuilder<ClassGroupResourceCubit, ResourceState<PRFClassGroup>>(
                            builder: (context, state) {
                              return state.maybeWhen(
                                orElse: () => const SizedBox.shrink(),
                                listLoading: () => const Center(
                                  child: LinearProgressIndicator(),
                                ),
                                listLoaded: (classes, _, __) =>
                                    PRFSearchableList<PRFClassGroup>(
                                      entries: classes
                                          .map(
                                            (classGroup) =>
                                                PRFSearchableListEntry<
                                                  PRFClassGroup
                                                >(
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
                                      emptyText: 'No class groups found',
                                    ),
                              );
                            },
                          ),
                    ).animate(delay: 100.ms).slideX(begin: -0.2).fadeIn(),

                    PRFFormSection(
                          icon: Icons.person_outline,
                          title: l10n.fullName,
                          isRequired: true,
                          child: PRFTextInput(
                            hintText: l10n.enterName,
                            controller: _fullNameController,
                            enabled: !_isLoading,
                            errorText: _showValidation ? _fullNameError : null,
                          ),
                        )
                        .animate(delay: PRFMotionTokens.standard)
                        .slideX(begin: -0.2)
                        .fadeIn(),

                    PRFFormSection(
                          icon: Icons.badge_outlined,
                          title: l10n.admissionNumber,
                          child: PRFTextInput(
                            hintText: l10n.enterAdmissionNumber,
                            controller: _admissionNumberController,
                            enabled: !_isLoading,
                          ),
                        )
                        .animate(delay: PRFMotionTokens.slow)
                        .slideX(begin: -0.2)
                        .fadeIn(),

                    PRFFormSection(
                      icon: Icons.edit_note,
                      title: l10n.note,
                      child: PRFTextAreaInput(
                        hintText: l10n.addDecisionNote,
                        controller: _notesController,
                        enabled: !_isLoading,
                        maxLines: 6,
                      ),
                    ).animate(delay: 100.ms).slideX(begin: -0.2).fadeIn(),
                  ],
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
                        mutated: (_) {
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
                        title: l10n.record,
                        disabled: !_isFormValid,
                        isLoading: _isLoading,
                      );
                    },
                  )
                  .animate(delay: PRFMotionTokens.slow)
                  .slideY(begin: 0.3)
                  .fadeIn(),

              const SizedBox(height: PRFSpacingTokens.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDecisionTypeSelector(
    ThemeData theme,
  ) {
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
        'Please fix the highlighted fields and try again.',
      );
      return;
    }

    await context.read<SoulResourceCubit>().createSoul(
      data: {
        'mission_ulid': widget.missionUlid,
        'class_group_ulid': selectedClassGroup!.ulid,
        'full_name': _fullNameController.text.trim(),
        'admission_number': _admissionNumberController.text.trim(),
        'decision_type': selectedDecisionType!.apiKey,
        'notes': _notesController.text.trim(),
      },
    );
  }
}
