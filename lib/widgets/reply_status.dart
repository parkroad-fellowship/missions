import 'package:app/l10n/l10n.dart';
import 'package:flutter/material.dart';

class ReplyStatusView extends StatefulWidget {
  const ReplyStatusView({
    required this.onReplyStatusSelected,
    this.reversed = false,
    this.defaultReplyStatus = false,
    super.key,
  });

  final void Function({bool replyStatus}) onReplyStatusSelected;
  final bool reversed;
  final bool defaultReplyStatus;

  @override
  State<ReplyStatusView> createState() => _ReplyStatusViewState();
}

class _ReplyStatusViewState extends State<ReplyStatusView> {
  bool? _selectedReplyStatus;

  @override
  void initState() {
    super.initState();
    _selectedReplyStatus = widget.defaultReplyStatus;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    final chips = [
      _StatusChip(
        label: l10n.unread.toUpperCase(),
        selected: _selectedReplyStatus == false,
        onTap: () {
          widget.onReplyStatusSelected(replyStatus: false);
          setState(() => _selectedReplyStatus = false);
        },
        theme: theme,
      ),
      _StatusChip(
        label: l10n.replied.toUpperCase(),
        selected: _selectedReplyStatus == true,
        onTap: () {
          widget.onReplyStatusSelected(replyStatus: true);
          setState(() => _selectedReplyStatus = true);
        },
        theme: theme,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 40,
        child: Row(
          children: widget.reversed ? chips.reversed.toList() : chips,
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.theme,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final selectedColor = theme.colorScheme.primary;
    final unselectedColor = theme.colorScheme.surface;
    final selectedTextColor = theme.colorScheme.onPrimary;
    final unselectedTextColor = theme.colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: selected ? selectedColor : unselectedColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected
                  ? selectedColor.withOpacity(0.5)
                  : theme.colorScheme.outline.withOpacity(0.3),
              width: 1.1,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: selectedColor.withOpacity(0.13),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: selected ? selectedTextColor : unselectedTextColor,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
