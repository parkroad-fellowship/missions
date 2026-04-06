import 'package:app/features/home/missions/cubit/class_group_resource_cubit.dart';
import 'package:app/features/home/missions/cubit/mission_subscription_resource_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/sessions/cubit/mission_session_resource_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/member/prf_class_group.dart';
import 'package:app/models/remote/mission/prf_mission_session.dart';
import 'package:app/models/remote/mission/prf_mission_session_dto.dart';
import 'package:app/models/remote/mission/prf_mission_subscription.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:gaimon/gaimon.dart';
import 'package:intl/intl.dart';
import 'package:prf_design/prf_design.dart';

class SessionFormViewHandset extends StatefulWidget {
  const SessionFormViewHandset({
    required this.missionUlid,
    this.missionSession,
    super.key,
  });

  final String missionUlid;
  final PRFMissionSession? missionSession;

  @override
  State<SessionFormViewHandset> createState() => _SessionFormViewHandsetState();
}

class _SessionFormViewHandsetState extends State<SessionFormViewHandset> {
  final _notesController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  bool _isLoading = false;
  bool get _isEditing => widget.missionSession != null;

  String? selectedFacilitatorUlid;
  String? selectedSpeakerUlid;
  String? selectedClassGroupUlid;
  DateTime? startsAt;
  DateTime? endsAt;

  // Structured validation
  bool _showValidation = false;
  String? _facilitatorError;
  String? _notesError;
  String? _startTimeError;
  String? _endTimeError;

  bool get _isFormValid {
    return selectedFacilitatorUlid != null &&
        _notesController.text.isNotEmpty &&
        startsAt != null &&
        endsAt != null;
  }

  @override
  void initState() {
    super.initState();
    _notesController.addListener(_onFormChanged);

    context.read<MissionSubscriptionResourceCubit>().loadAll(
      filters: {'mission_ulid': widget.missionUlid},
    );
    context.read<ClassGroupResourceCubit>().loadAll();

    if (_isEditing) {
      final session = widget.missionSession!;
      selectedFacilitatorUlid = session.facilitator?.ulid;
      selectedSpeakerUlid = session.speaker?.ulid;
      if (session.classGroup != null) {
        selectedClassGroupUlid = session.classGroup!.ulid;
      }
      startsAt = session.startsAt;
      endsAt = session.endsAt;
      _notesController.text = session.notes;
      _startDateController.text = DateFormat.MMMMEEEEd().add_Hm().format(
        startsAt!,
      );
      _endDateController.text = DateFormat.MMMMEEEEd().add_Hm().format(endsAt!);
    }
  }

  void _onFormChanged() {
    if (_showValidation) {
      _validateForm();
    }
    setState(() {});
  }

  void _clearErrors() {
    _facilitatorError = null;
    _notesError = null;
    _startTimeError = null;
    _endTimeError = null;
  }

  bool _validateForm() {
    _clearErrors();

    if (selectedFacilitatorUlid == null) {
      _facilitatorError = 'Facilitator is required';
    }
    if (_notesController.text.trim().isEmpty) {
      _notesError = 'Notes are required';
    }
    if (startsAt == null) {
      _startTimeError = 'Start time is required';
    }
    if (endsAt == null) {
      _endTimeError = 'End time is required';
    }

    setState(() => _showValidation = true);

    return _facilitatorError == null &&
        _notesError == null &&
        _startTimeError == null &&
        _endTimeError == null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(PRFSpacingTokens.lg),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEditing ? 'Update Session' : l10n.addSession,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: PRFSpacingTokens.xl),

            // Facilitator
            PRFFormSection(
              icon: Icons.person_outline,
              title: l10n.facilitator,
              isRequired: true,
              child:
                  BlocBuilder<
                    MissionSubscriptionResourceCubit,
                    ResourceState<PRFMissionSubscription>
                  >(
                    builder: (context, state) {
                      return state.maybeWhen(
                        orElse: () => const SizedBox.shrink(),
                        listLoading: (_) => const PRFLinearProgressIndicator(),
                        listLoaded: (subscribers, _, _) =>
                            PRFSearchableList<String>(
                              entries: subscribers
                                  .where((s) => s.member != null)
                                  .map(
                                    (subscriber) =>
                                        PRFSearchableListEntry<String>(
                                          value: subscriber.member!.ulid,
                                          label: subscriber.member!.fullName,
                                        ),
                                  )
                                  .toList(),
                              onSelected: (member) => setState(() {
                                selectedFacilitatorUlid = member;
                                if (_showValidation) _validateForm();
                              }),
                              selection: selectedFacilitatorUlid,
                              hintText: l10n.facilitator,
                              emptyText: 'No subscribers found',
                            ),
                      );
                    },
                  ),
            ),

            // Speaker
            PRFFormSection(
              icon: Icons.mic_outlined,
              title: l10n.speaker,
              child:
                  BlocBuilder<
                    MissionSubscriptionResourceCubit,
                    ResourceState<PRFMissionSubscription>
                  >(
                    builder: (context, state) {
                      return state.maybeWhen(
                        orElse: () => const SizedBox.shrink(),
                        listLoading: (_) => const PRFLinearProgressIndicator(),
                        listLoaded: (subscribers, _, _) =>
                            PRFSearchableList<String>(
                              entries: subscribers
                                  .where((s) => s.member != null)
                                  .map(
                                    (subscriber) =>
                                        PRFSearchableListEntry<String>(
                                          value: subscriber.member!.ulid,
                                          label: subscriber.member!.fullName,
                                        ),
                                  )
                                  .toList(),
                              onSelected: (member) => setState(() {
                                selectedSpeakerUlid = member;
                              }),
                              selection: selectedSpeakerUlid,
                              hintText: l10n.speaker,
                              emptyText: 'No subscribers found',
                            ),
                      );
                    },
                  ),
            ),

