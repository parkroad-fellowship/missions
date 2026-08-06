import 'package:app/enums/common/prf_morph_types.dart';
import 'package:app/l10n/arb/app_localizations.dart';
import 'package:app/models/remote/enquiry/prf_student_enquiry_reply.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prf_design/prf_design.dart';

class EnquiryRepliesFormState {
  void attach(VoidCallback rebuild) {}
  void dispose() {}
}

bool isStudentReply(PRFStudentEnquiryReply reply) =>
    reply.commentorableType == PRFMorphType.student;

String formatTimestamp(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inDays == 0) {
    return DateFormat('HH:mm').format(dateTime);
  } else if (difference.inDays == 1) {
    return 'Yesterday ${DateFormat('HH:mm').format(dateTime)}';
  } else if (difference.inDays < 7) {
    return DateFormat('EEE HH:mm').format(dateTime);
  } else {
    return DateFormat('MMM d, HH:mm').format(dateTime);
  }
}

Widget buildMessageBubble(
  BuildContext context,
  AppLocalizations l10n,
  PRFStudentEnquiryReply reply,
  int index,
) {
  final isStudent = isStudentReply(reply);
  final semanticRole = isStudent ? l10n.unread : l10n.replied;

  return TweenAnimationBuilder<double>(
    duration: Duration(milliseconds: 220 + (index * 35)),
    tween: Tween(begin: 0, end: 1),
    curve: Curves.easeOutBack,
    builder: (context, value, child) {
      return Transform.translate(
        offset: Offset(0, 20 * (1 - value)),
        child: Opacity(
          opacity: value.clamp(0.0, 1.0),
          child: child,
        ),
      );
    },
    child: Semantics(
      label:
          '$semanticRole: ${reply.content}. ${formatTimestamp(reply.createdAt)}',
      child: PRFMessageBubble(
        message: reply.content,
        timestamp: formatTimestamp(reply.createdAt),
        isIncoming: isStudent,
        showStatusIndicator: !isStudent,
        margin: EdgeInsets.only(
          left: isStudent ? PRFSpacingTokens.lg : 76,
          right: isStudent ? 76 : PRFSpacingTokens.lg,
          top: PRFSpacingTokens.xs,
          bottom: PRFSpacingTokens.xs,
        ),
        maxWidth: MediaQuery.sizeOf(context).width * 0.77,
      ),
    ),
  );
}
