import 'dart:io';

import 'package:app/enums/prf_media_model.dart';
import 'package:app/features/missions/mission_details/widgets/gallery/actions/add_media/add_media.dart';
import 'package:app/features/missions/mission_details/widgets/gallery/cubit/mission_media_resource_cubit.dart';
import 'package:app/features/missions/mission_details/widgets/gallery/video_player_widget.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/media/prf_media.dart';
import 'package:app/models/remote/mission/prf_mission.dart';
import 'package:app/shared/media_upload/cubit/upload_media_cubit.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaimon/gaimon.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:prf_design/prf_design.dart';

class GalleryViewHandset extends StatefulWidget {
  const GalleryViewHandset({required this.mission, super.key});

  final PRFMission mission;

  @override
  State<GalleryViewHandset> createState() => _GalleryViewHandsetState();
}

class _GalleryViewHandsetState extends State<GalleryViewHandset> {
  PRFMission get mission => widget.mission;

  Future<void> _loadMedia() =>
      context.read<MissionMediaResourceCubit>().loadMedia(
        missionUlid: mission.ulid,
        collections: [
          PRFMediaModel.missionPhotos,
          PRFMediaModel.missionVideos,
        ],
      );

  void _openCarousel(List<PRFMedia> mediaItems, int index) {
    final items = mediaItems
        .map(
          (m) => PRFCarouselItem(
            url: m.temporaryURL,
            isVideo: _isVideoFile(m.temporaryURL),
            id: m.uuid,
          ),
        )
        .toList();

    PRFMediaCarousel.show(
      context,
      items: items,
      initialIndex: index,
      onDelete: (i) => _deleteMedia(mediaItems[i]),
      onSave: _saveMedia,
      videoBuilder: (context, item) => VideoPlayerWidget(videoUrl: item.url),
    );
  }

  Future<bool> _deleteMedia(PRFMedia media) async {
    final l10n = context.l10n;

    final confirmed = await PRFConfirmationDialog.show(
      context,
      title: l10n.delete,
      message: 'Are you sure you want to delete this media?',
      confirmLabel: l10n.delete,
      isDestructive: true,
    );

    if (confirmed != true || !mounted) return false;

    await context.read<MissionMediaResourceCubit>().deleteMedia(
      missionUlid: mission.ulid,
      mediaUuid: media.uuid,
    );

    if (!mounted) return false;

    Gaimon.success();
    PRFSnackbar.success(context, 'Media deleted');
    await _loadMedia();
    return true;
  }

  Future<void> _saveMedia(PRFCarouselItem item) async {
    try {
      final response = await http.get(Uri.parse(item.url));
      if (response.statusCode != 200) throw Exception('Download failed');

      final tempDir = await getTemporaryDirectory();
      final ext = item.isVideo ? 'mp4' : 'jpg';
      final file = File(
        '${tempDir.path}/prf_media_${DateTime.now().millisecondsSinceEpoch}.$ext',
      );
      await file.writeAsBytes(response.bodyBytes);

      if (!mounted) return;
      Gaimon.success();
      PRFSnackbar.success(context, 'Saved to device');
    } catch (e) {
      if (!mounted) return;
      Gaimon.error();
      PRFSnackbar.error(context, 'Failed to save');
    }
  }

  void _showAddMediaModal() {
    PRFBottomSheet.show<void>(
      context,
      title: 'Add Media',
      child: AddMediaView(missionUlid: mission.ulid),
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

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: _loadMedia,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          // Upload progress
          BlocConsumer<UploadMediaCubit, UploadMediaState>(
            listener: (context, state) {
              state.mapOrNull(
                loaded: (_) {
                  _loadMedia();
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

          // Gallery grid
          BlocBuilder<MissionMediaResourceCubit, ResourceState<PRFMedia>>(
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () => _buildShimmerLoading(theme),
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
                          actionLabel: mission.canEdit
                              ? l10n.addMissionPhotos
                              : null,
                          onActionPressed: mission.canEdit
                              ? _showAddMediaModal
                              : null,
                        ),
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.all(PRFSpacingTokens.lg),
                    sliver: SliverToBoxAdapter(
                      child: PRFMediaGrid(
                        itemCount: mediaItems.length,
                        onAdd: mission.canEdit ? _showAddMediaModal : null,
                        itemBuilder: (context, index) {
                          final media = mediaItems[index];
                          final isVideo = _isVideoFile(media.temporaryURL);

                          return PRFMediaTile(
                            url: media.temporaryURL,
                            isVideo: isVideo,
                            height: _tileHeight(index),
                            onTap: () => _openCarousel(mediaItems, index),
                            imageBuilder: (context, url) =>
                                ExtendedImage.network(
                                  url,
                                  fit: BoxFit.cover,
                                  loadStateChanged: (state) {
                                    switch (state.extendedImageLoadState) {
                                      case LoadState.loading:
                                        return ColoredBox(
                                          color: theme
                                              .colorScheme
                                              .surfaceContainerHighest,
                                          child: Center(
                                            child: PRFCircularProgressIndicator(
                                              color: theme.colorScheme.primary,
                                            ),
                                          ),
                                        );
                                      case LoadState.failed:
                                        return ColoredBox(
                                          color:
                                              theme.colorScheme.errorContainer,
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
                          );
                        },
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

  /// Vary tile heights for the masonry effect.
  double _tileHeight(int index) {
    const heights = [180.0, 220.0, 160.0, 200.0, 190.0, 240.0];
    return heights[index % heights.length];
  }

  SliverToBoxAdapter _buildShimmerLoading(ThemeData theme) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(PRFSpacingTokens.lg),
        child: Column(
          children: List.generate(
            4,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: PRFSpacingTokens.sm),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: index.isEven ? 180 : 160,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(
                          PRFRadiusTokens.md,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: PRFSpacingTokens.sm),
                  Expanded(
                    child: Container(
                      height: index.isEven ? 160 : 200,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(
                          PRFRadiusTokens.md,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
