import 'package:app/enums/prf_media_model.dart';
import 'package:app/features/home/missions/cubit/get_mission_media_cubit.dart';
import 'package:app/features/home/missions/cubit/upload_media_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/add_media/add_media.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/widgets/_index.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:gaimon/gaimon.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class GalleryViewHandset extends StatefulWidget {
  const GalleryViewHandset({
    required this.missionUlid,
    super.key,
  });

  final String missionUlid;

  @override
  State<GalleryViewHandset> createState() => _GalleryViewHandsetState();
}

class _GalleryViewHandsetState extends State<GalleryViewHandset> {
  String get missionUlid => widget.missionUlid;

  @override
  void initState() {
    context.read<GetMissionMediaCubit>().getMissionMedia(
          missionUlid: missionUlid,
          model: PRFMediaModel.missionPhotos,
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return RefreshIndicator(
      onRefresh: () => context.read<GetMissionMediaCubit>().getMissionMedia(
            missionUlid: missionUlid,
            model: PRFMediaModel.missionPhotos,
          ),
      child: CustomScrollView(
        slivers: [
          // Progress indicator for images uploading in the background
          BlocConsumer<UploadMediaCubit, UploadMediaState>(
            listener: (context, state) {
              state.mapOrNull(
                loaded: (_) {
                  context.read<GetMissionMediaCubit>().getMissionMedia(
                        missionUlid: missionUlid,
                        model: PRFMediaModel.missionPhotos,
                      );
                      Gaimon.success();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.doneUploading),
                    ),
                  );
                },
                error: (error) {
                  Gaimon.error();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(error.message),
                    ),
                  );
                },
              );
            },
            builder: (context, state) {
              return SliverToBoxAdapter(
                child: state.maybeWhen(
                  loading: () => const LinearProgressIndicator(),
                  orElse: () => const SizedBox.shrink(),
                ),
              );
            },
          ),
          // Gallery

          BlocBuilder<GetMissionMediaCubit, GetMissionMediaState>(
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () => const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                ),
                empty: () => SliverFillRemaining(
                  child: Center(
                    child: PrimaryButton(
                      title: l10n.addPhotos,
                      disabled: false,
                      onPressed: () => WoltModalSheet.show<void>(
                        context: context,
                        pageListBuilder: (modalSheetContext) {
                          return [
                            WoltModalSheetPage(
                              backgroundColor: Colors.white,
                              surfaceTintColor: Colors.white,
                              child: SizedBox(
                                height: MediaQuery.sizeOf(context).height * 0.8,
                                child: AddMediaView(missionUlid: missionUlid),
                              ),
                            ),
                          ];
                        },
                      ),
                    ),
                  ),
                ),
                loaded: (mediaItems) {
                  return SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 16.w,
                        mainAxisSpacing: 16.h,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final mediaItem = mediaItems[index];
                          return Animate(
                            effects: const [
                              FadeEffect(),
                              ScaleEffect(),
                            ],
                            // duration: Duration(milliseconds: 500),
                            // animate: true,
                            // endOffset: Offset(0, 0),
                            // startOffset: Offset(0, 0.5),
                            child: FullScreenWidget(
                              disposeLevel: DisposeLevel.High,
                              child: ExtendedImage.network(
                                mediaItem.temporaryURL,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                        childCount: mediaItems.length,
                      ),
                    ),
                  );
                },
                error: (error) => SliverToBoxAdapter(
                  child: Center(
                    child: Text(error),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
