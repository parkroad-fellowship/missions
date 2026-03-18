import 'package:app/enums/prf_media_model.dart';
import 'package:app/features/home/missions/mission_details/widgets/gallery/actions/add_media/add_media.dart';
import 'package:app/features/home/missions/mission_details/widgets/gallery/cubit/mission_media_resource_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/gallery/cubit/upload_media_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/gallery/video_player_widget.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/media/prf_media.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:gaimon/gaimon.dart';
import 'package:prf_design/prf_design.dart';

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
    context.read<MissionMediaResourceCubit>().loadMedia(
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
      onRefresh: () => context.read<MissionMediaResourceCubit>().loadMedia(
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
                  context.read<MissionMediaResourceCubit>().loadMedia(
                    missionUlid: missionUlid,
                    collections: [
                      PRFMediaModel.missionPhotos,
                      PRFMediaModel.missionVideos,
                    ],
                  );
                  Gaimon.success();
                  PRFSnackbar.success(context, l10n.doneUploading);
                },
                error: (error) {
                  Gaimon.error();
                  PRFSnackbar.error(context, error.message);
                },
              );
            },
            builder: (context, state) {
              return SliverToBoxAdapter(
                child: state.maybeWhen(
                  loading: () => Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: PRFSpacingTokens.lg,
                      vertical: PRFSpacingTokens.sm,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(PRFRadiusTokens.sm),
                      child: const PRFLinearProgressIndicator(),
                    ),
                  ),
                  orElse: () => const SizedBox.shrink(),
                ),
              );
            },
          ),

          // Gallery
          BlocBuilder<MissionMediaResourceCubit, ResourceState<PRFMedia>>(
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () => SliverFillRemaining(
                  child: Center(
                    child: PRFCircularProgressIndicator(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                listLoaded: (mediaItems, _, _) {
                  if (mediaItems.isEmpty) {
                    return SliverFillRemaining(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: PRFSpacingTokens.xxl,
                        ),
                        child: PRFEmptyView(
                          label: l10n.addMissionPhotos,
                          description: l10n.addMissionPhotosDesc,
                          icon: Icons.photo_camera_outlined,
                          actionLabel: l10n.addMissionPhotos,
                          onActionPressed: () => _showAddMediaModal(context),
                        ),
                      ),
                    );
                  }
                  return SliverPadding(
                    padding: const EdgeInsets.all(PRFSpacingTokens.lg),
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
                error: (error, _) => SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: theme.colorScheme.error,
                        ),
                        const SizedBox(height: PRFSpacingTokens.lg),
                        Text(
                          'Error loading media',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                        ),
                        const SizedBox(height: PRFSpacingTokens.sm),
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
        FadeEffect(duration: PRFMotionTokens.slow),
        ScaleEffect(duration: PRFMotionTokens.slow),
      ],
      child: GestureDetector(
        onTap: () => _showAddMediaModal(context),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
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
                padding: const EdgeInsets.all(PRFSpacingTokens.lg),
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
              const SizedBox(height: PRFSpacingTokens.md),
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
    final isVideo = _isVideoFile(mediaItem.temporaryURL);

    return Animate(
      delay: Duration(milliseconds: 100 * (index + 1)),
      effects: const [
        FadeEffect(duration: PRFMotionTokens.slow),
        SlideEffect(
          begin: Offset(0, 0.3),
          duration: PRFMotionTokens.slow,
        ),
      ],
      child: isVideo
          ? GestureDetector(
              onTap: () => _openVideoPlayer(context, mediaItem.temporaryURL),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
                  boxShadow: [
                    BoxShadow(
                      color: PRFColors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _buildVideoPlaceholder(theme),
                      // Gradient overlay for better visual appeal
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              PRFColors.transparent,
                              PRFColors.black.withValues(alpha: 0.2),
                            ],
                          ),
                        ),
                      ),
                      // Video indicator
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: PRFSpacingTokens.sm,
                            vertical: PRFSpacingTokens.xs,
                          ),
                          decoration: BoxDecoration(
                            color: PRFColors.black.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(
                              PRFRadiusTokens.xs,
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.play_arrow,
                                color: PRFColors.white,
                                size: 14,
                              ),
                              SizedBox(width: 2),
                              Text(
                                'Video',
                                style: TextStyle(
                                  color: PRFColors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Tap indicator for videos
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.9,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: PRFColors.black.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(PRFSpacingTokens.md),
                          child: const Icon(
                            Icons.play_arrow,
                            color: PRFColors.white,
                            size: 32,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : FullScreenWidget(
              disposeLevel: DisposeLevel.High,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
                  boxShadow: [
                    BoxShadow(
                      color: PRFColors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
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
                                color:
                                    theme.colorScheme.surfaceContainerHighest,
                                child: Center(
                                  child: PRFCircularProgressIndicator(
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              );
                            case LoadState.failed:
                              return ColoredBox(
                                color: theme.colorScheme.errorContainer,
                                child: Icon(
                                  Icons.broken_image_outlined,
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
                              PRFColors.transparent,
                              PRFColors.black.withValues(alpha: 0.2),
                            ],
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

  Widget _buildVideoPlaceholder(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surfaceContainerHigh,
            theme.colorScheme.surfaceContainer,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.videocam,
              size: 32,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: PRFSpacingTokens.sm),
            Text(
              'Video File',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isVideoFile(String url) {
    final lowercaseUrl = url.toLowerCase();
    return lowercaseUrl.contains('.mp4') ||
        lowercaseUrl.contains('.mov') ||
        lowercaseUrl.contains('.avi') ||
        lowercaseUrl.contains('.mkv') ||
        lowercaseUrl.contains('.webm') ||
        lowercaseUrl.contains('.m4v');
  }

  void _openVideoPlayer(BuildContext context, String videoUrl) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => VideoPlayerWidget(videoUrl: videoUrl),
      ),
    );
  }

  void _showAddMediaModal(BuildContext context) {
    PRFBottomSheet.show<void>(
      context,
      title: 'Add Media',
      child: AddMediaView(
        missionUlid: missionUlid,
      ),
    );
  }
}
