import 'package:app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:prf_design/prf_design.dart';

class MissionResourceTabView extends StatelessWidget {
  const MissionResourceTabView({
    required this.isLoading,
    required this.error,
    required this.isEmpty,
    required this.onRefresh,
    required this.canEdit,
    required this.onAdd,
    required this.addButtonLabel,
    required this.addButtonIcon,
    required this.emptyLabel,
    required this.emptyDescription,
    required this.sectionTitle,
    required this.items,
    super.key,
  });

  final bool isLoading;
  final String? error;
  final bool isEmpty;
  final bool canEdit;
  final Future<void> Function() onRefresh;
  final VoidCallback onAdd;
  final String addButtonLabel;
  final IconData addButtonIcon;
  final String emptyLabel;
  final String emptyDescription;
  final String sectionTitle;
  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading && isEmpty) {
      return const Center(child: PRFCircularProgressIndicator());
    }

    if (error != null && isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: PRFSpacingTokens.lg),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: PRFSpacingTokens.xl,
              ),
              child: Text(
                error!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
            const SizedBox(height: PRFSpacingTokens.lg),
            FilledButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(context.l10n.retry),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          PRFSpacingTokens.lg,
          PRFSpacingTokens.lg,
          PRFSpacingTokens.lg,
          PRFSpacingTokens.xxxl,
        ),
        children: [
          MissionSectionCard(
            title: sectionTitle,
            subtitle: emptyDescription,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (canEdit) ...[
                  FilledButton.icon(
                    onPressed: onAdd,
                    icon: Icon(addButtonIcon),
                    label: Text(addButtonLabel),
                  ),
                  const SizedBox(height: PRFSpacingTokens.md),
                ],
                if (error != null)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(
                      bottom: PRFSpacingTokens.md,
                    ),
                    padding: const EdgeInsets.all(PRFSpacingTokens.md),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(
                        PRFRadiusTokens.md,
                      ),
                    ),
                    child: Text(
                      error!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                if (isEmpty)
                  PRFEmptyView(
                    label: emptyLabel,
                    description: emptyDescription,
                  )
                else
                  ...items,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MissionSectionCard extends StatelessWidget {
  const MissionSectionCard({
    required this.title,
    required this.subtitle,
    required this.child,
    super.key,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(PRFSpacingTokens.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.9),
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: PRFSpacingTokens.xs),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: PRFSpacingTokens.md),
          child,
        ],
      ),
    );
  }
}

class MissionResourceCard extends StatelessWidget {
  const MissionResourceCard({
    required this.title,
    required this.subtitle,
    required this.editTooltip,
    required this.onEdit,
    required this.deleteTooltip,
    required this.onDelete,
    required this.canEdit,
    super.key,
  });

  final String title;
  final String? subtitle;
  final String editTooltip;
  final VoidCallback onEdit;
  final String deleteTooltip;
  final VoidCallback onDelete;
  final bool canEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: PRFSpacingTokens.sm),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: PRFSpacingTokens.md,
          vertical: PRFSpacingTokens.md,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.38),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  if (subtitle != null && subtitle!.isNotEmpty)
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            const SizedBox(width: PRFSpacingTokens.sm),
            if (canEdit) ...[
              Tooltip(
                message: editTooltip,
                child: GestureDetector(
                  onTap: onEdit,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: PRFSpacingTokens.sm,
                      vertical: PRFSpacingTokens.xs,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.11),
                      borderRadius: BorderRadius.circular(PRFRadiusTokens.full),
                    ),
                    child: Text(
                      'Edit',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: PRFSpacingTokens.xs),
              Tooltip(
                message: deleteTooltip,
                child: IconButton(
                  onPressed: onDelete,
                  icon: Icon(
                    Icons.delete_outline,
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
