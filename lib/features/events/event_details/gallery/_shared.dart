// ignore_for_file: avoid_positional_boolean_parameters
import 'package:app/enums/prf_media_model.dart';
import 'package:app/features/events/cubit/event_media_resource_cubit.dart';
import 'package:app/features/events/event_details/actions/add_media/add_media.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/media/prf_media.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:prf_design/prf_design.dart';

class EventGalleryFormState {
  EventGalleryFormState({required this.eventUlid});

  final String eventUlid;

  late final VoidCallback _rebuild;

  PRFMediaModel selectedModel = PRFMediaModel.eventPhotos;

  bool get isAudioMode => selectedModel == PRFMediaModel.eventAudios;

  // ignore: use_setters_to_change_properties
  void attach(VoidCallback rebuild) {
    _rebuild = rebuild;
  }

  void load(BuildContext context) {
    context.read<EventMediaResourceCubit>().loadMedia(
      eventUlid: eventUlid,
      model: selectedModel,
    );
  }

  void setModel(PRFMediaModel model, BuildContext context) {
    if (selectedModel == model) return;
    selectedModel = model;
    _rebuild();
    load(context);
  }

  void dispose() {}
}

void triggerAddMediaModal(
  BuildContext context,
  String eventUlid,
  bool isAudioMode,
) {
  PRFBottomSheet.show<void>(
    context,
    title: isAudioMode ? context.l10n.recordAudio : context.l10n.addPhotos,
    child: AddEventMediaView(
      eventUlid: eventUlid,
    ),
  );
}

Widget buildAddTile(
  BuildContext context,
  ThemeData theme,
  bool isAudioMode,
  VoidCallback onTap,
) {
  final title = isAudioMode ? 'Record Audio' : 'Add Photos';
  final icon = isAudioMode ? Icons.mic_outlined : Icons.add_a_photo_outlined;

  return Animate(
    effects: const [
      FadeEffect(duration: PRFMotionTokens.slow),
      ScaleEffect(duration: PRFMotionTokens.slow),
    ],
    child: GestureDetector(
      onTap: onTap,
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

Widget buildPhotoTile(BuildContext context, PRFMedia mediaItem, int index) {
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
