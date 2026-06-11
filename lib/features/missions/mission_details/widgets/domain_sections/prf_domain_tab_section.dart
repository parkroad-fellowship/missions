import 'package:flutter/material.dart';
import 'package:prf_design/prf_design.dart';

/// A domain-grouped tab section that displays a title, optional subtitle,
/// and a set of tabs with corresponding content views.
///
/// Each section manages its own [TabController] internally,
/// so the parent widget does not need to provide one.
class PRFDomainTabSection extends StatefulWidget {
  const PRFDomainTabSection({
    required this.title,
    required this.tabs,
    required this.children,
    super.key,
    this.subtitle,
    this.onTabChanged,
    this.initialIndex = 0,
  }) : assert(
         tabs.length == children.length,
         'tabs and children must have the same length',
       );

  final String title;
  final String? subtitle;
  final List<Tab> tabs;
  final List<Widget> children;
  final ValueChanged<int>? onTabChanged;
  final int initialIndex;

  @override
  State<PRFDomainTabSection> createState() => _PRFDomainTabSectionState();
}

class _PRFDomainTabSectionState extends State<PRFDomainTabSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) return;
    widget.onTabChanged?.call(_tabController.index);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(
            PRFSpacingTokens.lg,
            PRFSpacingTokens.lg,
            PRFSpacingTokens.lg,
            PRFSpacingTokens.sm,
          ),
          padding: const EdgeInsets.all(PRFSpacingTokens.md),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (widget.subtitle != null) ...[
                const SizedBox(height: PRFSpacingTokens.xs),
                Text(
                  widget.subtitle!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              const SizedBox(height: PRFSpacingTokens.sm),
              TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                padding: EdgeInsets.zero,
                labelPadding: const EdgeInsets.symmetric(
                  horizontal: PRFSpacingTokens.sm,
                ),
                labelColor: theme.colorScheme.onSurface,
                unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
                indicatorColor: theme.colorScheme.primary,
                tabs: widget.tabs,
              ),
            ],
          ),
        ),
        // Tab content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: widget.children,
          ),
        ),
      ],
    );
  }
}
