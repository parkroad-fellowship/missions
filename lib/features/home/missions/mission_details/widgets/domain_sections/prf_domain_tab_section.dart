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
  }) : assert(
         tabs.length == children.length,
         'tabs and children must have the same length',
       );

  final String title;
  final String? subtitle;
  final List<Tab> tabs;
  final List<Widget> children;

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
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: PRFSpacingTokens.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              if (widget.subtitle != null) ...[
                const SizedBox(height: PRFSpacingTokens.xs),
                Text(
                  widget.subtitle!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: PRFSpacingTokens.md),
        // Tab bar
        TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: widget.tabs,
        ),
        const SizedBox(height: PRFSpacingTokens.sm),
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
