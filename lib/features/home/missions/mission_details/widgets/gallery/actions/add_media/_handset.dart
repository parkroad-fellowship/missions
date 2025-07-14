import 'dart:io';

import 'package:app/enums/prf_media_model.dart';
import 'package:app/features/home/missions/cubit/select_media_cubit.dart';
import 'package:app/features/home/missions/cubit/upload_media_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/prf_media_dto.dart';
import 'package:app/widgets/_index.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class AddMediaViewHandset extends StatefulWidget {
  const AddMediaViewHandset({required this.missionUlid, super.key});

  final String missionUlid;

  @override
  State<AddMediaViewHandset> createState() => _AddMediaViewHandsetState();
}

class _AddMediaViewHandsetState extends State<AddMediaViewHandset> {
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
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Text(
            l10n.addMissionPhotos,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.addMissionPhotosDesc,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 32),

          // Media Selection Area
          Expanded(
            child: BlocBuilder<SelectMediaCubit, SelectMediaState>(
              builder: (context, state) => state.when(
                initial: () => _buildEmptyState(context, theme),
                empty: () => _buildEmptyState(context, theme),
                loaded: (images) => _buildImageGrid(context, theme, images),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Action Buttons
          BlocBuilder<SelectMediaCubit, SelectMediaState>(
            builder: (context, state) {
              final isDisabled = state.maybeWhen(
                loaded: (media) => media.isEmpty,
                orElse: () => true,
              );

              return Column(
                children: [
                  PRFPrimaryButton(
                    title: l10n.upload,
                    disabled: isDisabled,
                    onPressed: isDisabled
                        ? () {}
                        : () async {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.willUpload)),
                            );
                            await context
                                .read<UploadMediaCubit>()
                                .uploadMedia();
                          },
                  ),
                  const SizedBox(height: 12),
                  PRFSecondaryButton(
                    title: l10n.cancel,
                    disabled: false,
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

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Center(
      child: GestureDetector(
        onTap: () => _selectMedia(context, previousMedia: []),
        child: Container(
          padding: const EdgeInsets.all(48),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                ),
                child: Icon(
                  Icons.add_a_photo_outlined,
                  size: 48,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Tap to select photos',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Choose multiple photos to share',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
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
              'Selected Photos',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
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
        const SizedBox(height: 16),
        Expanded(
          child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
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
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            width: 2,
          ),
          color: theme.colorScheme.primary.withValues(alpha: 0.05),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_rounded,
              size: 32,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              'Add More',
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
                    Colors.black.withValues(alpha: 0.3),
                  ],
                ),
              ),
            ),
            // Remove button
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () {
                  // Remove image logic would go here
                  // For now, we'll just show a snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Remove functionality not implemented'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
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
      model: PRFMediaModel.missionPhotos,
      modelUlid: widget.missionUlid,
      previousMedia: previousMedia.cast(),
      mediaType: RequestType.image,
    );
  }
}
