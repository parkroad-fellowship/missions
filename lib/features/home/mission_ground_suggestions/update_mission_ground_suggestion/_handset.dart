import 'package:app/enums/prf_mission_ground_suggestion_status.dart';
import 'package:app/features/home/mission_ground_suggestions/cubit/update_mission_ground_suggestion_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/prf_mission_ground_suggestion.dart';
import 'package:app/utils/_index.dart';
import 'package:app/widgets/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

    // Initialize the fields with the current values
    _nameController.text = missionGroundSuggestion.name;
    _contactPersonController.text = missionGroundSuggestion.contactPerson;
    _contactNumberController.text = missionGroundSuggestion.contactNumber;
    _notesController.text = missionGroundSuggestion.notes ?? '';
    _selectedStatus = missionGroundSuggestion.status;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: FormFieldLabel(
                label: l10n.missionGround,
                isRequired: true,
                color: AppTheme.appTheme().kBlackColor,
              ),
            ),
            const SizedBox(height: 6),
            InputFormField(
              hintText: l10n.missionGround,
              controller: _nameController,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: FormFieldLabel(
                label: l10n.contactPerson,
                isRequired: true,
                color: AppTheme.appTheme().kBlackColor,
              ),
            ),
            const SizedBox(height: 6),
            InputFormField(
              hintText: l10n.contactPerson,
              controller: _contactPersonController,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: FormFieldLabel(
                label: l10n.contactNumber,
                isRequired: true,
                color: AppTheme.appTheme().kBlackColor,
              ),
            ),
            const SizedBox(height: 6),
            InternationalPhoneNumberInput(
              textFieldController: _contactNumberController,
              countries: const ['KE'],
              onInputChanged: (phoneNumber) => setState(() {
                contactNumber = phoneNumber;
              }),
              inputDecoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppTheme.appTheme().kBlackColor.withAlpha(150),
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppTheme.appTheme().kBlackColor.withAlpha(150),
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                fillColor: AppTheme.appTheme().kBackgroundColor,
                filled: false,
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: FormFieldLabel(
                label: l10n.status,
                isRequired: true,
                color: AppTheme.appTheme().kBlackColor,
              ),
            ),
            const SizedBox(height: 6),
            LayoutBuilder(
              builder: (context, constraints) {
                return DropdownMenu<PRFMissionGroundSuggestionStatus>(
                  width: constraints.maxWidth,
                  initialSelection: _selectedStatus,
                  hintText: l10n.facilitator,
                  dropdownMenuEntries: PRFMissionGroundSuggestionStatus.values
                      .map(
                        (status) =>
                            DropdownMenuEntry<PRFMissionGroundSuggestionStatus>(
                          value: status,
                          label: status.name,
                        ),
                      )
                      .toList(),
                  onSelected: (status) => setState(() {
                    _selectedStatus = status;
                  }),
                  inputDecorationTheme: InputDecorationTheme(
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(
                        color: AppTheme.appTheme().kSecondaryGreyColor,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(
                        color: AppTheme.appTheme().kSecondaryGreyColor,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    fillColor: AppTheme.appTheme().kBackgroundColor,
                    hintStyle: PRFText.theme().headlineSmall!.copyWith(
                          color: AppTheme.appTheme().kDullGreyColor,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: FormFieldLabel(
                label: l10n.comments,
                isRequired: false,
                color: AppTheme.appTheme().kBlackColor,
              ),
            ),
            const SizedBox(height: 6),
            InputFormField(
              hintText: l10n.comments,
              controller: _notesController,
              isTextBox: true,
              maxLines: 5,
            ),
            const SizedBox(height: 32),
            BlocConsumer<UpdateMissionGroundSuggestionCubit,
                UpdateMissionGroundSuggestionState>(
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
                );
              },
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () => PrimaryButton(
                    title: _isLoading ? l10n.recording : l10n.record,
                    disabled: _isLoading,
                    isLoading: _isLoading ? true : null,
                    onPressed: () async {
                      if (_nameController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.enterMissionGround),
                          ),
                        );
                        return;
                      }

                      if (_contactPersonController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.enterContactPerson),
                          ),
                        );
                        return;
                      }

                      if (_contactNumberController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.enterContactNumber),
                          ),
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
                            missionGroundSuggestionUlid:
                                missionGroundSuggestion.ulid,
                          );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
