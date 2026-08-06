import 'package:app/enums/prf_media_model.dart';
import 'package:app/features/events/cubit/event_media_resource_cubit.dart';
import 'package:app/features/events/event_details/actions/add_media/add_media.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/media/prf_media.dart';
import 'package:app/shared/media_upload/cubit/upload_media_cubit.dart';
import 'package:app/shared/media_upload/widgets/audio_player_widget.dart';
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
  PRFMediaModel _selectedModel = PRFMediaModel.eventPhotos;

  bool get _isAudioMode => _selectedModel == PRFMediaModel.eventAudios;

  @override
  void initState() {
    context.read<EventMediaResourceCubit>().loadMedia(
      eventUlid: eventUlid,
      model: _selectedModel,
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
        model: _selectedModel,
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
                    model: _selectedModel,
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

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                PRFSpacingTokens.lg,
                PRFSpacingTokens.sm,
                PRFSpacingTokens.lg,
                0,
              ),
              child: SegmentedButton<PRFMediaModel>(
                segments: const [
                  ButtonSegment<PRFMediaModel>(
                    value: PRFMediaModel.eventPhotos,
                    icon: Icon(Icons.photo_library_outlined),
                    label: Text('Photos'),
                  ),
                  ButtonSegment<PRFMediaModel>(
                    value: PRFMediaModel.eventAudios,
                    icon: Icon(Icons.mic_outlined),
                    label: Text('Recordings'),
                  ),
                ],
                selected: {_selectedModel},
                onSelectionChanged: (selection) {
                  final next = selection.first;
                  if (next == _selectedModel) return;
                  setState(() => _selectedModel = next);
                  context.read<EventMediaResourceCubit>().loadMedia(
                    eventUlid: eventUlid,
                    model: next,
                  );
                },
              ),
            ),
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
                          label: _isAudioMode
                              ? 'Add recordings'
                              : l10n.addPhotos,
                          description: _isAudioMode
                              ? 'Record audio to capture event highlights.'
                              : l10n.addEventPhotos,
                          icon: _isAudioMode
                              ? Icons.mic_none_outlined
                              : Icons.photo_camera_outlined,
                          actionLabel: _isAudioMode
                              ? 'Record audio'
                              : l10n.addPhotos,
                          onActionPressed: () => _showAddMediaModal(context),
                        ),
                      ),
                    );
                  }

                  if (_isAudioMode) {
                    return SliverPadding(
                      padding: const EdgeInsets.all(PRFSpacingTokens.lg),
                      sliver: SliverList.builder(
                        itemCount: mediaItems.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                bottom: PRFSpacingTokens.md,
                              ),
                              child: _buildAddTile(context, theme),
                            );
                          }

                          final item = mediaItems[index - 1];
                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: PRFSpacingTokens.md,
                            ),
                            child: AudioPlayerWidget(
                              url: item.temporaryURL,
                              title: item.fileName,
                            ),
                          );
                        },
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.all(PRFSpacingTokens.lg),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: PRFSpacingTokens.md,
                            mainAxisSpacing: PRFSpacingTokens.md,
                          ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index == 0) {
                            return _buildAddTile(context, theme);
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

  Widget _buildAddTile(BuildContext context, ThemeData theme) {
    final title = _isAudioMode ? 'Record Audio' : 'Add Photos';
    final icon = _isAudioMode ? Icons.mic_outlined : Icons.add_a_photo_outlined;

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
                  icon,
                  size: 32,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: PRFSpacingTokens.md),
              Text(
                title,
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
                        Colors.transparent,
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
      title: _isAudioMode ? 'Record Audio' : 'Add Photos',
      child: AddEventMediaView(
        eventUlid: eventUlid,
      ),
    );
  }
}
