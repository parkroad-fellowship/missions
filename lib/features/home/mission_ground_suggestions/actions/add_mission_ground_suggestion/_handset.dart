import 'package:app/features/home/mission_ground_suggestions/cubit/ground_suggestion_resource_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/mission/prf_mission_ground_suggestion.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaimon/gaimon.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:prf_design/prf_design.dart';

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

  // Structured validation
  bool _showValidation = false;
  String? _nameError;
  String? _contactPersonError;
  String? _contactNumberError;

  bool get _isFormValid {
    return _nameController.text.isNotEmpty &&
        _contactPersonController.text.isNotEmpty &&
        _contactNumber != null;
  }

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onFormChanged);
    _contactPersonController.addListener(_onFormChanged);
  }

  void _onFormChanged() {
    if (_showValidation) {
      _validateForm();
    }
    setState(() {});
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactPersonController.dispose();
    super.dispose();
  }

  void _clearErrors() {
    _nameError = null;
    _contactPersonError = null;
    _contactNumberError = null;
  }

  bool _validateForm() {
    _clearErrors();

    if (_nameController.text.trim().isEmpty) {
      _nameError = 'Mission ground name is required';
    }
    if (_contactPersonController.text.trim().isEmpty) {
      _contactPersonError = 'Contact person is required';
    }
    if (_contactNumber == null) {
      _contactNumberError = 'Contact number is required';
    }

    setState(() => _showValidation = true);

    return _nameError == null &&
        _contactPersonError == null &&
        _contactNumberError == null;
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
                          Icons.lightbulb_rounded,
                          size: 32,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        const SizedBox(height: PRFSpacingTokens.sm),
                        Text(
                          l10n.suggestAMission,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: PRFSpacingTokens.xs),
                        Text(
                          l10n.suggestMissionSubTitle,
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
                        hintText: 'e.g., Cool High School',
                        controller: _nameController,
                        errorText: _showValidation ? _nameError : null,
                      ),
                    ).animate(delay: 100.ms).slideX(begin: -0.2).fadeIn(),

                    PRFFormSection(
                          icon: Icons.person_outline,
                          title: l10n.contactPerson,
                          isRequired: true,
                          child: PRFTextInput(
                            hintText: 'e.g., Tr John',
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
                                if (_showValidation) _validateForm();
                              }),
                              textStyle: Theme.of(context).textTheme.bodyMedium,
                              inputDecoration: InputDecoration(
                                hintText: '0712345678',
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
                  ],
                ),
              ),

              const SizedBox(height: PRFSpacingTokens.xl),

              // Submit Button
              BlocConsumer<
                    GroundSuggestionResourceCubit,
                    ResourceState<PRFMissionGroundSuggestion>
                  >(
                    listener: (context, state) {
                      state.mapOrNull(
                        mutating: (_) {
                          setState(() {
                            _isLoading = true;
                          });
                        },
                        mutated: (result) {
                          setState(() {
                            _isLoading = false;
                          });
                          Gaimon.success();
                          Navigator.of(context).pop();
                          PRFSnackbar.success(
                            context,
                            l10n.missionGroundRecorded(
                              result.item?.name ?? '',
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

  Future<void> _submitForm() async {
    if (!_validateForm()) {
      Gaimon.warning();
      PRFSnackbar.error(
        context,
        'Please fix the highlighted fields and try again.',
      );
      return;
    }

    await context.read<GroundSuggestionResourceCubit>().createSuggestion(
      data: {
        'name': _nameController.text.trim(),
        'contact_person': _contactPersonController.text.trim(),
        'contact_number': _contactNumber,
      },
    );
  }
}
