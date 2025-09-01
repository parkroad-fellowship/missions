import 'package:app/enums/prf_media_model.dart';
import 'package:app/features/home/missions/cubit/get_mission_media_cubit.dart';
import 'package:app/features/home/missions/cubit/upload_media_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/gallery/actions/add_media/add_media.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/prf_media.dart';
import 'package:app/shared_widgets/_index.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:gaimon/gaimon.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class GalleryViewHandset extends StatefulWidget {
  const GalleryViewHandset({required this.missionUlid, super.key});

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
      collections: [
        PRFMediaModel.missionPhotos,
        PRFMediaModel.missionVideos,
      ],
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: () => context.read<GetMissionMediaCubit>().getMissionMedia(
        missionUlid: missionUlid,
        collections: [
          PRFMediaModel.missionPhotos,
          PRFMediaModel.missionVideos,
        ],
      ),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Progress indicator for images uploading in the background
          BlocConsumer<UploadMediaCubit, UploadMediaState>(
            listener: (context, state) {
              state.mapOrNull(
                loaded: (_) {
                  context.read<GetMissionMediaCubit>().getMissionMedia(
                    missionUlid: missionUlid,
                    collections: [
                      PRFMediaModel.missionPhotos,
                      PRFMediaModel.missionVideos,
                    ],
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
                  loading: () => Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: const PRFLinearProgressIndicator(),
                    ),
                  ),
                  orElse: () => const SizedBox.shrink(),
                ),
              );
            },
          ),

          // Gallery
          BlocBuilder<GetMissionMediaCubit, GetMissionMediaState>(
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () => SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                empty: () => SliverFillRemaining(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: PRFEmptyView(
                      label: l10n.addPhotos,
                      description: l10n.addMissionPhotosDesc,
                      icon: Icons.photo_camera_outlined,
                      actionLabel: 'Add Media',
                      onActionPressed: () => _showAddMediaModal(context),
                    ),
                  ),
                ),
                loaded: (mediaItems) {
                  return SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index == 0) {
                            // Add photo tile
                            return _buildAddPhotoTile(context, theme);
                          }

                          final mediaIndex = index - 1;
                          return _buildPhotoTile(
                            context,
                            mediaItems[mediaIndex],
                            mediaIndex,
                          );
                        },
                        childCount: mediaItems.length + 1,
                      ),
                    ),
                  );
                },
                error: (error) => SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: theme.colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading photos',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          error,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAddPhotoTile(BuildContext context, ThemeData theme) {
    return Animate(
      effects: const [
        FadeEffect(duration: Duration(milliseconds: 300)),
        ScaleEffect(duration: Duration(milliseconds: 300)),
      ],
      child: GestureDetector(
        onTap: () => _showAddMediaModal(context),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
              width: 2,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primary.withValues(alpha: 0.05),
                theme.colorScheme.primary.withValues(alpha: 0.1),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                ),
                child: Icon(
                  Icons.add_a_photo_outlined,
                  size: 32,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Add Media',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoTile(BuildContext context, PRFMedia mediaItem, int index) {
    final theme = Theme.of(context);
    final isVideo =
        mediaItem.temporaryURL.toLowerCase().contains('.mp4') ||
        mediaItem.temporaryURL.toLowerCase().contains('.mov') ||
        mediaItem.temporaryURL.toLowerCase().contains('.avi');

    return Animate(
      delay: Duration(milliseconds: 100 * (index + 1)),
      effects: const [
        FadeEffect(duration: Duration(milliseconds: 400)),
        SlideEffect(
          begin: Offset(0, 0.3),
          duration: Duration(milliseconds: 400),
        ),
      ],
      child: FullScreenWidget(
        disposeLevel: DisposeLevel.High,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                ExtendedImage.network(
                  mediaItem.temporaryURL,
                  fit: BoxFit.cover,
                  loadStateChanged: (state) {
                    switch (state.extendedImageLoadState) {
                      case LoadState.loading:
                        return ColoredBox(
                          color: theme.colorScheme.surfaceContainerHighest,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: theme.colorScheme.primary,
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      case LoadState.failed:
                        return ColoredBox(
                          color: theme.colorScheme.errorContainer,
                          child: Icon(
                            isVideo
                                ? Icons.videocam_off_outlined
                                : Icons.broken_image_outlined,
                            color: theme.colorScheme.error,
                            size: 32,
                          ),
                        );
                      case LoadState.completed:
                        return null;
                    }
                  },
                ),
                // Gradient overlay for better visual appeal
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.1),
                      ],
                    ),
                  ),
                ),
                // Video indicator
                if (isVideo)
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddMediaModal(BuildContext context) {
    WoltModalSheet.show<void>(
      context: context,
      pageListBuilder: (modalSheetContext) {
        return [
          WoltModalSheetPage(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.8,
              child: AddMediaView(
                missionUlid: missionUlid,
              ),
            ),
          ),
        ];
      },
    );
  }
}
