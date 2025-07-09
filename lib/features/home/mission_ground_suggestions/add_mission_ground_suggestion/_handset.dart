import 'package:app/features/home/mission_ground_suggestions/cubit/add_mission_ground_suggestion_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/widgets/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaimon/gaimon.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class AddMissionGroundSuggestionViewHandset extends StatefulWidget {
  const AddMissionGroundSuggestionViewHandset({super.key});

  @override
  State<AddMissionGroundSuggestionViewHandset> createState() =>
      _AddMissionGroundSuggestionViewHandsetState();
}

class _AddMissionGroundSuggestionViewHandsetState
    extends State<AddMissionGroundSuggestionViewHandset> {
  final _nameController = TextEditingController();
  final _contactPersonController = TextEditingController();
  PhoneNumber? _contactNumber;

  bool _isLoading = false;

  // Add form validity check
  bool get _isFormValid {
    return _nameController.text.isNotEmpty &&
        _contactPersonController.text.isNotEmpty &&
        _contactNumber != null;
  }

  @override
  void initState() {
    super.initState();
    // Add listeners to update form validity
    _nameController.addListener(() => setState(() {}));
    _contactPersonController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactPersonController.dispose();
    super.dispose();
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
                      Icons.lightbulb_rounded,
                      size: 32,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.suggestAMission,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.suggestMissionSubTitle,
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
                      icon: Icons.school_outlined,
                      title: l10n.missionGround,
                      isRequired: true,
                      child: PRFNameInput(
                        hintText: 'e.g., Cool High School',
                        controller: _nameController,
                      ),
                    ).animate(delay: 100.ms).slideX(begin: -0.2).fadeIn(),

                    _buildFormSection(
                      icon: Icons.person_outline,
                      title: l10n.contactPerson,
                      isRequired: true,
                      child: PRFNameInput(
                        hintText: 'e.g., Tr John',
                        controller: _contactPersonController,
                      ),
                    ).animate(delay: 200.ms).slideX(begin: -0.2).fadeIn(),

                    _buildFormSection(
                      icon: Icons.phone_outlined,
                      title: l10n.contactNumber,
                      isRequired: true,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline
                                .withValues(
                                  alpha: 0.2,
                                ),
                          ),
                        ),
                        child: InternationalPhoneNumberInput(
                          countries: const ['KE'],
                          onInputChanged: (phoneNumber) => setState(() {
                            _contactNumber = phoneNumber;
                          }),
                          textStyle: Theme.of(context).textTheme.bodyMedium,
                          inputDecoration: InputDecoration(
                            hintText: '0712345678',
                            hintStyle: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ),
                    ).animate(delay: 300.ms).slideX(begin: -0.2).fadeIn(),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Submit Button
              BlocConsumer<
                    AddMissionGroundSuggestionCubit,
                    AddMissionGroundSuggestionState
                  >(
                    listener: (context, state) {
                      state.mapOrNull(
                        loading: (_) {
                          setState(() {
                            _isLoading = true;
                          });
                        },
                        loaded: (result) {
                          setState(() {
                            _isLoading = false;
                          });
                          Gaimon.success();
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                l10n.missionGroundRecorded(
                                  result.missionGroundSuggestion.name,
                                ),
                              ),
                            ),
                          );
                        },
                        error: (error) {
                          setState(() {
                            _isLoading = false;
                          });
                          Gaimon.error();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(error.message)),
                          );
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
                  .animate(delay: 400.ms)
                  .slideY(begin: 0.3)
                  .fadeIn(),

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

    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.enterMissionGround)),
      );
      Gaimon.warning();
      return;
    }

    if (_contactPersonController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.enterContactPerson)),
      );
      Gaimon.warning();
      return;
    }

    if (_contactNumber == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.enterContactNumber)),
      );
      Gaimon.warning();
      return;
    }

    await context.read<AddMissionGroundSuggestionCubit>().suggestMissionGround(
      name: _nameController.text.trim(),
      contactPerson: _contactPersonController.text.trim(),
      contactNumber: _contactNumber!,
    );
  }
}
