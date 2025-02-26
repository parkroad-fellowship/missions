import 'package:app/l10n/l10n.dart';
import 'package:app/utils/_index.dart';
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
  _ReplyStatusViewState();

  bool? _selectedReplyStatus;

  @override
  void initState() {
    super.initState();
    _selectedReplyStatus = widget.defaultReplyStatus;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children:
            widget.reversed ? _chips(l10n).reversed.toList() : _chips(l10n),
      ),
    );
  }

  List<Widget> _chips(AppLocalizations l10n) => [
    GestureDetector(
      onTap: () {
        widget.onReplyStatusSelected(replyStatus: false);
        setState(() {
          _selectedReplyStatus = false;
        });
      },
      child: Chip(
        label: Text(l10n.unread.toUpperCase()),
        side: BorderSide(color: PRFApp.theme().kAccent12GreyColor),
        backgroundColor:
            _selectedReplyStatus == false
                ? PRFApp.theme().kPrimaryColorV2
                : Colors.white,
        labelStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
          color:
              _selectedReplyStatus == false
                  ? Colors.white
                  : PRFApp.theme().kPrimaryColorV2,
        ),
      ),
    ),
    GestureDetector(
      onTap: () {
        widget.onReplyStatusSelected(replyStatus: true);
        setState(() {
          _selectedReplyStatus = true;
        });
      },
      child: Chip(
        label: Text(l10n.replied.toUpperCase()),
        side: BorderSide(color: PRFApp.theme().kAccent12GreyColor),
        backgroundColor:
            _selectedReplyStatus ?? true
                ? PRFApp.theme().kPrimaryColorV2
                : Colors.white,
        labelStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
          color:
              _selectedReplyStatus ?? true
                  ? Colors.white
                  : PRFApp.theme().kPrimaryColorV2,
        ),
      ),
    ),
  ];
}
