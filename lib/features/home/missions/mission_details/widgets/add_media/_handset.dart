import 'dart:io';

import 'package:app/enums/prf_media_model.dart';
import 'package:app/features/home/missions/cubit/add_debrief_note_cubit.dart';
import 'package:app/features/home/missions/cubit/get_mission_media_cubit.dart';
import 'package:app/features/home/missions/cubit/select_media_cubit.dart';
import 'package:app/features/home/missions/cubit/upload_media_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/prf_image_dto.dart';
import 'package:app/utils/_index.dart';
import 'package:app/widgets/_index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddMediaViewHandset extends StatefulWidget {
  const AddMediaViewHandset({
    required this.missionUlid,
    super.key,
  });

  final String missionUlid;

  @override
  State<AddMediaViewHandset> createState() => _AddMediaViewHandsetState();
}

class _AddMediaViewHandsetState extends State<AddMediaViewHandset> {
  bool _isLoading = false;
  // List<PRFImageDTO> _selectedImages = [];

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
                  initial: () => GestureDetector(
                    onTap: () => context.read<SelectMediaCubit>().selectMedia(
                          context: context,
                          model: PRFMediaModel.missionPhotos,
                          modelUlid: widget.missionUlid,
                        ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          l10n.tapToAdd,
                          textAlign: TextAlign.center,
                          style:
                              CustomTextTheme.customTextTheme().headlineSmall,
                        ),
                        Icon(
                          Icons.insert_photo_outlined,
                          size: 24.sp,
                          color: const Color(0xffc4c4c4),
                        ),
                      ],
                    ),
                  ),
                  loaded: (images) {
                    if (images.isNotEmpty) {
                      // _selectedImages = images;
                      return Row(
                        children: [
                          Flexible(
                            flex: 8,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * .75,
                              height: 200,
                              child: PageView.builder(
                                itemCount: images.length,
                                itemBuilder: (context, index) {
                                  return Image.file(
                                    File(images[index].path),
                                    fit: BoxFit.fitWidth,
                                    color: Colors.black54,
                                    colorBlendMode: BlendMode.darken,
                                  );
                                },
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.clear,
                                    size: 20,
                                  ),
                                  onPressed: () => context
                                      .read<SelectMediaCubit>()
                                      .clearMedia(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                    return GestureDetector(
                      onTap: () => context.read<SelectMediaCubit>().selectMedia(
                            context: context,
                            model: PRFMediaModel.missionPhotos,
                            modelUlid: widget.missionUlid,
                          ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            l10n.tapToAdd,
                            textAlign: TextAlign.center,
                            style:
                                CustomTextTheme.customTextTheme().headlineSmall,
                          ),
                          Icon(
                            Icons.insert_photo_outlined,
                            size: 24.sp,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              PrimaryButton(
                title: l10n.upload,
                disabled: false,
                onPressed: () async {
                  Navigator.of(context).pop(); // Close the dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.willUpload),
                    ),
                  ); // Notify the user that the images will be uploaded
                  await context.read<UploadMediaCubit>().uploadMedia();
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
