import 'package:app/enums/prf_media_model.dart';
import 'package:app/features/home/events/cubit/get_event_media_cubit.dart';
import 'package:app/features/home/events/event_details/add_media/add_media.dart';
import 'package:app/features/home/missions/cubit/upload_media_cubit.dart';
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

class EventGalleryViewHandset extends StatefulWidget {
  const EventGalleryViewHandset({required this.eventUlid, super.key});

  final String eventUlid;

  @override
  State<EventGalleryViewHandset> createState() =>
      _EventGalleryViewHandsetState();
}

class _EventGalleryViewHandsetState extends State<EventGalleryViewHandset> {
  String get eventUlid => widget.eventUlid;

  @override
  void initState() {
    context.read<GetEventMediaCubit>().getEventMedia(
      eventUlid: eventUlid,
      model: PRFMediaModel.eventPhotos,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return RefreshIndicator(
      onRefresh:
          () => context.read<GetEventMediaCubit>().getEventMedia(
            eventUlid: eventUlid,
            model: PRFMediaModel.eventPhotos,
          ),
      child: CustomScrollView(
        slivers: [
          // Progress indicator for images uploading in the background
          BlocConsumer<UploadMediaCubit, UploadMediaState>(
            listener: (context, state) {
              state.mapOrNull(
                loaded: (_) {
                  context.read<GetEventMediaCubit>().getEventMedia(
                    eventUlid: eventUlid,
                    model: PRFMediaModel.eventPhotos,
                  );
                  Gaimon.success();
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(l10n.doneUploading)));
                },
                error: (error) {
                  Gaimon.error();
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(error.message)));
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
          BlocBuilder<GetEventMediaCubit, GetEventMediaState>(
            builder: (context, state) {
              return state.maybeWhen(
                orElse:
                    () => const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                empty:
                    () => SliverFillRemaining(
                      child: Center(
                        child: PRFPrimaryButton(
                          title: l10n.addPhotos,
                          disabled: false,
                          onPressed:
                              () => WoltModalSheet.show<void>(
                                context: context,
                                pageListBuilder: (modalSheetContext) {
                                  return [
                                    WoltModalSheetPage(
                                      backgroundColor: Colors.white,
                                      surfaceTintColor: Colors.white,
                                      child: SizedBox(
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                            0.8,
                                        child: AddEventMediaView(
                                          eventUlid: eventUlid,
                                        ),
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
                        (context, index) => Animate(
                          effects: const [FadeEffect(), ScaleEffect()],
                          child: FullScreenWidget(
                            disposeLevel: DisposeLevel.High,
                            child: ExtendedImage.network(
                              mediaItems[index].temporaryURL,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        childCount: mediaItems.length,
                      ),
                    ),
                  );
                },
                error:
                    (error) =>
                        SliverToBoxAdapter(child: Center(child: Text(error))),
              );
            },
          ),
        ],
      ),
    );
  }
}
