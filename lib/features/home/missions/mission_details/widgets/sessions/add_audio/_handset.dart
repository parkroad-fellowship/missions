import 'dart:io';

import 'package:app/enums/prf_media_model.dart';
import 'package:app/features/home/missions/cubit/select_media_cubit.dart';
import 'package:app/features/home/missions/cubit/upload_media_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/utils/_index.dart';
import 'package:app/widgets/_index.dart';
import 'package:app/widgets/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class AddAudioViewHandset extends StatefulWidget {
  const AddAudioViewHandset({
    required this.missionSessionUlid,
    super.key,
  });

  final String missionSessionUlid;

  @override
  State<AddAudioViewHandset> createState() => _AddAudioViewHandsetState();
}

class _AddAudioViewHandsetState extends State<AddAudioViewHandset> {
  @override
  void initState() {
    context.read<SelectMediaCubit>().clearMedia();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              BlocBuilder<SelectMediaCubit, SelectMediaState>(
                builder: (context, state) => state.when(
                  initial: () => ListTile(
                    title: Text(
                      l10n.tapToAdd,
                      style: CustomTextTheme.customTextTheme().displayLarge,
                    ),
                    leading: const Icon(
                      Icons.speaker,
                      size: 32,
                      color: Color(0xffc4c4c4),
                    ),
                    onTap: () =>
                        context.read<SelectMediaCubit>().selectAudioFiles(
                              model: PRFMediaModel.missionSessionAudios,
                              modelUlid: widget.missionSessionUlid,
                            ),
                  ),
                  loaded: (files) {
                    if (files.isNotEmpty) {
                      return Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: files.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: const Icon(
                                  Icons.audio_file,
                                  color: Color(0xffc4c4c4),
                                ),
                                title: Text(
                                  files[index].name,
                                  style: CustomTextTheme.customTextTheme()
                                      .bodyLarge,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          SecondaryButton(
                            onPressed: () => context
                                .read<SelectMediaCubit>()
                                .selectAudioFiles(
                                  model: PRFMediaModel.missionSessionAudios,
                                  modelUlid: widget.missionSessionUlid,
                                  previousMedia: files,
                                ),
                            title: l10n.addMore,
                            disabled: false,
                          )
                        ],
                      );
                    }
                    return ListTile(
                      title: Text(
                        l10n.tapToAdd,
                        style: CustomTextTheme.customTextTheme().displayLarge,
                      ),
                      leading: const Icon(
                        Icons.speaker,
                        size: 32,
                        color: Color(0xffc4c4c4),
                      ),
                      onTap: () =>
                          context.read<SelectMediaCubit>().selectAudioFiles(
                                model: PRFMediaModel.missionSessionAudios,
                                modelUlid: widget.missionSessionUlid,
                              ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),
              BlocBuilder<SelectMediaCubit, SelectMediaState>(
                builder: (context, state) {
                  final isDisabled = state.maybeWhen(
                    loaded: (media) => media.isEmpty,
                    orElse: () => true,
                  );

                  return PrimaryButton(
                    title: l10n.upload,
                    disabled: isDisabled,
                    onPressed: isDisabled
                        ? () {}
                        : () async {
                            Navigator.of(context).pop(); // Close the dialog
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.willUpload),
                              ),
                            );
                            await context
                                .read<UploadMediaCubit>()
                                .uploadMedia();
                          },
                  );
                },
              ),
              const SizedBox(height: 16),
              SecondaryButton(
                title: l10n.cancel,
                disabled: false,
                onPressed: () async {
                  Navigator.of(context).pop(); // Close the dialog
                  context.read<SelectMediaCubit>().clearMedia();
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
