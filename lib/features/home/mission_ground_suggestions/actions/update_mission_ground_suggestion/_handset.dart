import 'package:app/enums/mission/prf_mission_ground_suggestion_status.dart';
import 'package:app/features/home/mission_ground_suggestions/cubit/update_mission_ground_suggestion_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/mission/prf_mission_ground_suggestion.dart';
import 'package:prf_design/prf_design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaimon/gaimon.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class UpdateMissionGroundSuggestionViewHandset extends StatefulWidget {
  const UpdateMissionGroundSuggestionViewHandset({
    required this.missionGroundSuggestion,
    super.key,
  });

  final PRFMissionGroundSuggestion missionGroundSuggestion;

  @override
  State<UpdateMissionGroundSuggestionViewHandset> createState() =>
      _UpdateMissionGroundSuggestionViewHandsetState();
}

class _UpdateMissionGroundSuggestionViewHandsetState
    extends State<UpdateMissionGroundSuggestionViewHandset> {
  PRFMissionGroundSuggestion get missionGroundSuggestion =>
      widget.missionGroundSuggestion;

  final _nameController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _notesController = TextEditingController();

  PhoneNumber? contactNumber;
  PRFMissionGroundSuggestionStatus? _selectedStatus;

  bool _isLoading = false;

  // Structured validation
  bool _showValidation = false;
  String? _nameError;
  String? _contactPersonError;
  String? _contactNumberError;
  String? _statusError;

  bool get _isFormValid {
    return _nameController.text.isNotEmpty &&
        _contactPersonController.text.isNotEmpty &&
        _contactNumberController.text.isNotEmpty &&
        _selectedStatus != null;
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = missionGroundSuggestion.name;
    _contactPersonController.text = missionGroundSuggestion.contactPerson;
    _contactNumberController.text = missionGroundSuggestion.contactNumber;
    _notesController.text = missionGroundSuggestion.notes ?? '';
    _selectedStatus = missionGroundSuggestion.status;

    _nameController.addListener(_onFormChanged);
    _contactPersonController.addListener(_onFormChanged);
    _contactNumberController.addListener(_onFormChanged);
  }

  void _onFormChanged() {
    if (_showValidation) {
      _validateForm();
    }
    setState(() {});
  }

  void _clearErrors() {
    _nameError = null;
    _contactPersonError = null;
    _contactNumberError = null;
    _statusError = null;
  }

  bool _validateForm() {
    _clearErrors();

    if (_nameController.text.trim().isEmpty) {
      _nameError = 'Mission ground name is required';
    }
    if (_contactPersonController.text.trim().isEmpty) {
      _contactPersonError = 'Contact person is required';
    }
    if (_contactNumberController.text.trim().isEmpty) {
      _contactNumberError = 'Contact number is required';
    }
    if (_selectedStatus == null) {
      _statusError = 'Status is required';
    }

    setState(() => _showValidation = true);

    return _nameError == null &&
        _contactPersonError == null &&
        _contactNumberError == null &&
        _statusError == null;
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
                          Icons.edit_rounded,
                          size: 32,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        const SizedBox(height: PRFSpacingTokens.sm),
                        Text(
                          l10n.editMissionSuggestion,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: PRFSpacingTokens.xs),
                        Text(
                          l10n.editMissionSuggestionSubTitle,
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
                      icon: Icons.school_outlined,
                      title: l10n.missionGround,
                      isRequired: true,
                      child: PRFTextInput(
                        hintText: l10n.missionGround,
                        controller: _nameController,
                        errorText: _showValidation ? _nameError : null,
                      ),
                    ).animate(delay: 100.ms).slideX(begin: -0.2).fadeIn(),

                    PRFFormSection(
                          icon: Icons.person_outline,
                          title: l10n.contactPerson,
                          isRequired: true,
                          child: PRFTextInput(
                            hintText: l10n.contactPerson,
                            controller: _contactPersonController,
                            errorText: _showValidation
                                ? _contactPersonError
                                : null,
                          ),
                        )
                        .animate(delay: PRFMotionTokens.standard)
                        .slideX(begin: -0.2)
                        .fadeIn(),

                    PRFFormSection(
                          icon: Icons.phone_outlined,
                          title: l10n.contactNumber,
                          isRequired: true,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(
                                PRFRadiusTokens.smd,
                              ),
                              border: Border.all(
                                color: Theme.of(
                                  context,
                                ).colorScheme.outline.withValues(alpha: 0.2),
                              ),
                            ),
                            child: InternationalPhoneNumberInput(
                              textFieldController: _contactNumberController,
                              countries: const ['KE'],
                              onInputChanged: (phoneNumber) => setState(() {
                                contactNumber = phoneNumber;
                                if (_showValidation) _validateForm();
                              }),
                              textStyle: Theme.of(context).textTheme.bodyMedium,
                              inputDecoration: InputDecoration(
                                hintText: '+254 712 345 678',
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: PRFSpacingTokens.lg,
                                  vertical: PRFSpacingTokens.lg,
                                ),
                              ),
                            ),
                          ),
                        )
                        .animate(delay: PRFMotionTokens.slow)
                        .slideX(begin: -0.2)
                        .fadeIn(),

                    PRFFormSection(
                          icon: Icons.flag_outlined,
                          title: l10n.status,
                          isRequired: true,
                          child:
                              PRFSearchableList<
                                PRFMissionGroundSuggestionStatus
                              >(
                                entries: PRFMissionGroundSuggestionStatus.values
                                    .map(
                                      (status) =>
                                          PRFSearchableListEntry<
                                            PRFMissionGroundSuggestionStatus
                                          >(
                                            value: status,
                                            label: status.name,
                                          ),
                                    )
                                    .toList(),
                                onSelected: (status) => setState(() {
                                  _selectedStatus = status;
                                  if (_showValidation) _validateForm();
                                }),
                                selection: _selectedStatus,
                                hintText: l10n.status,
                                emptyText: 'No statuses found',
                              ),
                        )
                        .animate(delay: PRFMotionTokens.slow)
                        .slideX(begin: -0.2)
                        .fadeIn(),

                    PRFFormSection(
                          icon: Icons.notes_outlined,
                          title: l10n.comments,
                          child: PRFTextAreaInput(
                            hintText: l10n.comments,
                            controller: _notesController,
                          ),
                        )
                        .animate(delay: PRFMotionTokens.enterShort)
                        .slideX(begin: -0.2)
                        .fadeIn(),
                  ],
                ),
              ),

              const SizedBox(height: PRFSpacingTokens.xl),

              // Submit Button
              BlocConsumer<
                    UpdateMissionGroundSuggestionCubit,
                    UpdateMissionGroundSuggestionState
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
                          PRFSnackbar.success(
                            context,
                            l10n.missionGroundRecorded(
                              result.missionGroundSuggestion.name,
                            ),
                          );
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
                  .animate(delay: PRFMotionTokens.enterShort)
                  .slideY(begin: 0.3)
                  .fadeIn(),

              const SizedBox(height: 72),
            ],
          ),
        ),
      ),
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

    await context
        .read<UpdateMissionGroundSuggestionCubit>()
        .updateMissionGroundSuggestion(
          name: _nameController.text.trim(),
          contactPerson: _contactPersonController.text.trim(),
          contactNumber: _contactNumberController.text.trim(),
          status: _selectedStatus!,
          notes: _notesController.text,
          missionGroundSuggestionUlid: missionGroundSuggestion.ulid,
        );
  }
}
