import 'package:app/features/home/missions/cubit/get_class_groups_cubit.dart';
import 'package:app/features/home/missions/cubit/get_subscribers_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/sessions/cubit/add_mission_session_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/mission/prf_local_mission_subscription.dart';
import 'package:app/models/local/shared_embeds.dart';
import 'package:app/models/remote/member/prf_class_group.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:app/shared_widgets/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
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

  // Add form validity check
  bool get _isFormValid {
    return selectedFacilitator != null &&
        _notesController.text.isNotEmpty &&
        startsAt != null &&
        endsAt != null;
  }

  @override
  void initState() {
    super.initState();
    // Add listeners to update form validity
    _notesController.addListener(() => setState(() {}));
    context.read<GetSubscribersCubit>().getSubscriptions(
      missionUlid: widget.missionUlid,
    );
    context.read<GetClassGroupsCubit>().getClassGroups(
      missionUlid: widget.missionUlid,
    );
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),

              // Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
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
                    const SizedBox(height: 8),
                    Text(
                      'Create New Session',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Fill in the details below to record a new session',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onPrimary.withValues(alpha: 0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ).animate().slideY(begin: -0.3).fadeIn(duration: 600.ms),

              const SizedBox(height: 24),

              // Form Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
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
                    _buildFormSection(
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
                            widget: (context, subscribers) => LayoutBuilder(
                              builder: (context, constraints) {
                                return DropdownMenu<PRFLocalMember>(
                                  width: constraints.maxWidth,
                                  initialSelection: selectedFacilitator,
                                  hintText: l10n.facilitator,
                                  dropdownMenuEntries: subscribers
                                      .map(
                                        (subscriber) =>
                                            DropdownMenuEntry<PRFLocalMember>(
                                              value: subscriber.member,
                                              label:
                                                  subscriber.member.fullName!,
                                            ),
                                      )
                                      .toList(),
                                  onSelected: (member) => setState(() {
                                    selectedFacilitator = member;
                                  }),
                                );
                              },
                            ),
                          ),
                    ).animate(delay: 100.ms).slideX(begin: -0.2).fadeIn(),

                    _buildFormSection(
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
                            widget: (context, subscribers) => LayoutBuilder(
                              builder: (context, constraints) {
                                return DropdownMenu<PRFLocalMember>(
                                  width: constraints.maxWidth,
                                  initialSelection: selectedSpeaker,
                                  hintText: l10n.speaker,
                                  dropdownMenuEntries: subscribers
                                      .map(
                                        (subscriber) =>
                                            DropdownMenuEntry<PRFLocalMember>(
                                              value: subscriber.member,
                                              label:
                                                  subscriber.member.fullName!,
                                            ),
                                      )
                                      .toList(),
                                  onSelected: (member) => setState(() {
                                    selectedSpeaker = member;
                                  }),
                                );
                              },
                            ),
                          ),
                    ).animate(delay: 200.ms).slideX(begin: -0.2).fadeIn(),

                    _buildFormSection(
                      icon: Icons.group_outlined,
                      title: l10n.classGroup,
                      child:
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
                                            (classGroup) =>
                                                DropdownMenuEntry<
                                                  PRFClassGroup
                                                >(
                                                  value: classGroup,
                                                  label: classGroup.name,
                                                ),
                                          )
                                          .toList(),
                                      onSelected: (classGroup) => setState(() {
                                        selectedClassGroup = classGroup;
                                      }),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                    ).animate(delay: 300.ms).slideX(begin: -0.2).fadeIn(),

                    _buildFormSection(
                      icon: Icons.schedule_outlined,
                      title: l10n.startTime,
                      isRequired: true,
                      child: GestureDetector(
                        onTap: _selectStartDate,
                        child: PRFTextInput(
                          hintText: l10n.startTime,
                          controller: _startDateController,
                          enabled: false,
                        ),
                      ),
                    ).animate(delay: 400.ms).slideX(begin: -0.2).fadeIn(),

                    _buildFormSection(
                      icon: Icons.schedule_outlined,
                      title: l10n.endTime,
                      isRequired: true,
                      child: GestureDetector(
                        onTap: _selectEndDate,
                        child: PRFTextInput(
                          hintText: l10n.endTime,
                          controller: _endDateController,
                          enabled: false,
                        ),
                      ),
                    ).animate(delay: 500.ms).slideX(begin: -0.2).fadeIn(),

                    _buildFormSection(
                      icon: Icons.notes_outlined,
                      title: l10n.notes,
                      isRequired: true,
                      child: PRFTextAreaInput(
                        hintText: l10n.notes,
                        controller: _notesController,
                      ),
                    ).animate(delay: 600.ms).slideX(begin: -0.2).fadeIn(),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Submit Button
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
                      PRFSnackbar.success(context, l10n.sessionRecorded);
                    },
                    error: (error) {
                      setState(() {
                        _isLoading = false;
                      });
                      Gaimon.error();
                      PRFSnackbar.error(context, error.error);
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
              ).animate(delay: 700.ms).slideY(begin: 0.3).fadeIn(),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormSection({
    required IconData icon,
    required String title,
    required Widget child,
    bool isRequired = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              FormFieldLabel(label: title, isRequired: isRequired),
            ],
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Future<void> _submitForm() async {
    final l10n = context.l10n;

    if (selectedFacilitator == null) {
      PRFSnackbar.warning(context, l10n.selectFacilitator);
      Gaimon.warning();
      return;
    }

    if (_notesController.text.isEmpty) {
      PRFSnackbar.warning(context, l10n.enterNotes);
      Gaimon.warning();
      return;
    }

    if (startsAt == null) {
      PRFSnackbar.warning(context, l10n.addStartEnd);
      Gaimon.warning();
      return;
    }

    if (endsAt == null) {
      PRFSnackbar.warning(context, l10n.addStartEnd);
      Gaimon.warning();
      return;
    }

    await context.read<AddMissionSessionCubit>().addSession(
      missionUlid: widget.missionUlid,
      facilitatorUlid: selectedFacilitator!.ulid!,
      startsAt: startsAt!,
      endsAt: endsAt!,
      notes: _notesController.text,
      speakerUlid: selectedSpeaker?.ulid,
      classGroupUlid: selectedClassGroup?.ulid,
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
        });
        _endDateController.text = DateFormat.MMMMEEEEd().add_Hm().format(date);
      },
      currentTime: DateTime.now(),
    );
  }
}
