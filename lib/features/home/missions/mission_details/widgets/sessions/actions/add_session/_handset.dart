import 'package:app/features/home/missions/cubit/class_group_resource_cubit.dart';
import 'package:app/features/home/missions/cubit/mission_subscription_resource_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/sessions/cubit/mission_session_resource_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/mission/prf_local_mission_subscription.dart';
import 'package:app/models/local/shared_embeds.dart';
import 'package:app/models/remote/member/prf_class_group.dart';
import 'package:app/models/remote/mission/prf_mission_session.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:gaimon/gaimon.dart';
import 'package:intl/intl.dart';
import 'package:prf_design/prf_design.dart';

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

  // Structured validation
  bool _showValidation = false;
  String? _facilitatorError;
  String? _notesError;
  String? _startTimeError;
  String? _endTimeError;

  bool get _isFormValid {
    return selectedFacilitator != null &&
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
    context.read<ClassGroupResourceCubit>().loadAll(
      filters: {'mission_ulid': widget.missionUlid},
    );
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

    if (selectedFacilitator == null) {
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
                          Icons.add_circle_outline,
                          size: 32,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        const SizedBox(height: PRFSpacingTokens.sm),
                        Text(
                          'Create New Session',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: PRFSpacingTokens.xs),
                        Text(
                          'Fill in the details below to record a new session',
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
                      icon: Icons.person_outline,
                      title: l10n.facilitator,
                      isRequired: true,
                      child:
                          SingleStreamWrapper<
                            List<PRFLocalMissionSubscription>
                          >(
                            stream: getIt<IsarService>()
                                .missionSubscriptions
                                .parentStream,
                            loading: const PRFLinearProgressIndicator(),
                            widget: (context, subscribers) =>
                                PRFSearchableList<PRFLocalMember>(
                                  entries: subscribers
                                      .map(
                                        (subscriber) =>
                                            PRFSearchableListEntry<
                                              PRFLocalMember
                                            >(
                                              value: subscriber.member,
                                              label:
                                                  subscriber.member.fullName!,
                                            ),
                                      )
                                      .toList(),
                                  onSelected: (member) => setState(() {
                                    selectedFacilitator = member;
                                    if (_showValidation) _validateForm();
                                  }),
                                  selection: selectedFacilitator,
                                  hintText: l10n.facilitator,
                                  emptyText: 'No subscribers found',
                                ),
                          ),
                    ).animate(delay: 100.ms).slideX(begin: -0.2).fadeIn(),

                    PRFFormSection(
                          icon: Icons.mic_outlined,
                          title: l10n.speaker,
                          child:
                              SingleStreamWrapper<
                                List<PRFLocalMissionSubscription>
                              >(
                                stream: getIt<IsarService>()
                                    .missionSubscriptions
                                    .parentStream,
                                loading: const PRFLinearProgressIndicator(),
                                widget: (context, subscribers) =>
                                    PRFSearchableList<PRFLocalMember>(
                                      entries: subscribers
                                          .map(
                                            (subscriber) =>
                                                PRFSearchableListEntry<
                                                  PRFLocalMember
                                                >(
                                                  value: subscriber.member,
                                                  label: subscriber
                                                      .member
                                                      .fullName!,
                                                ),
                                          )
                                          .toList(),
                                      onSelected: (member) => setState(() {
                                        selectedSpeaker = member;
                                      }),
                                      selection: selectedSpeaker,
                                      hintText: l10n.speaker,
                                      emptyText: 'No subscribers found',
                                    ),
                              ),
                        )
                        .animate(delay: PRFMotionTokens.standard)
                        .slideX(begin: -0.2)
                        .fadeIn(),

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
                                    listLoading: () => const Center(
                                      child: LinearProgressIndicator(),
                                    ),
                                    listLoaded: (classes, _, _) =>
                                        PRFSearchableList<PRFClassGroup>(
                                          entries: classes
                                              .map(
                                                (classGroup) =>
                                                    PRFSearchableListEntry<
                                                      PRFClassGroup
                                                    >(
                                                      value: classGroup,
                                                      label: classGroup.name,
                                                    ),
                                              )
                                              .toList(),
                                          onSelected: (classGroup) =>
                                              setState(() {
                                                selectedClassGroup = classGroup;
                                              }),
                                          selection: selectedClassGroup,
                                          hintText: l10n.classGroup,
                                          emptyText: 'No class groups found',
                                        ),
                                  );
                                },
                              ),
                        )
                        .animate(delay: PRFMotionTokens.slow)
                        .slideX(begin: -0.2)
                        .fadeIn(),

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
                              errorText: _showValidation
                                  ? _startTimeError
                                  : null,
                            ),
                          ),
                        )
                        .animate(delay: PRFMotionTokens.slow)
                        .slideX(begin: -0.2)
                        .fadeIn(),

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
                        )
                        .animate(delay: PRFMotionTokens.enterShort)
                        .slideX(begin: -0.2)
                        .fadeIn(),

                    PRFFormSection(
                          icon: Icons.notes_outlined,
                          title: l10n.notes,
                          isRequired: true,
                          child: PRFTextAreaInput(
                            hintText: l10n.notes,
                            controller: _notesController,
                            errorText: _showValidation ? _notesError : null,
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
                  .animate(delay: 700.ms)
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

    await context.read<MissionSessionResourceCubit>().addSession(
      data: {
        'mission_ulid': widget.missionUlid,
        'facilitator_ulid': selectedFacilitator!.ulid,
        'starts_at': startsAt!.toIso8601String(),
        'ends_at': endsAt!.toIso8601String(),
        'notes': _notesController.text,
        if (selectedSpeaker?.ulid != null)
          'speaker_ulid': selectedSpeaker!.ulid,
        if (selectedClassGroup?.ulid != null)
          'class_group_ulid': selectedClassGroup!.ulid,
      },
    );
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
