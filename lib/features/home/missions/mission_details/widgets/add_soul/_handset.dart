import 'package:app/features/home/missions/cubit/add_soul_cubit.dart';
import 'package:app/features/home/missions/cubit/get_class_groups_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/prf_class_group.dart';
import 'package:app/widgets/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaimon/gaimon.dart';

class AddSoulViewHandset extends StatefulWidget {
  const AddSoulViewHandset({required this.missionUlid, super.key});

  final String missionUlid;

  @override
  State<AddSoulViewHandset> createState() => _AddSoulViewHandsetState();
}

class _AddSoulViewHandsetState extends State<AddSoulViewHandset> {
  final _fullNameController = TextEditingController();
  final _admissionNumberController = TextEditingController();
  bool _isLoading = false;

  PRFClassGroup? selectedClassGroup;

  @override
  void initState() {
    super.initState();
    context.read<GetClassGroupsCubit>().getClassGroups(
      missionUlid: widget.missionUlid,
    );
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
              child: FormFieldLabel(label: l10n.classGroup, isRequired: true),
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
                          );
                        },
                      ),
                );
              },
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: FormFieldLabel(label: l10n.fullName, isRequired: true),
            ),
            const SizedBox(height: 6),
            PRFNameInput(
              hintText: l10n.fullName,
              controller: _fullNameController,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: FormFieldLabel(
                label: l10n.admissionNumber,
                isRequired: true,
              ),
            ),
            const SizedBox(height: 6),
            PRFNameInput(
              hintText: l10n.admissionNumber,
              controller: _admissionNumberController,
            ),
            const SizedBox(height: 16),
            BlocConsumer<AddSoulCubit, AddSoulState>(
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
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(l10n.soulRecorded)));
                  },
                  error: (error) {
                    setState(() {
                      _isLoading = false;
                    });
                    Gaimon.error();
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(error.message)));
                  },
                );
              },
              builder: (context, state) {
                return state.maybeWhen(
                  orElse:
                      () => PRFPrimaryButton(
                        title: _isLoading ? l10n.recording : l10n.record,
                        disabled: _isLoading,
                        isLoading: _isLoading ? true : null,
                        onPressed: () async {
                          if (selectedClassGroup == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.selectClass)),
                            );
                            Gaimon.warning();
                            return;
                          }

                          if (_fullNameController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.enterName)),
                            );
                            Gaimon.warning();
                            return;
                          }

                          await context.read<AddSoulCubit>().addSoul(
                            missionUlid: widget.missionUlid,
                            classGroup: selectedClassGroup!,
                            fullName: _fullNameController.text,
                            admissionNumber: _admissionNumberController.text,
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
