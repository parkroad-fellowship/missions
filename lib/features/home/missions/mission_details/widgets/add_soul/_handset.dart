import 'package:app/features/home/missions/cubit/add_soul_cubit.dart';
import 'package:app/features/home/missions/cubit/get_class_groups_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/prf_class_group.dart';
import 'package:app/utils/_index.dart';
import 'package:app/widgets/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddSoulViewHandset extends StatefulWidget {
  const AddSoulViewHandset({
    required this.missionUlid,
    super.key,
  });

  final String missionUlid;

  @override
  State<AddSoulViewHandset> createState() => _AddSoulViewHandsetState();
}

class _AddSoulViewHandsetState extends State<AddSoulViewHandset> {
  final _fullNameController = TextEditingController();
  bool _isLoading = false;

  PRFClassGroup? selectedClassGroup;

  @override
  void initState() {
    context.read<GetClassGroupsCubit>().getClassGroups();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: FormFieldLabel(
              label: l10n.classGroup,
              isRequired: true,
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
                        hintStyle: CustomTextTheme.customTextTheme()
                            .headlineSmall!
                            .copyWith(
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
              label: l10n.fullName,
              isRequired: true,
              color: AppTheme.appTheme().kBlackColor,
            ),
          ),
          const SizedBox(height: 6),
          InputFormField(
            hintText: l10n.fullName,
            controller: _fullNameController,
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.soulRecorded),
                    ),
                  );
                  Navigator.of(context).pop();
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
                    if (selectedClassGroup == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.selectClass),
                        ),
                      );
                      return;
                    }
                    await context.read<AddSoulCubit>().addSoul(
                          missionUlid: widget.missionUlid,
                          classGroupUlid: selectedClassGroup!.ulid,
                          fullName: _fullNameController.text,
                        );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