            // Class Group
            PRFFormSection(
              icon: Icons.group_outlined,
              title: l10n.classGroup,
              child:
                  BlocBuilder<
                    ClassGroupResourceCubit,
                    ResourceState<PRFClassGroup>
                  >(
                    builder: (context, state) {
                      return state.maybeWhen(
                        orElse: () => const SizedBox.shrink(),
                        listLoading: (_) => const Center(
                          child: PRFLinearProgressIndicator(),
                        ),
                        listLoaded: (classes, _, _) =>
                            PRFSearchableList<String>(
                              entries: classes
                                  .map(
                                    (classGroup) =>
                                        PRFSearchableListEntry<String>(
                                          value: classGroup.ulid,
                                          label: classGroup.name,
                                        ),
                                  )
                                  .toList(),
                              onSelected: (classGroup) => setState(() {
                                selectedClassGroupUlid = classGroup;
                              }),
                              selection: selectedClassGroupUlid,
                              hintText: l10n.classGroup,
                              emptyText: 'No class groups found',
                            ),
                      );
                    },
                  ),
            ),

            // Start Time
            PRFFormSection(
              icon: Icons.schedule_outlined,
              title: l10n.startTime,
              isRequired: true,
              child: GestureDetector(
                onTap: _selectStartDate,
                child: PRFTextInput(
                  hintText: l10n.startTime,
                  controller: _startDateController,
                  enabled: false,
                  errorText: _showValidation ? _startTimeError : null,
                ),
              ),
            ),

            // End Time
            PRFFormSection(
              icon: Icons.schedule_outlined,
              title: l10n.endTime,
              isRequired: true,
              child: GestureDetector(
                onTap: _selectEndDate,
                child: PRFTextInput(
                  hintText: l10n.endTime,
                  controller: _endDateController,
                  enabled: false,
                  errorText: _showValidation ? _endTimeError : null,
                ),
              ),
            ),

            // Notes
            PRFFormSection(
              icon: Icons.notes_outlined,
              title: l10n.notes,
              isRequired: true,
              child: PRFTextAreaInput(
                hintText: l10n.notes,
                controller: _notesController,
                errorText: _showValidation ? _notesError : null,
              ),
            ),

            const SizedBox(height: PRFSpacingTokens.xl),

            // Submit Button
            BlocConsumer<
              MissionSessionResourceCubit,
              ResourceState<PRFMissionSession>
            >(
              listener: (context, state) {
                state.mapOrNull(
                  mutating: (_) {
                    setState(() {
                      _isLoading = true;
                    });
                  },
                  mutated: (_) {
                    setState(() {
                      _isLoading = false;
                    });
                    Gaimon.success();
                    Navigator.of(context).pop();
                    PRFSnackbar.success(context, l10n.sessionRecorded);
                    if (_isEditing) {
                      context.read<MissionSessionResourceCubit>().loadAll(
                        filters: {
                          'mission_ulid': widget.missionUlid,
                        },
                      );
                    }
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
                  title: _isEditing ? 'Update' : l10n.record,
                  disabled: !_isFormValid,
                  isLoading: _isLoading,
                );
              },
            ),
          ],
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

    final dto = PRFMissionSessionDTO(
      missionUlid: widget.missionUlid,
      facilitatorUlid: selectedFacilitatorUlid!,
      startsAt: startsAt!.toIso8601String(),
      endsAt: endsAt!.toIso8601String(),
      notes: _notesController.text,
      speakerUlid: selectedSpeakerUlid,
      classGroupUlid: selectedClassGroupUlid,
    );

    if (_isEditing) {
      await context.read<MissionSessionResourceCubit>().updateSession(
        ulid: widget.missionSession!.ulid,
        data: dto,
      );
    } else {
      await context.read<MissionSessionResourceCubit>().addSession(
        data: dto,
      );
    }
  }

  Future<void> _selectStartDate() async {
    await DatePicker.showDateTimePicker(
      context,
      minTime: DateTime.now().subtract(const Duration(days: 7)),
      maxTime: DateTime.now().add(const Duration(days: 30)),
      theme: picker.DatePickerTheme(
        itemStyle: Theme.of(context).textTheme.headlineSmall!,
        doneStyle: Theme.of(context).textTheme.headlineSmall!,
        cancelStyle: Theme.of(context).textTheme.headlineSmall!,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      onConfirm: (date) {
        setState(() {
          startsAt = date;
          if (_showValidation) _validateForm();
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
      minTime: DateTime.now().subtract(const Duration(days: 7)),
      maxTime: DateTime.now().add(const Duration(days: 30)),
      theme: picker.DatePickerTheme(
        itemStyle: Theme.of(context).textTheme.headlineSmall!,
        doneStyle: Theme.of(context).textTheme.headlineSmall!,
        cancelStyle: Theme.of(context).textTheme.headlineSmall!,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      onConfirm: (date) {
        setState(() {
          endsAt = date;
          if (_showValidation) _validateForm();
        });
        _endDateController.text = DateFormat.MMMMEEEEd().add_Hm().format(date);
      },
      currentTime: DateTime.now(),
    );
  }
}
