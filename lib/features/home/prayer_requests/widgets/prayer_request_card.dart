import 'package:app/models/remote/prayer/prf_prayer_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:prf_design/prf_design.dart';

class PrayerRequestCard extends StatelessWidget {
  const PrayerRequestCard({required this.prayerRequest, super.key});

  final PRFPrayerRequest prayerRequest;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trimmedDescription = prayerRequest.description.trim();

    return InkWell(
      borderRadius: BorderRadius.circular(PRFRadiusTokens.xl),
      onTap: () => PRFBottomSheet.show<dynamic>(
        context,
        title: prayerRequest.title,
        child: Padding(
          padding: const EdgeInsets.all(PRFSpacingTokens.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(PRFSpacingTokens.md),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(
                        PRFRadiusTokens.md,
                      ),
                    ),
                    child: Icon(
                      Icons.hail_rounded,
                      color: theme.colorScheme.onPrimaryContainer,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: PRFSpacingTokens.lg),
                  Expanded(
                    child: Text(
                      prayerRequest.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: PRFSpacingTokens.xl),
              Text(
                prayerRequest.description,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(PRFRadiusTokens.xl),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(
              alpha: PRFOpacities.accent,
            ),
          ),
          boxShadow: PRFShadowTokens.raised(theme.colorScheme.primary),
        ),
        child: Padding(
          padding: const EdgeInsets.all(PRFSpacingTokens.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(PRFSpacingTokens.md),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
                    ),
                    child: Icon(
                      Icons.hail_rounded,
                      color: theme.colorScheme.onPrimaryContainer,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: PRFSpacingTokens.md),
                  Expanded(
                    child: Text(
                      prayerRequest.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(PRFSpacingTokens.xs),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
                    ),
                    child: Icon(
                      Icons.north_east_rounded,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: PRFSpacingTokens.md),
              Text(
                trimmedDescription,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ).animate(effects: const [SaturateEffect()]),
    );
  }
}
