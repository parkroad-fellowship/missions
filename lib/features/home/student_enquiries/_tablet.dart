import 'package:app/features/home/student_enquiries/_shared.dart';
import 'package:app/features/home/student_enquiries/cubit/enquiry_resource_cubit.dart';
import 'package:app/features/home/student_enquiries/widgets/student_enquiry_preview_card.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/enquiry/prf_student_enquiry.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:app/utils/mixins/timezone_mixin.dart';
import 'package:app/utils/router/router.dart';
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
  final _form = StudentEnquiriesFormState();

  @override
  void initState() {
    super.initState();
    _form
      ..attach(() => setState(() {}))
      ..load(context);
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= 1024 ? 2 : 1;

    return BlocBuilder<EnquiryResourceCubit, ResourceState<PRFStudentEnquiry>>(
      builder: (context, state) {
        final allEnquiries = state.maybeWhen(
          listLoaded: (items, _, _) => items,
          orElse: () => <PRFStudentEnquiry>[],
        );

        final unreadCount = allEnquiries.where((e) => !e.hasReplies).length;
        final repliedCount = allEnquiries.where((e) => e.hasReplies).length;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Left Column - Enquiries Grid/List (flex: 3)
                    Expanded(
                      flex: 3,
                      child: RefreshIndicator(
                        onRefresh: () async => _form.load(context),
                        child: CustomScrollView(
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          slivers: [
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: PRFSpacingTokens.lg,
                                  vertical: PRFSpacingTokens.lg,
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.arrow_back),
                                      onPressed: () =>
                                          context.router.popUntilRouteWithPath(
                                            PRFSuperAppRouter.landingRoute,
                                          ),
                                    ),
                                    const SizedBox(width: PRFSpacingTokens.xs),
                                    Expanded(
                                      child: Text(
                                        l10n.studentQuestions,
                                        style: theme.textTheme.headlineMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                              color:
                                                  theme.colorScheme.onSurface,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            state.maybeWhen(
                              listLoading: (_) => const SliverToBoxAdapter(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: PRFSpacingTokens.lg,
                                  ),
                                  child: PRFLinearProgressIndicator(),
                                ),
                              ),
                              error: (message, _) => SliverFillRemaining(
                                hasScrollBody: false,
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: PRFEmptyView(
                                    label: l10n.noQuestions,
                                    description: message,
                                  ),
                                ),
                              ),
                              listLoaded: (loadedEnquiries, _, _) {
                                final enquiries = loadedEnquiries
                                    .where(
                                      (e) =>
                                          e.hasReplies ==
                                          _form.selectedReplyStatus,
                                    )
                                    .toList();

                                if (enquiries.isEmpty) {
                                  return SliverFillRemaining(
                                    hasScrollBody: false,
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: PRFEmptyView(
                                        label: l10n.noQuestions,
                                        description: l10n.pleaseWait,
                                      ),
                                    ),
                                  );
                                }

                                return SliverGrid(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: columns,
                                        crossAxisSpacing: PRFSpacingTokens.lg,
                                        mainAxisSpacing: PRFSpacingTokens.lg,
                                        childAspectRatio: 1.4,
                                      ),
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      final enquiry = enquiries[index];
                                      return StudentEnquiryPreviewCard(
                                        enquiry: enquiry,
                                        timezone: timezone,
                                        onTap: () => context.router.push(
                                          StudentEnquiryRepliesRoute(
                                            enquiryUlid: enquiry.ulid,
                                          ),
                                        ),
                                      );
                                    },
                                    childCount: enquiries.length,
                                  ),
                                );
                              },
                              orElse: () => const SliverToBoxAdapter(
                                child: SizedBox.shrink(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Vertical Divider
                    VerticalDivider(
                      width: 1,
                      thickness: 1,
                      color: theme.colorScheme.outline.withValues(alpha: 0.12),
                    ),

                    // Right Column - Enquiries Filter Dashboard & Guidance (flex: 2)
                    Expanded(
                      flex: 2,
                      child: Container(
                        margin: const EdgeInsets.all(PRFSpacingTokens.lg),
                        padding: const EdgeInsets.all(PRFSpacingTokens.xl),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(
                            PRFRadiusTokens.lg,
                          ),
                          border: Border.all(
                            color: theme.colorScheme.outline.withValues(
                              alpha: 0.12,
                            ),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Enquiry Dashboard',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: PRFSpacingTokens.xl),

                            // Custom Vertical Filter Selection Buttons
                            _FilterSelectionButton(
                              label: 'Unread Questions',
                              count: unreadCount,
                              icon: Icons.mark_chat_unread_outlined,
                              selected: !_form.selectedReplyStatus,
                              onTap: () => _form.setReplyStatus(false),
                            ),
                            const SizedBox(height: PRFSpacingTokens.md),
                            _FilterSelectionButton(
                              label: 'Replied Questions',
                              count: repliedCount,
                              icon: Icons.mark_chat_read_outlined,
                              selected: _form.selectedReplyStatus,
                              onTap: () => _form.setReplyStatus(true),
                            ),

                            const Spacer(),

                            // Guidance illustration card
                            Center(
                              child: Icon(
                                Icons.question_answer_outlined,
                                size: 64,
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: PRFSpacingTokens.md),
                            Text(
                              'Minister to Students',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.onSurface,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: PRFSpacingTokens.sm),
                            Text(
                              'Answer enquiries submitted by students. Share wisdom and feedback on spiritual matters, or guide them through their doubts.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FilterSelectionButton extends StatelessWidget {
  const _FilterSelectionButton({
    required this.label,
    required this.count,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final int count;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
        child: Container(
          padding: const EdgeInsets.all(PRFSpacingTokens.lg),
          decoration: BoxDecoration(
            color: selected
                ? theme.colorScheme.primary.withValues(alpha: 0.1)
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
            border: Border.all(
              color: selected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline.withValues(alpha: 0.12),
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: selected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: PRFSpacingTokens.md),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: selected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: PRFSpacingTokens.md,
                  vertical: PRFSpacingTokens.xs,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(PRFRadiusTokens.full),
                ),
                child: Text(
                  '$count',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: selected
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
