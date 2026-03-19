import 'package:app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:prf_design/prf_design.dart';

class StudentEnquiryFilterHeader extends StatelessWidget {
  const StudentEnquiryFilterHeader({
    required this.unreadCount,
    required this.repliedCount,
    required this.onStatusSelected,
    super.key,
  });

  final int unreadCount;
  final int repliedCount;
  final ValueChanged<bool> onStatusSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        PRFSpacingTokens.lg,
        PRFSpacingTokens.md,
        PRFSpacingTokens.lg,
        PRFSpacingTokens.md,
      ),
      child: Container(
        padding: const EdgeInsets.all(PRFSpacingTokens.md),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(PRFRadiusTokens.xl),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _StatPill(
                    label: l10n.unread,
                    value: unreadCount,
                    icon: Icons.mark_chat_unread_rounded,
                  ),
                ),
                const SizedBox(width: PRFSpacingTokens.sm),
                Expanded(
                  child: _StatPill(
                    label: l10n.replied,
                    value: repliedCount,
                    icon: Icons.mark_chat_read_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: PRFSpacingTokens.md),
            ReplyStatusView(
              unreadLabel: l10n.unread,
              repliedLabel: l10n.replied,
              onStatusSelected: ({required status}) => onStatusSelected(status),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final int value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: PRFSpacingTokens.sm,
        vertical: PRFSpacingTokens.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: theme.colorScheme.onPrimaryContainer,
          ),
          const SizedBox(width: PRFSpacingTokens.xs),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            value.toString(),
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
