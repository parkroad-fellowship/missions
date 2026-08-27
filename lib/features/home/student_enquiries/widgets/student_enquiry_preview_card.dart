import 'package:app/models/remote/enquiry/prf_student_enquiry.dart';
import 'package:flutter/material.dart';
import 'package:prf_design/prf_design.dart';

class StudentEnquiryPreviewCard extends StatelessWidget {
  const StudentEnquiryPreviewCard({
    required this.enquiry,
    required this.timezone,
    this.onTap,
    super.key,
  });

  final PRFStudentEnquiry enquiry;
  final String timezone;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = enquiry.content.length > 110
        ? '${enquiry.content.substring(0, 110).trim()}...'
        : enquiry.content;

    return Semantics(
      button: true,
      label: title,
      child: PRFDetailActionCard(
        onTap: onTap,
        margin: const EdgeInsets.symmetric(horizontal: PRFSpacingTokens.lg),
        backgroundColor: theme.colorScheme.surface,
        leading: Container(
          width: PRFSpacingTokens.xxxl,
          height: PRFSpacingTokens.xxxl,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.primaryContainer,
          ),
          alignment: Alignment.center,
          child: Text(
            StringFormatter.getUserNameInitials(enquiry.content),
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: theme.colorScheme.outline,
        ),
        title: title,
        subtitle: DateFormatter.formatTimeFromDateTime(
          enquiry.createdAt,
          timezone,
        ),
      ),
    );
  }
}
