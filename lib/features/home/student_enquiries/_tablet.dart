import 'package:app/features/home/student_enquiries/cubit/get_enquiries_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/prf_student_enquiry.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:app/shared_widgets/_index.dart';
import 'package:app/shared_widgets/navbar/navbar.dart';
import 'package:app/utils/_index.dart';
import 'package:app/utils/mixins/timezone_mixin.dart';
import 'package:app/utils/router/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class StudentEnquiriesPageTablet extends StatefulWidget {
  const StudentEnquiriesPageTablet({super.key});

  @override
  State<StudentEnquiriesPageTablet> createState() =>
      _StudentEnquiriesPageTabletState();
}

class _StudentEnquiriesPageTabletState extends State<StudentEnquiriesPageTablet>
    with TimezoneMixin {
  bool _selectedReplyStatus = false;

  @override
  void initState() {
    context.read<GetEnquiriesCubit>().getStudentEnquiries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Navigation Bar
            PRFNavBar(
              title: l10n.studentQuestions,
              onBack: () => context.router.popUntilRouteWithPath(
                PRFSuperAppRouter.landingRoute,
              ),
              backgroundColor: theme.colorScheme.surface,
            ),
            // Reply Status Filter
            SliverToBoxAdapter(
              child: ReplyStatusView(
                onReplyStatusSelected: ({bool? replyStatus}) {
                  setState(() {
                    _selectedReplyStatus = replyStatus ?? false;
                  });
                  Logger().i('Selected Status: $_selectedReplyStatus');
                },
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // Loading Indicator
            SliverToBoxAdapter(
              child: BlocBuilder<GetEnquiriesCubit, GetEnquiriesState>(
                builder: (context, state) => state.maybeWhen(
                  orElse: () => const PRFLinearProgressIndicator(),
                  error: (message) => const SizedBox.shrink(),
                  loaded: SizedBox.shrink,
                ),
              ),
            ),

            // Enquiries List
            StreamBuilder<List<PRFLocalStudentEnquiry>>(
              stream: getIt<IsarService>().studentEnquiries.filter(
                replyStatus: _selectedReplyStatus,
              ),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SliverToBoxAdapter(
                    child: Center(child: PRFCircularProgressIndicator()),
                  );
                }

                final enquiries = snapshot.data;

                if (enquiries != null && enquiries.isEmpty) {
                  return SliverFillRemaining(
                    child: RefreshIndicator(
                      onRefresh: () => context
                          .read<GetEnquiriesCubit>()
                          .getStudentEnquiries(),
                      child: PRFEmptyView(
                        label: l10n.noQuestions,
                        description: l10n.pleaseWait,
                      ),
                    ),
                  );
                }

                return SliverList.separated(
                  itemCount: enquiries!.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final enquiry = enquiries[index];
                    return _StudentEnquiryCard(
                      enquiry: enquiry,
                      timezone: timezone,
                      onTap: () => context.router.push(
                        StudentEnquiryRepliesRoute(enquiry: enquiry),
                      ),
                    );
                  },
                );
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}

class _StudentEnquiryCard extends StatelessWidget {
  const _StudentEnquiryCard({
    required this.enquiry,
    required this.timezone,
    this.onTap,
  });

  final PRFLocalStudentEnquiry enquiry;
  final String timezone;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            CircleAvatar(
              radius: 24,
              backgroundColor: theme.colorScheme.primary.withValues(
                alpha: 0.08,
              ),
              child: Text(
                Misc.getUserNameInitials(enquiry.content),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    enquiry.content.length > 80
                        ? '${enquiry.content.substring(0, 80).trim()}...'
                        : enquiry.content,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    Misc.formatTimeFromDateTime(
                      enquiry.createdAt,
                      timezone,
                    ),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            // Arrow
            Icon(
              Icons.chevron_right_rounded,
              color: theme.colorScheme.outline,
            ),
          ],
        ),
      ),
    );
  }
}
