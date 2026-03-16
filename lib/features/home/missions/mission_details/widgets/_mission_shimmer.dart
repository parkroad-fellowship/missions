import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:prf_design/prf_design.dart';

/// Shimmer placeholder block for skeleton loading screens.
// TODO(prf): Replace with PRFShimmerBlock from prf_design
// when a new version is published.
class _ShimmerBlock extends StatelessWidget {
  const _ShimmerBlock({
    this.width,
    this.height,
    this.borderRadius = 8,
    this.shape,
  });

  final double? width;
  final double? height;
  final double borderRadius;
  final BoxShape? shape;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
          width: width ?? double.infinity,
          height: height,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: shape == BoxShape.circle
                ? null
                : BorderRadius.circular(borderRadius),
            shape: shape ?? BoxShape.rectangle,
          ),
        )
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(
          duration: 1200.ms,
          color: theme.colorScheme.surface,
        );
  }
}

/// Card list shimmer (Missioners, Souls, Notes, Questions)
class MissionListShimmer extends StatelessWidget {
  const MissionListShimmer({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: PRFSpacingTokens.lg, vertical: PRFSpacingTokens.sm),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: PRFSpacingTokens.sm),
        child: Container(
          padding: const EdgeInsets.all(PRFSpacingTokens.lg),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.08),
            ),
          ),
          child: Row(
            children: [
              const _ShimmerBlock(
                width: 40,
                height: 40,
                shape: BoxShape.circle,
              ),
              const SizedBox(width: PRFSpacingTokens.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ShimmerBlock(
                      width: 160 + (index * 20).toDouble(),
                      height: 14,
                    ),
                    const SizedBox(height: PRFSpacingTokens.sm),
                    const _ShimmerBlock(width: 100, height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Mission card shimmer (for mission list)
class MissionCardShimmer extends StatelessWidget {
  const MissionCardShimmer({super.key, this.itemCount = 3});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: PRFSpacingTokens.lg, vertical: PRFSpacingTokens.sm),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: PRFSpacingTokens.md),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.08),
            ),
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(
                  width: 3,
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(PRFSpacingTokens.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _ShimmerBlock(
                                width: 180 + (index * 10).toDouble(),
                                height: 16,
                              ),
                            ),
                            const SizedBox(width: PRFSpacingTokens.md),
                            const _ShimmerBlock(width: 60, height: 12),
                          ],
                        ),
                        const SizedBox(height: PRFSpacingTokens.sm),
                        const _ShimmerBlock(width: 120, height: 12),
                        const SizedBox(height: PRFSpacingTokens.md),
                        const _ShimmerBlock(height: 10),
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
}

/// Mission detail shimmer (Mission Ground hero + stats)
class MissionDetailShimmer extends StatelessWidget {
  const MissionDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(PRFSpacingTokens.lg),
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          // Hero card
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.08),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outline.withValues(alpha: 0.1),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(PRFSpacingTokens.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ShimmerBlock(width: 80, height: 12),
                      SizedBox(height: PRFSpacingTokens.md),
                      _ShimmerBlock(width: 220, height: 24),
                      SizedBox(height: PRFSpacingTokens.sm),
                      _ShimmerBlock(width: 160, height: 14),
                      SizedBox(height: PRFSpacingTokens.lg),
                      _ShimmerBlock(width: 200, height: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: PRFSpacingTokens.lg),
          // Stats grid (2x2)
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: List.generate(
              4,
              (_) => Container(
                padding: const EdgeInsets.all(PRFSpacingTokens.lg),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.08),
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _ShimmerBlock(width: 40, height: 28),
                    SizedBox(height: PRFSpacingTokens.sm),
                    _ShimmerBlock(width: 80, height: 12),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Grid shimmer (Gallery)
class MissionGridShimmer extends StatelessWidget {
  const MissionGridShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GridView.builder(
      padding: const EdgeInsets.all(PRFSpacingTokens.lg),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemCount: 6,
      itemBuilder: (context, index) => Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.08),
          ),
        ),
        child: const _ShimmerBlock(borderRadius: 12),
      ),
    );
  }
}
