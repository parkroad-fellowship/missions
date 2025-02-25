import 'package:app/features/home/missions/cubit/add_mission_session_cubit.dart';
import 'package:app/features/home/missions/cubit/get_class_groups_cubit.dart';
import 'package:app/features/home/missions/cubit/get_subscribers_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/prf_local_mission_subscription.dart';
import 'package:app/models/local/shared_embeds.dart';
import 'package:app/models/remote/prf_class_group.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:app/widgets/_index.dart';
import 'package:app/widgets/linear_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:gaimon/gaimon.dart';
import 'package:intl/intl.dart';

class AddSessionViewHandset extends StatefulWidget {
  const AddSessionViewHandset({required this.missionUlid, super.key});

  final String missionUlid;

  @override
  State<AddSessionViewHandset> createState() => _AddSessionViewHandsetState();
}

class _AddSessionViewHandsetState extends State<AddSessionViewHandset> {
  final _notesController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  bool _isLoading = false;

  PRFLocalMember? selectedFacilitator;
  PRFLocalMember? selectedSpeaker;
  PRFClassGroup? selectedClassGroup;
  DateTime? startsAt;
  DateTime? endsAt;

  @override
  void initState() {
    super.initState();
    context.read<GetSubscribersCubit>().getSubscriptions(
      missionUlid: widget.missionUlid,
    );
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
                color: PRFApp.theme().kBlackColor,
              ),
            ),
            const SizedBox(height: 5),
            SingleStreamWrapper<List<PRFLocalMissionSubscription>>(
              stream: getIt<LocalDBService>().getMissionSubscriptions(
                missionUlid: widget.missionUlid,
              ),
              loading: const PRFLinearProgressIndicator(),
              widget:
                  (context, subscribers) => LayoutBuilder(
                    builder: (context, constraints) {
                      return DropdownMenu<PRFLocalMember>(
                        width: constraints.maxWidth,
                        initialSelection: selectedFacilitator,
                        hintText: l10n.facilitator,
                        dropdownMenuEntries:
                            subscribers
                                .map(
                                  (subscriber) =>
                                      DropdownMenuEntry<PRFLocalMember>(
                                        value: subscriber.member,
                                        label: subscriber.member.fullName!,
                                      ),
                                )
                                .toList(),
                        onSelected:
                            (member) => setState(() {
                              selectedFacilitator = member;
                            }),
                        inputDecorationTheme: InputDecorationTheme(
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(
                              color: PRFApp.theme().kSecondaryGreyColor,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(
                              color: PRFApp.theme().kSecondaryGreyColor,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                          fillColor: PRFApp.theme().kBackgroundColor,
                          hintStyle: PRFText.theme().headlineSmall!.copyWith(
                            color: PRFApp.theme().kDullGreyColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    },
                  ),
            ),

            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: FormFieldLabel(
                label: l10n.speaker,
                color: PRFApp.theme().kBlackColor,
              ),
            ),
            const SizedBox(height: 5),
            SingleStreamWrapper<List<PRFLocalMissionSubscription>>(
              stream: getIt<LocalDBService>().getMissionSubscriptions(
                missionUlid: widget.missionUlid,
              ),
              loading: const PRFLinearProgressIndicator(),
              widget:
                  (context, subscribers) => LayoutBuilder(
                    builder: (context, constraints) {
                      return DropdownMenu<PRFLocalMember>(
                        width: constraints.maxWidth,
                        initialSelection: selectedSpeaker,
                        hintText: l10n.speaker,
                        dropdownMenuEntries:
                            subscribers
                                .map(
                                  (subscriber) =>
                                      DropdownMenuEntry<PRFLocalMember>(
                                        value: subscriber.member,
                                        label: subscriber.member.fullName!,
                                      ),
                                )
                                .toList(),
                        onSelected:
                            (member) => setState(() {
                              selectedSpeaker = member;
                            }),
                        inputDecorationTheme: InputDecorationTheme(
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(
                              color: PRFApp.theme().kSecondaryGreyColor,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide(
                              color: PRFApp.theme().kSecondaryGreyColor,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                          fillColor: PRFApp.theme().kBackgroundColor,
                          hintStyle: PRFText.theme().headlineSmall!.copyWith(
                            color: PRFApp.theme().kDullGreyColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    },
                  ),
            ),

            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: FormFieldLabel(
                label: l10n.classGroup,
                color: PRFApp.theme().kBlackColor,
              ),
            ),
            const SizedBox(height: 5),
            BlocBuilder<GetClassGroupsCubit, GetClassGroupsState>(
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () => const SizedBox.shrink(),
                  loading: () => const Center(child: LinearProgressIndicator()),
                  loaded:
                      (classes) => LayoutBuilder(
                        builder: (context, constraints) {
                          return DropdownMenu<PRFClassGroup>(
                            width: constraints.maxWidth,
                            initialSelection: selectedClassGroup,
                            hintText: l10n.classGroup,
                            dropdownMenuEntries:
                                classes
                                    .map(
                                      (classGroup) =>
                                          DropdownMenuEntry<PRFClassGroup>(
                                            value: classGroup,
                                            label: classGroup.name,
                                          ),
                                    )
                                    .toList(),
                            onSelected:
                                (classGroup) => setState(() {
                                  selectedClassGroup = classGroup;
                                }),
                            inputDecorationTheme: InputDecorationTheme(
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(
                                  color: PRFApp.theme().kSecondaryGreyColor,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: BorderSide(
                                  color: PRFApp.theme().kSecondaryGreyColor,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20,
                              ),
                              fillColor: PRFApp.theme().kBackgroundColor,
                              hintStyle: PRFText.theme().headlineSmall!
                                  .copyWith(
                                    color: PRFApp.theme().kDullGreyColor,
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
                color: PRFApp.theme().kBlackColor,
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
                color: PRFApp.theme().kBlackColor,
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
                color: PRFApp.theme().kBlackColor,
              ),
            ),
            const SizedBox(height: 6),
            InputFormField(
              hintText: l10n.notes,
              controller: _notesController,
              keyboardType: TextInputType.text,
              isTextBox: true,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
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
                    Gaimon.success();
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.sessionRecorded)),
                    );
                  },
                  error: (error) {
                    setState(() {
                      _isLoading = false;
                    });
                    Gaimon.error();
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(error.error)));
                  },
                );
              },
              builder: (context, state) {
                return state.maybeWhen(
                  orElse:
                      () => PrimaryButton(
                        title: _isLoading ? l10n.recording : l10n.record,
                        disabled: _isLoading,
                        isLoading: _isLoading ? true : null,
                        onPressed: () async {
                          if (selectedFacilitator == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.selectFacilitator)),
                            );
                            Gaimon.warning();
                            return;
                          }

                          if (_notesController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.enterNotes)),
                            );
                            Gaimon.warning();
                            return;
                          }

                          if (startsAt == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.addStartEnd)),
                            );
                            Gaimon.warning();
                            return;
                          }

                          if (endsAt == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.addStartEnd)),
                            );
                            Gaimon.warning();
                            return;
                          }

                          await context
                              .read<AddMissionSessionCubit>()
                              .addSession(
                                missionUlid: widget.missionUlid,
                                facilitatorUlid: selectedFacilitator!.ulid!,
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
        backgroundColor: PRFApp.theme().kBackgroundColor,
        itemStyle: PRFText.theme().headlineSmall!.copyWith(
          color: PRFApp.theme().kBlackColor,
        ),
        doneStyle: PRFText.theme().headlineSmall!.copyWith(
          color: PRFApp.theme().kPrimaryColorV2,
        ),
        cancelStyle: PRFText.theme().headlineSmall!.copyWith(
          color: PRFApp.theme().kPrimaryColorV2,
        ),
      ),
      onConfirm: (date) {
        setState(() {
          startsAt = date;
        });
        _startDateController.text = DateFormat.MMMMEEEEd().add_Hm().format(
          date,
        );
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
        backgroundColor: PRFApp.theme().kBackgroundColor,
        itemStyle: PRFText.theme().headlineSmall!.copyWith(
          color: PRFApp.theme().kBlackColor,
        ),
        doneStyle: PRFText.theme().headlineSmall!.copyWith(
          color: PRFApp.theme().kPrimaryColorV2,
        ),
        cancelStyle: PRFText.theme().headlineSmall!.copyWith(
          color: PRFApp.theme().kPrimaryColorV2,
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
