import 'package:app/models/remote/prayer/prf_prayer_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:prf_design/prf_design.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

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
                          borderRadius: BorderRadius.circular(
                            PRFRadiusTokens.smd,
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
      child: PRFDetailActionCard(
        title: prayerRequest.title,
        subtitle: prayerRequest.description,
        margin: const EdgeInsets.symmetric(
          horizontal: PRFSpacingTokens.lg,
          vertical: PRFSpacingTokens.sm,
        ),
        leading: Container(
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
      ).animate(effects: const [SaturateEffect()]),
    );
  }
}
