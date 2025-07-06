import 'package:app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PRFEmptyView extends StatelessWidget {
  const PRFEmptyView({
    required this.label,
    required this.description,
    this.icon,
    this.action,
    this.actionLabel,
    this.onActionPressed,
    super.key,
  });

  final String label;
  final String description;
  final IconData? icon;
  final Widget? action;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Enhanced Icon Container
          Stack(
            alignment: Alignment.center,
            children: [
              // Background glow effect
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      theme.colorScheme.primary.withValues(alpha: 0.1),
                      theme.colorScheme.primary.withValues(alpha: 0.05),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.7, 1.0],
                  ),
                ),
              ),
              // Main icon container
              Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                      theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: theme.colorScheme.shadow.withValues(alpha: 0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  icon ?? Icons.lightbulb_outline_rounded,
                  size: 64,
                  color: theme.colorScheme.primary,
                ),
              ),
              // Subtle inner glow
              Positioned.fill(
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.1),
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: const [0.0, 0.3, 0.7, 1.0],
                    ),
                  ),
                ),
              ),
            ],
          ).animate(
            effects: [
              const ScaleEffect(
                begin: Offset(0.7, 0.7),
                end: Offset(1, 1),
                duration: Duration(milliseconds: 800),
                curve: Curves.elasticOut,
              ),
              const FadeEffect(
                begin: 0,
                end: 1,
                duration: Duration(milliseconds: 600),
              ),
              const ShakeEffect(
                hz: 1,
                offset: Offset(0, 2),
                duration: Duration(milliseconds: 800),
                delay: Duration(milliseconds: 1200),
              ),
              const ShimmerEffect(
                duration: Duration(seconds: 2),
                delay: Duration(milliseconds: 1500),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Enhanced Title
          Text(
                label,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              )
              .animate(delay: const Duration(milliseconds: 200))
              .fadeIn(duration: const Duration(milliseconds: 600))
              .slideY(begin: 0.3, end: 0),

          const SizedBox(height: 16),

          // Enhanced Description
          Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.3,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  description,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              )
              .animate(delay: const Duration(milliseconds: 400))
              .fadeIn(duration: const Duration(milliseconds: 600))
              .slideY(begin: 0.3, end: 0),

          const SizedBox(height: 32),

          // Action Button or Custom Action Widget
          if (action != null)
            action!
          else if (onActionPressed != null && actionLabel != null)
            Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withValues(alpha: 0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: FilledButton.icon(
                    onPressed: onActionPressed,
                    icon: const Icon(Icons.add_rounded),
                    label: Text(
                      actionLabel!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                )
                .animate(delay: const Duration(milliseconds: 600))
                .fadeIn(duration: const Duration(milliseconds: 600))
                .slideY(begin: 0.3, end: 0)
                .then()
                .shimmer(
                  duration: const Duration(seconds: 2),
                  delay: const Duration(milliseconds: 1000),
                ),

          const SizedBox(height: 24),

          // Subtle Footer Message
          Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.7,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.pullToRefresh,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.7,
                      ),
                    ),
                  ),
                ],
              )
              .animate(delay: const Duration(milliseconds: 800))
              .fadeIn(duration: const Duration(milliseconds: 800)),
        ],
      ),
    );
  }
}
