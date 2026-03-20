import 'package:app/enums/prf_media_model.dart';
import 'package:app/features/home/events/cubit/event_media_resource_cubit.dart';
import 'package:app/features/home/events/event_details/actions/add_media/add_media.dart';
import 'package:app/features/home/missions/mission_details/widgets/gallery/cubit/upload_media_cubit.dart';
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
    context.read<EventMediaResourceCubit>().loadMedia(
      eventUlid: eventUlid,
      model: PRFMediaModel.eventPhotos,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: () => context.read<EventMediaResourceCubit>().loadMedia(
        eventUlid: eventUlid,
        model: PRFMediaModel.eventPhotos,
      ),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Progress indicator for images uploading in the background
          BlocConsumer<UploadMediaCubit, UploadMediaState>(
            listener: (context, state) {
              state.mapOrNull(
                loaded: (_) {
                  context.read<EventMediaResourceCubit>().loadMedia(
                    eventUlid: eventUlid,
                    model: PRFMediaModel.eventPhotos,
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
          BlocBuilder<EventMediaResourceCubit, ResourceState<PRFMedia>>(
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
                          label: l10n.addPhotos,
                          description: l10n.addEventPhotos,
                          icon: Icons.photo_camera_outlined,
                          actionLabel: l10n.addPhotos,
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
                          l10n.errorLoadingPhotos,
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
                'Add Photos',
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

    return Animate(
      delay: Duration(milliseconds: 100 * (index + 1)),
      effects: const [
        FadeEffect(duration: PRFMotionTokens.slow),
        SlideEffect(
          begin: Offset(0, 0.3),
          duration: PRFMotionTokens.slow,
        ),
      ],
      child: FullScreenWidget(
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
                          color: theme.colorScheme.surfaceContainerHighest,
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
                        PRFColors.black.withValues(alpha: 0.1),
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

  void _showAddMediaModal(BuildContext context) {
    PRFBottomSheet.show<void>(
      context,
      title: 'Add Photos',
      child: AddEventMediaView(
        eventUlid: eventUlid,
      ),
    );
  }
}
