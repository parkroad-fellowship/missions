import 'package:app/enums/prf_media_model.dart';
import 'package:app/features/events/cubit/event_media_resource_cubit.dart';
import 'package:app/features/events/event_details/gallery/_shared.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/media/prf_media.dart';
import 'package:app/shared/media_upload/cubit/upload_media_cubit.dart';
import 'package:app/shared/media_upload/widgets/audio_player_widget.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaimon/gaimon.dart';
import 'package:prf_design/prf_design.dart';

class EventGalleryViewTablet extends StatefulWidget {
  const EventGalleryViewTablet({required this.eventUlid, super.key});

  final String eventUlid;

  @override
  State<EventGalleryViewTablet> createState() => _EventGalleryViewTabletState();
}

class _EventGalleryViewTabletState extends State<EventGalleryViewTablet> {
  late final _form = EventGalleryFormState(eventUlid: widget.eventUlid);

  @override
  void initState() {
    super.initState();
    _form
      ..attach(() => setState(() {}))
      ..load(context);
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: RefreshIndicator(
          onRefresh: () async => _form.load(context),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Progress indicator for images uploading in the background
              BlocConsumer<UploadMediaCubit, UploadMediaState>(
                listener: (context, state) {
                  state.mapOrNull(
                    loaded: (_) {
                      _form.load(context);
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
                          borderRadius: BorderRadius.circular(
                            PRFRadiusTokens.sm,
                          ),
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
                    PRFSpacingTokens.md,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SegmentedButton<PRFMediaModel>(
                      segments: [
                        ButtonSegment<PRFMediaModel>(
                          value: PRFMediaModel.eventPhotos,
                          icon: const Icon(Icons.photo_library_outlined),
                          label: Text(context.l10n.photos),
                        ),
                        ButtonSegment<PRFMediaModel>(
                          value: PRFMediaModel.eventAudios,
                          icon: const Icon(Icons.mic_outlined),
                          label: Text(context.l10n.recordings),
                        ),
                      ],
                      selected: {_form.selectedModel},
                      onSelectionChanged: (selection) {
                        _form.setModel(selection.first, context);
                      },
                    ),
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
                              label: _form.isAudioMode
                                  ? l10n.addRecordings
                                  : l10n.addPhotos,
                              description: _form.isAudioMode
                                  ? l10n.recordingsCaptureBody
                                  : l10n.addEventPhotos,
                              icon: _form.isAudioMode
                                  ? Icons.mic_none_outlined
                                  : Icons.photo_camera_outlined,
                              actionLabel: _form.isAudioMode
                                  ? l10n.recordAudio
                                  : l10n.addPhotos,
                              onActionPressed: () => triggerAddMediaModal(
                                context,
                                widget.eventUlid,
                                _form.isAudioMode,
                              ),
                            ),
                          ),
                        );
                      }

                      if (_form.isAudioMode) {
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
                                  child: buildAddTile(
                                    context,
                                    theme,
                                    _form.isAudioMode,
                                    () => triggerAddMediaModal(
                                      context,
                                      widget.eventUlid,
                                      _form.isAudioMode,
                                    ),
                                  ),
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
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 220,
                            crossAxisSpacing: PRFSpacingTokens.md,
                            mainAxisSpacing: PRFSpacingTokens.md,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              if (index == 0) {
                                return buildAddTile(
                                  context,
                                  theme,
                                  _form.isAudioMode,
                                  () => triggerAddMediaModal(
                                    context,
                                    widget.eventUlid,
                                    _form.isAudioMode,
                                  ),
                                );
                              }

                              final mediaIndex = index - 1;
                              return buildPhotoTile(
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
                        child: PRFEmptyView(
                          label: l10n.errorLoadingPhotos,
                          description: error,
                          icon: Icons.error_outline,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
