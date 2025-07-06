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

  @override
  void dispose() {
    _nameController.dispose();
    _contactPersonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Column(
      children: [
        // Enhanced Header
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.3),
            border: Border(
              bottom: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.1),
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.lightbulb_rounded,
                  color: theme.colorScheme.onPrimary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.suggestAMission,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.suggestMissionSubTitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.close_rounded,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ).animate().fadeIn().slideY(begin: -0.3, end: 0),

        // Enhanced Form Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Mission Ground Field
                Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${l10n.missionGround} *',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        PRFNameInput(
                          hintText: 'e.g., Cool High School',
                          controller: _nameController,
                        ),
                      ],
                    )
                    .animate(delay: const Duration(milliseconds: 100))
                    .fadeIn(duration: const Duration(milliseconds: 600))
                    .slideY(begin: 0.2, end: 0),

                const SizedBox(height: 24),

                // Contact Person Field
                Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${l10n.contactPerson} *',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        PRFNameInput(
                          hintText: 'e.g., Tr John',
                          controller: _contactPersonController,
                        ),
                      ],
                    )
                    .animate(delay: const Duration(milliseconds: 200))
                    .fadeIn(duration: const Duration(milliseconds: 600))
                    .slideY(begin: 0.2, end: 0),

                const SizedBox(height: 24),

                // Contact Number Field
                Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${l10n.contactNumber} *',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: theme.colorScheme.outline.withValues(
                                alpha: 0.2,
                              ),
                            ),
                          ),
                          child: InternationalPhoneNumberInput(
                            countries: const ['KE'],
                            onInputChanged: (phoneNumber) => setState(() {
                              _contactNumber = phoneNumber;
                            }),
                            textStyle: theme.textTheme.bodyMedium,
                            inputDecoration: InputDecoration(
                              hintText: '0712345678',
                              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                    .animate(delay: const Duration(milliseconds: 300))
                    .fadeIn(duration: const Duration(milliseconds: 600))
                    .slideY(begin: 0.2, end: 0),

                const SizedBox(height: 48),

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
                            backgroundColor: theme.colorScheme.primary,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
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
                          SnackBar(
                            content: Text(error.message),
                            backgroundColor: theme.colorScheme.error,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  builder: (context, state) {
                    return SizedBox(
                          width: double.infinity,
                          child: PRFPrimaryButton(
                            title: _isLoading ? l10n.recording : l10n.record,
                            disabled: _isLoading,
                            isLoading: _isLoading ? true : null,
                            onPressed: () async {
                              if (_nameController.text.isEmpty) {
                                _showErrorSnackBar(
                                  context,
                                  l10n.enterMissionGround,
                                );
                                return;
                              }

                              if (_contactPersonController.text.isEmpty) {
                                _showErrorSnackBar(
                                  context,
                                  l10n.enterContactPerson,
                                );
                                return;
                              }

                              if (_contactNumber == null) {
                                _showErrorSnackBar(
                                  context,
                                  l10n.enterContactNumber,
                                );
                                return;
                              }

                              await context
                                  .read<AddMissionGroundSuggestionCubit>()
                                  .suggestMissionGround(
                                    name: _nameController.text.trim(),
                                    contactPerson: _contactPersonController.text
                                        .trim(),
                                    contactNumber: _contactNumber!,
                                  );
                            },
                          ),
                        )
                        .animate(delay: const Duration(milliseconds: 400))
                        .fadeIn(duration: const Duration(milliseconds: 600))
                        .slideY(begin: 0.2, end: 0);
                  },
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    Gaimon.warning();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
