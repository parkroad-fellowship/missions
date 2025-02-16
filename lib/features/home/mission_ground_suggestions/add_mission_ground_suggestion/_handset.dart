import 'package:app/features/home/mission_ground_suggestions/cubit/add_mission_ground_suggestion_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/utils/_index.dart';
import 'package:app/widgets/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaimon/gaimon.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class AddMissionGroundSuggestionViewHandset extends StatefulWidget {
  const AddMissionGroundSuggestionViewHandset({
    super.key,
  });

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
                color: PRFApp.theme().kBlackColor,
              ),
            ),
            const SizedBox(height: 6),
            InputFormField(
              hintText: l10n.missionGround,
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: FormFieldLabel(
                label: l10n.contactPerson,
                isRequired: true,
                color: PRFApp.theme().kBlackColor,
              ),
            ),
            const SizedBox(height: 6),
            InputFormField(
              hintText: l10n.contactPerson,
              controller: _contactPersonController,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: FormFieldLabel(
                label: l10n.contactNumber,
                isRequired: true,
                color: PRFApp.theme().kBlackColor,
              ),
            ),
            const SizedBox(height: 6),
            InternationalPhoneNumberInput(
              countries: const ['KE'],
              onInputChanged: (phoneNumber) => setState(() {
                _contactNumber = phoneNumber;
              }),
              inputDecoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: PRFApp.theme().kBlackColor.withAlpha(150),
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: PRFApp.theme().kBlackColor.withAlpha(150),
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                fillColor: PRFApp.theme().kBackgroundColor,
                filled: false,
              ),
            ),
            const SizedBox(height: 32),
            BlocConsumer<AddMissionGroundSuggestionCubit,
                AddMissionGroundSuggestionState>(
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
                    Gaimon.error();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          error.message,
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
                        Gaimon.warning();
                        return;
                      }

                      if (_contactPersonController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.enterContactPerson),
                          ),
                        );
                        Gaimon.warning();
                        return;
                      }

                      if (_contactNumber == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.enterContactNumber),
                          ),
                        );
                        Gaimon.warning();
                        return;
                      }

                      await context
                          .read<AddMissionGroundSuggestionCubit>()
                          .suggestMissionGround(
                            name: _nameController.text.trim(),
                            contactPerson: _contactPersonController.text.trim(),
                            contactNumber: _contactNumber!,
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
