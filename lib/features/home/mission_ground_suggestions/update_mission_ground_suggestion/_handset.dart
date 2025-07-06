import 'package:app/enums/prf_mission_ground_suggestion_status.dart';
import 'package:app/features/home/mission_ground_suggestions/cubit/update_mission_ground_suggestion_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/prf_mission_ground_suggestion.dart';
import 'package:app/widgets/_index.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _nameController.text = missionGroundSuggestion.name;
    _contactPersonController.text = missionGroundSuggestion.contactPerson;
    _contactNumberController.text = missionGroundSuggestion.contactNumber;
    _notesController.text = missionGroundSuggestion.notes ?? '';
    _selectedStatus = missionGroundSuggestion.status;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondaryContainer.withValues(alpha: .3),
            border: Border(
              bottom: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: .1),
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
                  Icons.edit_rounded,
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
                      l10n.editMissionSuggestion,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.editMissionSuggestionSubTitle,
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
        ),

        // Form Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Mission Ground
                Text(
                  '${l10n.missionGround} *',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                PRFNameInput(
                  hintText: l10n.missionGround,
                  controller: _nameController,
                ),
                const SizedBox(height: 24),

                // Contact Person
                Text(
                  '${l10n.contactPerson} *',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                PRFNameInput(
                  hintText: l10n.contactPerson,
                  controller: _contactPersonController,
                ),
                const SizedBox(height: 24),

                // Contact Number
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
                      color: theme.colorScheme.outline.withValues(alpha: .2),
                    ),
                  ),
                  child: InternationalPhoneNumberInput(
                    textFieldController: _contactNumberController,
                    countries: const ['KE'],
                    onInputChanged: (phoneNumber) => setState(() {
                      contactNumber = phoneNumber;
                    }),
                    textStyle: theme.textTheme.bodyMedium,
                    inputDecoration: InputDecoration(
                      hintText: '+254 712 345 678',
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
                const SizedBox(height: 24),

                // Status Dropdown
                Text(
                  '${l10n.status} *',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: .2),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<PRFMissionGroundSuggestionStatus>(
                      value: _selectedStatus,
                      isExpanded: true,
                      borderRadius: BorderRadius.circular(12),
                      icon: Icon(
                        Icons.arrow_drop_down_rounded,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      items: PRFMissionGroundSuggestionStatus.values
                          .map(
                            (status) => DropdownMenuItem(
                              value: status,
                              child: Text(status.name),
                            ),
                          )
                          .toList(),
                      onChanged: (status) =>
                          setState(() => _selectedStatus = status),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Notes
                Text(
                  l10n.comments,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                PRFTextAreaInput(
                  hintText: l10n.comments,
                  controller: _notesController,
                ),
                const SizedBox(height: 40),

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
                          if (_contactNumberController.text.isEmpty) {
                            _showErrorSnackBar(
                              context,
                              l10n.enterContactNumber,
                            );
                            return;
                          }
                          if (_selectedStatus == null) {
                            _showErrorSnackBar(context, l10n.selectStatus);
                            return;
                          }
                          await context
                              .read<UpdateMissionGroundSuggestionCubit>()
                              .updateMissionGroundSuggestion(
                                name: _nameController.text.trim(),
                                contactPerson: _contactPersonController.text
                                    .trim(),
                                contactNumber: _contactNumberController.text
                                    .trim(),
                                status: _selectedStatus!,
                                notes: _notesController.text,
                                missionGroundSuggestionUlid:
                                    missionGroundSuggestion.ulid,
                              );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 60),
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
