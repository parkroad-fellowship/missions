import 'package:app/features/home/student_enquiries/cubit/enquiry_resource_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/enquiry/prf_student_enquiry.dart';
import 'package:app/utils/_index.dart';
import 'package:app/utils/router/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

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
    context.read<EnquiryResourceCubit>().loadAll();
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
                unreadLabel: l10n.unread,
                repliedLabel: l10n.replied,
                onStatusSelected: ({required status}) {
                  setState(() {
                    _selectedReplyStatus = status;
                  });
                },
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: PRFSpacingTokens.lg),
            ),

            // Loading Indicator
            SliverToBoxAdapter(
              child:
                  BlocBuilder<
                    EnquiryResourceCubit,
                    ResourceState<PRFStudentEnquiry>
                  >(
                    builder: (context, state) => state.maybeWhen(
                      orElse: () => const PRFLinearProgressIndicator(),
                      error: (message, _) => const SizedBox.shrink(),
                      listLoaded: (_, _, _) => const SizedBox.shrink(),
                    ),
                  ),
            ),

            // Enquiries List
            BlocBuilder<EnquiryResourceCubit, ResourceState<PRFStudentEnquiry>>(
              builder: (context, state) {
                return state.maybeWhen(
                  listLoaded: (allEnquiries, _, _) {
                    final enquiries = allEnquiries
                        .where(
                          (e) => e.hasReplies == _selectedReplyStatus,
                        )
                        .toList();
                    if (enquiries.isEmpty) {
                      return SliverFillRemaining(
                        child: RefreshIndicator(
                          onRefresh: () =>
                              context.read<EnquiryResourceCubit>().loadAll(),
                          child: PRFEmptyView(
                            label: l10n.noQuestions,
                            description: l10n.pleaseWait,
                          ),
                        ),
                      );
                    }
                    return SliverList.separated(
                      itemCount: enquiries.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: PRFSpacingTokens.lg),
                      itemBuilder: (context, index) {
                        final enquiry = enquiries[index];
                        return _StudentEnquiryCard(
                          enquiry: enquiry,
                          timezone: timezone,
                          onTap: () => context.router.push(
                            StudentEnquiryRepliesRoute(
                              enquiryUlid: enquiry.ulid,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  error: (message, _) => SliverFillRemaining(
                    child: PRFEmptyView(
                      label: l10n.noQuestions,
                      description: message,
                    ),
                  ),
                  orElse: () => const SliverToBoxAdapter(
                    child: SizedBox.shrink(),
                  ),
                );
              },
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: PRFSpacingTokens.xl),
            ),
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

  final PRFStudentEnquiry enquiry;
  final String timezone;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PRFDetailActionCard(
      onTap: onTap,
      margin: const EdgeInsets.symmetric(horizontal: PRFSpacingTokens.lg),
      backgroundColor: theme.colorScheme.surface,
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.08),
        child: Text(
          StringFormatter.getUserNameInitials(enquiry.content),
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: theme.colorScheme.outline,
      ),
      title: enquiry.content.length > 80
          ? '${enquiry.content.substring(0, 80).trim()}...'
          : enquiry.content,
      subtitle: DateFormatter.formatTimeFromDateTime(
        enquiry.createdAt,
        timezone,
      ),
    );
  }
}
