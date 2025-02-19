import 'package:app/features/home/missions/cubit/add_soul_cubit.dart';
import 'package:app/features/home/missions/cubit/get_class_groups_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/prf_class_group.dart';
import 'package:app/utils/_index.dart';
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
  bool _isLoading = false;

  PRFClassGroup? selectedClassGroup;

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
                label: l10n.classGroup,
                isRequired: true,
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
                label: l10n.fullName,
                isRequired: true,
                color: PRFApp.theme().kBlackColor,
              ),
            ),
            const SizedBox(height: 6),
            InputFormField(
              hintText: l10n.fullName,
              controller: _fullNameController,
              textCapitalization: TextCapitalization.words,
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
                      () => PrimaryButton(
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
