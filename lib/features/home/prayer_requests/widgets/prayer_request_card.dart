import 'package:app/models/remote/prayer/prf_prayer_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:prf_design/prf_design.dart';

class PrayerRequestCard extends StatelessWidget {
  const PrayerRequestCard({required this.prayerRequest, super.key});

  final PRFPrayerRequest prayerRequest;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => WoltModalSheet.show<dynamic>(
        context: context,
        pageListBuilder: (modalSheetContext) => [
          WoltModalSheetPage(
            backgroundColor: theme.colorScheme.surface,
            surfaceTintColor: Colors.transparent,
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
                          borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
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
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
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
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(PRFSpacingTokens.xl),
        margin: const EdgeInsets.symmetric(horizontal: PRFSpacingTokens.lg, vertical: PRFSpacingTokens.sm),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: .08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: .04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: .1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon and title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(PRFSpacingTokens.md),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
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
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            const SizedBox(height: PRFSpacingTokens.lg),

            // Description preview
            Text(
              prayerRequest.description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ).animate(effects: const [SaturateEffect()]),
    );
  }
}
