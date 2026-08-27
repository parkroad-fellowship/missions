import 'dart:io';

import 'package:app/enums/prf_media_model.dart';
import 'package:app/enums/prf_media_type.dart';
import 'package:app/l10n/arb/app_localizations.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/media/prf_media_dto.dart';
import 'package:app/shared/media_upload/cubit/select_media_cubit.dart';
import 'package:app/shared/media_upload/cubit/upload_media_cubit.dart';
import 'package:app/shared/media_upload/widgets/offline_audio_recorder_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class AddEventMediaViewHandset extends StatefulWidget {
  const AddEventMediaViewHandset({required this.eventUlid, super.key});

  final String eventUlid;

  @override
  State<AddEventMediaViewHandset> createState() =>
      _AddEventMediaViewHandsetState();
}

class _AddEventMediaViewHandsetState extends State<AddEventMediaViewHandset> {
  @override
  void initState() {
    context.read<SelectMediaCubit>().clearMedia();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(PRFSpacingTokens.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PRFSectionHeader(
            title: context.l10n.addEventPhotos_2,
            subtitle: context.l10n.sharePhotosAndMemoriesFromThisEvent,
          ),
          const SizedBox(height: PRFSpacingTokens.xxl),

          // Media Selection Area
          Expanded(
            child: BlocBuilder<SelectMediaCubit, SelectMediaState>(
              builder: (context, state) => state.maybeWhen(
                orElse: () => _buildEmptyState(context, theme, l10n),
                empty: () => _buildEmptyState(context, theme, l10n),
                loaded: (images) => _buildImageGrid(context, theme, images),
                error: (message) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error,
                        size: 64,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(height: PRFSpacingTokens.lg),
                      Text(
                        message,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: PRFSpacingTokens.lg),
                      PRFButton(
                        variant: PRFButtonVariant.secondary,
                        onPressed: () =>
                            _selectMedia(context, previousMedia: []),
                        title: context.l10n.wrappedTryAgain,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: PRFSpacingTokens.xl),

          // Action Buttons
          BlocBuilder<SelectMediaCubit, SelectMediaState>(
            builder: (context, state) {
              final isDisabled = state.maybeWhen(
                loaded: (media) => media.isEmpty,
                orElse: () => true,
              );

              return Column(
                children: [
                  PRFButton(
                    variant: PRFButtonVariant.secondary,
                    title: context.l10n.recordAudio,
                    onPressed: () => _openAudioRecorder(context),
                  ),
                  const SizedBox(height: PRFSpacingTokens.md),
                  PRFButton(
                    title: l10n.upload,
                    disabled: isDisabled,
                    onPressed: isDisabled
                        ? () {}
                        : () async {
                            Navigator.of(context).pop();
                            PRFSnackbar.info(context, l10n.willUpload);
                            await context
                                .read<UploadMediaCubit>()
                                .uploadMedia();
                          },
                  ),
                  const SizedBox(height: PRFSpacingTokens.md),
                  PRFButton(
                    variant: PRFButtonVariant.secondary,
                    title: l10n.cancel,
                    onPressed: () async {
                      Navigator.of(context).pop();
                      context.read<SelectMediaCubit>().clearMedia();
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(PRFSpacingTokens.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PRFSectionHeader(
              title: context.l10n.addEventPhotos_2,
              subtitle: context.l10n.sharePhotosAndMemoriesFromThisEvent,
            ),
            const SizedBox(height: PRFSpacingTokens.xxl),

            // Media Selection Area
            Expanded(
              child: BlocBuilder<SelectMediaCubit, SelectMediaState>(
                builder: (context, state) => state.maybeMap(
                  orElse: () => _buildEmptyState(context, theme, l10n),
                  empty: (_) => _buildEmptyState(context, theme, l10n),
                  loaded: (result) =>
                      _buildImageGrid(context, theme, result.media),
                  error: (error) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error,
                          size: 64,
                          color: theme.colorScheme.error,
                        ),
                        const SizedBox(height: PRFSpacingTokens.lg),
                        Text(
                          error.message,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: PRFSpacingTokens.lg),
                        PRFButton(
                          variant: PRFButtonVariant.secondary,
                          onPressed: () =>
                              _selectMedia(context, previousMedia: []),
                          title: context.l10n.wrappedTryAgain,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: PRFSpacingTokens.xl),

            // Action Buttons
            BlocBuilder<SelectMediaCubit, SelectMediaState>(
              builder: (context, state) {
                final isDisabled = state.maybeWhen(
                  loaded: (media) => media.isEmpty,
                  orElse: () => true,
                );

                return Column(
                  children: [
                    PRFButton(
                      variant: PRFButtonVariant.secondary,
                      title: context.l10n.recordAudio,
                      onPressed: () => _openAudioRecorder(context),
                    ),
                    const SizedBox(height: PRFSpacingTokens.md),
                    PRFButton(
                      title: l10n.upload,
                      disabled: isDisabled,
                      onPressed: isDisabled
                          ? () {}
                          : () async {
                              Navigator.of(context).pop();
                              PRFSnackbar.info(context, l10n.willUpload);
                              await context
                                  .read<UploadMediaCubit>()
                                  .uploadMedia();
                            },
                    ),
                    const SizedBox(height: PRFSpacingTokens.md),
                    PRFButton(
                      variant: PRFButtonVariant.secondary,
                      title: l10n.cancel,
                      onPressed: () async {
                        Navigator.of(context).pop();
                        context.read<SelectMediaCubit>().clearMedia();
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageGrid(
    BuildContext context,
    ThemeData theme,
    List<PRFMediaDTO> images,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              context.l10n.selectedPhotos,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: PRFSpacingTokens.sm),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: PRFSpacingTokens.sm,
                vertical: PRFSpacingTokens.xs,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
              ),
              child: Text(
                '${images.length}',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: PRFSpacingTokens.lg),
        Expanded(
          child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: PRFSpacingTokens.md,
              mainAxisSpacing: PRFSpacingTokens.md,
            ),
            itemCount: images.length + 1,
            itemBuilder: (context, index) {
              if (index == images.length) {
                return _buildAddMoreTile(context, theme, images);
              }
              return _buildImageTile(context, theme, images[index], index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAddMoreTile(
    BuildContext context,
    ThemeData theme,
    List<PRFMediaDTO> images,
  ) {
    return GestureDetector(
      onTap: () => _selectMedia(context, previousMedia: images),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(
              alpha: PRFOpacities.glow,
            ),
            width: 2,
          ),
          color: theme.colorScheme.primary.withValues(
            alpha: PRFOpacities.faint,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_rounded,
              size: 32,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: PRFSpacingTokens.sm),
            Text(
              context.l10n.addMore,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageTile(
    BuildContext context,
    ThemeData theme,
    PRFMediaDTO image,
    int index,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
        boxShadow: [
          BoxShadow(
            color: PRFColors.black.withValues(alpha: PRFOpacities.subtle),
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
            Image.file(
              File(image.path),
              fit: BoxFit.cover,
            ),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    PRFColors.black.withValues(alpha: PRFOpacities.glow),
                  ],
                ),
              ),
            ),
            // Remove button
            Positioned(
              top: PRFSpacingTokens.sm,
              right: PRFSpacingTokens.sm,
              child: GestureDetector(
                onTap: () {
                  // Remove image logic would go here
                  // For now, we'll just show a snackbar
                  PRFSnackbar.info(
                    context,
                    context.l10n.removeNotImplemented,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(PRFSpacingTokens.xs),
                  decoration: BoxDecoration(
                    color: PRFColors.black.withValues(
                      alpha: PRFOpacities.prominent,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: PRFColors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectMedia(
    BuildContext context, {
    required List<PRFMediaDTO> previousMedia,
  }) {
    context.read<SelectMediaCubit>().selectMedia(
      context: context,
      model: PRFMediaModel.eventPhotos,
      modelUlid: widget.eventUlid,
      previousMedia: previousMedia.cast(),
      mediaType: PRFMediaType.photos,
    );
  }

  Future<void> _openAudioRecorder(BuildContext context) async {
    await PRFBottomSheet.show<void>(
      context,
      title: context.l10n.recordEventAudio,
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.8,
        child: OfflineAudioRecorderSheet(
          model: PRFMediaModel.eventAudios,
          modelUlid: widget.eventUlid,
        ),
      ),
    );
  }
}
