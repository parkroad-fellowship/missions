import 'package:app/features/home/missions/cubit/add_mission_session_cubit.dart';
import 'package:app/features/home/missions/cubit/get_class_groups_cubit.dart';
import 'package:app/features/home/missions/cubit/get_subscribers_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/prf_class_group.dart';
import 'package:app/models/remote/prf_member.dart';
import 'package:app/utils/_index.dart';
import 'package:app/widgets/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:intl/intl.dart';

class AddSessionViewHandset extends StatefulWidget {
  const AddSessionViewHandset({
    required this.missionUlid,
    super.key,
  });

  final String missionUlid;

  @override
  State<AddSessionViewHandset> createState() => _AddSessionViewHandsetState();
}

class _AddSessionViewHandsetState extends State<AddSessionViewHandset> {
  final _notesController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  bool _isLoading = false;

  PRFMember? selectedFacilitator;
  PRFMember? selectedSpeaker;
  PRFClassGroup? selectedClassGroup;
  DateTime? startsAt;
  DateTime? endsAt;

  @override
  void initState() {
    super.initState();
    context
        .read<GetSubscribersCubit>()
        .getSubscriptions(missionUlid: widget.missionUlid);
    context.read<GetClassGroupsCubit>().getClassGroups();
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
                label: l10n.facilitator,
                isRequired: true,
                color: AppTheme.appTheme().kBlackColor,
              ),
            ),
            const SizedBox(height: 5),
            BlocBuilder<GetSubscribersCubit, GetSubscribersState>(
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () => const SizedBox.shrink(),
                  loading: () => const Center(
                    child: LinearProgressIndicator(),
                  ),
                  loaded: (subscribers) => LayoutBuilder(
                    builder: (context, constraints) {
                      return DropdownMenu<PRFMember>(
                        width: constraints.maxWidth,
                        initialSelection: selectedFacilitator,
                        hintText: l10n.facilitator,
                        dropdownMenuEntries: subscribers
                            .map(
                              (subscriber) => DropdownMenuEntry<PRFMember>(
                                value: subscriber.member!,
                                label: subscriber.member!.fullName,
                              ),
                            )
                            .toList(),
                        onSelected: (member) => setState(() {
                          selectedFacilitator = member;
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
                );
              },
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: FormFieldLabel(
                label: l10n.speaker,
                color: AppTheme.appTheme().kBlackColor,
              ),
            ),
            const SizedBox(height: 5),
            BlocBuilder<GetSubscribersCubit, GetSubscribersState>(
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () => const SizedBox.shrink(),
                  loading: () => const Center(
                    child: LinearProgressIndicator(),
                  ),
                  loaded: (subscribers) => LayoutBuilder(
                    builder: (context, constraints) {
                      return DropdownMenu<PRFMember>(
                        width: constraints.maxWidth,
                        initialSelection: selectedSpeaker,
                        hintText: l10n.speaker,
                        dropdownMenuEntries: subscribers
                            .map(
                              (subscriber) => DropdownMenuEntry<PRFMember>(
                                value: subscriber.member!,
                                label: subscriber.member!.fullName,
                              ),
                            )
                            .toList(),
                        onSelected: (member) => setState(() {
                          selectedSpeaker = member;
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
                );
              },
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: FormFieldLabel(
                label: l10n.classGroup,
                color: AppTheme.appTheme().kBlackColor,
              ),
            ),
            const SizedBox(height: 5),
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
                        hintText: l10n.classGroup,
                        dropdownMenuEntries: classes
                            .map(
                              (classGroup) => DropdownMenuEntry<PRFClassGroup>(
                                value: classGroup,
                                label: classGroup.name,
                              ),
                            )
                            .toList(),
                        onSelected: (classGroup) => setState(() {
                          selectedClassGroup = classGroup;
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
                );
              },
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: FormFieldLabel(
                label: l10n.startTime,
                isRequired: true,
                color: AppTheme.appTheme().kBlackColor,
              ),
            ),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: _selectStartDate,
              child: InputFormField(
                hintText: l10n.startTime,
                controller: _startDateController,
                keyboardType: TextInputType.text,
                enabled: false,
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: FormFieldLabel(
                label: l10n.endTime,
                isRequired: true,
                color: AppTheme.appTheme().kBlackColor,
              ),
            ),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: _selectEndDate,
              child: InputFormField(
                hintText: l10n.endTime,
                controller: _endDateController,
                keyboardType: TextInputType.text,
                enabled: false,
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: FormFieldLabel(
                label: l10n.notes,
                isRequired: true,
                color: AppTheme.appTheme().kBlackColor,
              ),
            ),
            const SizedBox(height: 6),
            InputFormField(
              hintText: l10n.notes,
              controller: _notesController,
              keyboardType: TextInputType.text,
              isTextBox: true,
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            BlocConsumer<AddMissionSessionCubit, AddMissionSessionState>(
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
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.sessionRecorded),
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
                      if (selectedFacilitator == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.selectFacilitator),
                          ),
                        );
                        return;
                      }

                      if (_notesController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.enterNotes),
                          ),
                        );
                        return;
                      }

                      if (startsAt == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.addStartEnd),
                          ),
                        );
                        return;
                      }

                      if (endsAt == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.addStartEnd),
                          ),
                        );
                        return;
                      }

                      await context.read<AddMissionSessionCubit>().addSession(
                            missionUlid: widget.missionUlid,
                            facilitatorUlid: selectedFacilitator!.ulid,
                            startsAt: startsAt!,
                            endsAt: endsAt!,
                            notes: _notesController.text,
                            speakerUlid: selectedSpeaker?.ulid,
                            classGroupUlid: selectedClassGroup?.ulid,
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

  Future<void> _selectStartDate() async {
    await DatePicker.showDateTimePicker(
      context,
      minTime: DateTime.now(),
      maxTime: DateTime.now().add(const Duration(days: 30)),
      theme: picker.DatePickerTheme(
        backgroundColor: AppTheme.appTheme().kBackgroundColor,
        itemStyle: PRFText.theme().headlineSmall!.copyWith(
              color: AppTheme.appTheme().kBlackColor,
            ),
        doneStyle: PRFText.theme().headlineSmall!.copyWith(
              color: AppTheme.appTheme().kPrimaryColorV2,
            ),
        cancelStyle: PRFText.theme().headlineSmall!.copyWith(
              color: AppTheme.appTheme().kPrimaryColorV2,
            ),
      ),
      onConfirm: (date) {
        setState(() {
          startsAt = date;
        });
        _startDateController.text =
            DateFormat.MMMMEEEEd().add_Hm().format(date);
      },
      currentTime: DateTime.now(),
    );
  }

  Future<void> _selectEndDate() async {
    await DatePicker.showDateTimePicker(
      context,
      minTime: DateTime.now(),
      maxTime: DateTime.now().add(const Duration(days: 30)),
      theme: picker.DatePickerTheme(
        backgroundColor: AppTheme.appTheme().kBackgroundColor,
        itemStyle: PRFText.theme().headlineSmall!.copyWith(
              color: AppTheme.appTheme().kBlackColor,
            ),
        doneStyle: PRFText.theme().headlineSmall!.copyWith(
              color: AppTheme.appTheme().kPrimaryColorV2,
            ),
        cancelStyle: PRFText.theme().headlineSmall!.copyWith(
              color: AppTheme.appTheme().kPrimaryColorV2,
            ),
      ),
      onConfirm: (date) {
        setState(() {
          endsAt = date;
        });
        _endDateController.text = DateFormat.MMMMEEEEd().add_Hm().format(date);
      },
      currentTime: DateTime.now(),
    );
  }
}
