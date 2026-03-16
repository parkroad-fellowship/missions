import 'package:app/enums/mission/prf_soul_decision_type.dart';
import 'package:app/features/home/missions/cubit/get_class_groups_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/souls/cubit/add_soul_cubit.dart';
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

  // Add form validity check
  bool get _isFormValid {
    return selectedClassGroup != null &&
        selectedDecisionType != null &&
        _fullNameController.text.trim().isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    // Add listeners to update form validity
    _fullNameController.addListener(() => setState(() {}));
    _admissionNumberController.addListener(() => setState(() {}));

    // Have salvation selected by default
    selectedDecisionType = PRFSoulDecisionType.salvation;

    context.read<GetClassGroupsCubit>().getClassGroups(
      missionUlid: widget.missionUlid,
    );
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
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onPrimary.withValues(alpha: 0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ).animate().slideY(begin: -0.3).fadeIn(duration: PRFMotionTokens.enterShort),

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
                    _buildFormSection(
                      icon: Icons.category,
                      title: l10n.decisionType,
                      isRequired: true,
                      child: _buildDecisionTypeSelector(Theme.of(context)),
                    ).animate(delay: 100.ms).slideX(begin: -0.2).fadeIn(),
                    _buildFormSection(
                      icon: Icons.group_outlined,
                      title: l10n.classGroup,
                      isRequired: true,
                      child:
                          BlocBuilder<GetClassGroupsCubit, GetClassGroupsState>(
                            builder: (context, state) {
                              return state.maybeWhen(
                                orElse: () => const SizedBox.shrink(),
                                loading: () => const Center(
                                  child: LinearProgressIndicator(),
                                ),
                                loaded: (classes) => LayoutBuilder(
                                  builder: (context, constraints) {
                                    return DropdownMenu<PRFClassGroup>(
                                      width: constraints.maxWidth,
                                      initialSelection: selectedClassGroup,
                                      hintText: l10n.selectClass,
                                      dropdownMenuEntries: classes
                                          .map(
                                            (classGroup) =>
                                                DropdownMenuEntry<
                                                  PRFClassGroup
                                                >(
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
                                ),
                              );
                            },
                          ),
                    ).animate(delay: 100.ms).slideX(begin: -0.2).fadeIn(),

                    _buildFormSection(
                      icon: Icons.person_outline,
                      title: l10n.fullName,
                      isRequired: true,
                      child: PRFNameInput(
                        hintText: l10n.enterName,
                        controller: _fullNameController,
                        enabled: !_isLoading,
                      ),
                    ).animate(delay: PRFMotionTokens.standard).slideX(begin: -0.2).fadeIn(),

                    _buildFormSection(
                      icon: Icons.badge_outlined,
                      title: l10n.admissionNumber,
                      child: PRFTextInput(
                        hintText: l10n.enterAdmissionNumber,
                        controller: _admissionNumberController,
                        enabled: !_isLoading,
                      ),
                    ).animate(delay: PRFMotionTokens.slow).slideX(begin: -0.2).fadeIn(),

                    _buildFormSection(
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
              BlocConsumer<AddSoulCubit, AddSoulState>(
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
                    title: l10n.record,
                    disabled: !_isFormValid,
                    isLoading: _isLoading,
                  );
                },
              ).animate(delay: PRFMotionTokens.slow).slideY(begin: 0.3).fadeIn(),

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
            padding: const EdgeInsets.symmetric(horizontal: PRFSpacingTokens.lg, vertical: PRFSpacingTokens.md),
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

  Widget _buildFormSection({
    required IconData icon,
    required String title,
    required Widget child,
    bool isRequired = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: PRFSpacingTokens.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(PRFSpacingTokens.sm),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(PRFRadiusTokens.sm),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: PRFSpacingTokens.md),
              FormFieldLabel(label: title, isRequired: isRequired),
            ],
          ),
          const SizedBox(height: PRFSpacingTokens.sm),
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

    await context.read<AddSoulCubit>().addSoul(
      missionUlid: widget.missionUlid,
      classGroup: selectedClassGroup!,
      fullName: _fullNameController.text.trim(),
      admissionNumber: _admissionNumberController.text.trim(),
      decisionType: selectedDecisionType!,
      notes: _notesController.text.trim(),
    );
  }
}
