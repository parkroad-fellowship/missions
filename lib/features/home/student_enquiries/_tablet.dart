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

    return BlocBuilder<EnquiryResourceCubit, ResourceState<PRFStudentEnquiry>>(
      builder: (context, state) {
        final allEnquiries = state.maybeWhen(
          listLoaded: (items, _, _) => items,
          orElse: () => <PRFStudentEnquiry>[],
        );

        final unreadCount = allEnquiries.where((e) => !e.hasReplies).length;
        final repliedCount = allEnquiries.where((e) => e.hasReplies).length;
        final isLoading = state.maybeWhen(
          listLoading: (_) => true,
          orElse: () => false,
        );

        return PRFTabletSplitScaffold(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PRFTabletHeaderRow(
                title: l10n.studentQuestions,
                onBack: () => context.router.popUntilRouteWithPath(
                  PRFSuperAppRouter.landingRoute,
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => _form.load(context),
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    slivers: [
                      SliverToBoxAdapter(
                        child: state.maybeWhen(
                          listLoading: (_) => const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: PRFSpacingTokens.lg,
                            ),
                            child: PRFLinearProgressIndicator(),
                          ),
                          initial: () => const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: PRFSpacingTokens.lg,
                            ),
                            child: PRFLinearProgressIndicator(),
                          ),
                          orElse: () => const SizedBox.shrink(),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: PRFSpacingTokens.lg,
                        ),
                        sliver: state.maybeWhen(
                          listLoading: (_) => allEnquiries.isEmpty
                              ? const SliverFillRemaining(
                                  hasScrollBody: false,
                                  child: Center(
                                    child: PRFCircularProgressIndicator(),
                                  ),
                                )
                              : const SliverToBoxAdapter(
                                  child: SizedBox.shrink(),
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
                                      e.hasReplies == _form.selectedReplyStatus,
                                )
                                .toList();

                            if (enquiries.isEmpty) {
                              final showingReplied = _form.selectedReplyStatus;
                              return SliverFillRemaining(
                                hasScrollBody: false,
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: PRFEmptyView(
                                    label: l10n.noQuestions,
                                    description: showingReplied
                                        ? l10n.noRepliedQuestionsDesc
                                        : l10n.noUnreadQuestionsDesc,
                                  ),
                                ),
                              );
                            }

                            return SliverGrid(
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 340,
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
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          sidePanel: PRFBrandPanel(
            children: [
              PRFPanelSectionLabel(l10n.enquiryDashboard),
              if (isLoading) ...[
                const SizedBox(height: PRFSpacingTokens.md),
                const SizedBox.square(
                  dimension: 16,
                  child: PRFCircularProgressIndicator(color: Colors.white),
                ),
              ],
              const SizedBox(height: PRFSpacingTokens.xl),

              // Custom Vertical Filter Selection Buttons
              _FilterSelectionButton(
                label: l10n.unreadQuestions,
                count: unreadCount,
                icon: Icons.mark_chat_unread_outlined,
                selected: !_form.selectedReplyStatus,
                onTap: () => _form.setReplyStatus(false),
              ),
              const SizedBox(height: PRFSpacingTokens.md),
              _FilterSelectionButton(
                label: l10n.repliedQuestions,
                count: repliedCount,
                icon: Icons.mark_chat_read_outlined,
                selected: _form.selectedReplyStatus,
                onTap: () => _form.setReplyStatus(true),
              ),

              const SizedBox(height: PRFSpacingTokens.xxl),

              // Guidance illustration card
              Center(
                child: Icon(
                  Icons.question_answer_outlined,
                  size: 64,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: PRFSpacingTokens.md),
              Text(
                l10n.ministerToStudents,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: PRFSpacingTokens.sm),
              Text(
                l10n.enquiriesPanelBody,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: PRFColors.navy100,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
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
      color: selected
          ? Colors.white.withValues(alpha: 0.14)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
        child: Container(
          padding: const EdgeInsets.all(PRFSpacingTokens.lg),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
            border: Border.all(
              color: selected
                  ? PRFColors.limeGreen
                  : Colors.white.withValues(alpha: 0.12),
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: selected ? PRFColors.limeGreen : PRFColors.navy100,
              ),
              const SizedBox(width: PRFSpacingTokens.md),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : PRFColors.navy100,
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
                      ? PRFColors.limeGreen
                      : Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(PRFRadiusTokens.full),
                ),
                child: Text(
                  '$count',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: selected ? PRFColors.navyBlue : Colors.white,
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
