import 'package:app/features/home/missions/cubit/add_soul_cubit.dart';
import 'package:app/features/home/missions/cubit/get_class_groups_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/prf_class_group.dart';
import 'package:app/widgets/_index.dart';
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
  bool _isLoading = false;

  PRFClassGroup? selectedClassGroup;

  // Add form validity check
  bool get _isFormValid {
    return selectedClassGroup != null &&
        _fullNameController.text.trim().isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    // Add listeners to update form validity
    _fullNameController.addListener(() => setState(() {}));
    _admissionNumberController.addListener(() => setState(() {}));
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),

              // Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
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
                    const SizedBox(height: 8),
                    Text(
                      l10n.recordSoul,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
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
              ).animate().slideY(begin: -0.3).fadeIn(duration: 600.ms),

              const SizedBox(height: 24),

              // Form Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
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
                    ).animate(delay: 200.ms).slideX(begin: -0.2).fadeIn(),

                    _buildFormSection(
                      icon: Icons.badge_outlined,
                      title: l10n.admissionNumber,
                      child: PRFTextInput(
                        hintText: l10n.enterAdmissionNumber,
                        controller: _admissionNumberController,
                        enabled: !_isLoading,
                      ),
                    ).animate(delay: 300.ms).slideX(begin: -0.2).fadeIn(),
                  ],
                ),
              ),

              const SizedBox(height: 24),

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
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.soulRecorded)),
                      );
                    },
                    error: (error) {
                      setState(() {
                        _isLoading = false;
                      });
                      Gaimon.error();
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(error.message)));
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
              ).animate(delay: 400.ms).slideY(begin: 0.3).fadeIn(),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormSection({
    required IconData icon,
    required String title,
    required Widget child,
    bool isRequired = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              FormFieldLabel(label: title, isRequired: isRequired),
            ],
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Future<void> _submitForm() async {
    final l10n = context.l10n;

    if (selectedClassGroup == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.selectClass)),
      );
      Gaimon.warning();
      return;
    }

    if (_fullNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.enterName)),
      );
      Gaimon.warning();
      return;
    }

    await context.read<AddSoulCubit>().addSoul(
      missionUlid: widget.missionUlid,
      classGroup: selectedClassGroup!,
      fullName: _fullNameController.text.trim(),
      admissionNumber: _admissionNumberController.text.trim(),
    );
  }
}
