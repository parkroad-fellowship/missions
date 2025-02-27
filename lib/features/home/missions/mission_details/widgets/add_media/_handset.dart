import 'dart:io';

import 'package:app/enums/prf_media_model.dart';
import 'package:app/features/home/missions/cubit/select_media_cubit.dart';
import 'package:app/features/home/missions/cubit/upload_media_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/widgets/_index.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class AddMediaViewHandset extends StatefulWidget {
  const AddMediaViewHandset({required this.missionUlid, super.key});

  final String missionUlid;

  @override
  State<AddMediaViewHandset> createState() => _AddMediaViewHandsetState();
}

class _AddMediaViewHandsetState extends State<AddMediaViewHandset> {
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
                builder:
                    (context, state) => state.when(
                      initial:
                          () => ListTile(
                            title: Text(
                              l10n.tapToAdd,
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                            leading: const Icon(
                              Icons.insert_photo_outlined,
                              size: 32,
                              color: Color(0xffc4c4c4),
                            ),
                            onTap:
                                () => context
                                    .read<SelectMediaCubit>()
                                    .selectMedia(
                                      context: context,
                                      model: PRFMediaModel.missionPhotos,
                                      modelUlid: widget.missionUlid,
                                      mediaType: RequestType.image,
                                    ),
                          ),
                      empty:
                          () => ListTile(
                            title: Text(
                              l10n.tapToAdd,
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                            leading: const Icon(
                              Icons.insert_photo_outlined,
                              size: 32,
                              color: Color(0xffc4c4c4),
                            ),
                            onTap:
                                () => context
                                    .read<SelectMediaCubit>()
                                    .selectMedia(
                                      context: context,
                                      model: PRFMediaModel.missionPhotos,
                                      modelUlid: widget.missionUlid,
                                      mediaType: RequestType.image,
                                    ),
                          ),
                      loaded: (images) {
                        return SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.6,
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 4,
                                  mainAxisSpacing: 4,
                                ),
                            itemCount:
                                images.length +
                                1, // Add one more item for the picker tile
                            itemBuilder: (context, index) {
                              if (index == images.length) {
                                return GestureDetector(
                                  onTap: () {
                                    // Open the image picker
                                    context
                                        .read<SelectMediaCubit>()
                                        .selectMedia(
                                          context: context,
                                          model: PRFMediaModel.missionPhotos,
                                          modelUlid: widget.missionUlid,
                                          previousMedia: images,
                                          mediaType: RequestType.image,
                                        );
                                  },
                                  child: Container(
                                    color: Colors.grey[300],
                                    child: Icon(
                                      Icons.add,
                                      size: 50,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                );
                              }

                              return Image.file(
                                File(images[index].path),
                                fit: BoxFit.cover,
                              );
                            },
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

                  return PRFPrimaryButton(
                    title: l10n.upload,
                    disabled: isDisabled,
                    onPressed:
                        isDisabled
                            ? () {}
                            : () async {
                              Navigator.of(context).pop(); // Close the dialog
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(l10n.willUpload)),
                              );
                              await context
                                  .read<UploadMediaCubit>()
                                  .uploadMedia();
                            },
                  );
                },
              ),
              const SizedBox(height: 16),
              PRFSecondaryButton(
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
