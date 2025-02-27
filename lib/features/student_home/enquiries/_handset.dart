import 'package:app/features/student_home/enquiries/cubit/get_student_enquiries_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/prf_student_enquiry.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:app/utils/router.gr.dart';
import 'package:app/widgets/_index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';

class LearnerEnquiriesPageHandset extends StatefulWidget {
  const LearnerEnquiriesPageHandset({super.key});

  @override
  State<LearnerEnquiriesPageHandset> createState() =>
      _LearnerEnquiriesPageHandsetState();
}

class _LearnerEnquiriesPageHandsetState
    extends State<LearnerEnquiriesPageHandset> {
  bool _selectedReplyStatus = true;
  @override
  void initState() {
    context.read<GetStudentEnquiriesCubit>().getStudentEnquiries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: CustomScrollView(
            slivers: [
              // Start Navigation Bar
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.white,
                pinned: true,
                flexibleSpace: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1.w,
                          ),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          padding: const EdgeInsets.only(left: 8),
                          onPressed:
                              () => context.router.popUntilRouteWithPath(
                                PRFSuperAppRouter.studentLandingRoute,
                              ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        l10n.myQuestions,
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.only(right: 16.w),
                        child: const Visibility(
                          child: Icon(Icons.abc, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // End Navigation Bar
              SliverToBoxAdapter(child: SizedBox(height: 48.h)),
              SliverToBoxAdapter(
                child: ReplyStatusView(
                  defaultReplyStatus: true,
                  reversed: true,
                  onReplyStatusSelected: ({bool? replyStatus}) {
                    setState(() {
                      _selectedReplyStatus = replyStatus ?? true;
                    });
                    Logger().i('Selected Status: $_selectedReplyStatus');
                  },
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 16.h)),
              SliverToBoxAdapter(
                child: BlocBuilder<
                  GetStudentEnquiriesCubit,
                  GetStudentEnquiriesState
                >(
                  builder:
                      (context, state) => state.maybeWhen(
                        orElse:
                            () =>
                                const Center(child: LinearProgressIndicator()),
                        error: (message) => Center(child: Text(message)),
                        loaded: SizedBox.shrink,
                      ),
                ),
              ),
              StreamBuilder<List<PRFLocalStudentEnquiry>>(
                stream: getIt<LocalDBService>().getStudentEnquiries(
                  replyStatus: _selectedReplyStatus,
                ),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final enquiries = snapshot.data;

                  if (enquiries != null && enquiries.isEmpty) {
                    return SliverFillRemaining(
                      child: RefreshIndicator(
                        onRefresh:
                            () =>
                                context
                                    .read<GetStudentEnquiriesCubit>()
                                    .getStudentEnquiries(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.directions_walk),
                            Center(
                              child: Text(
                                l10n.noQuestions,
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 32.w),
                              child: SizedBox(
                                child: PRFPrimaryButton(
                                  onPressed:
                                      () => context.router.pushNamed(
                                        PRFSuperAppRouter
                                            .createStudentEnquiryRoute,
                                      ),
                                  title: l10n.askAQuestion,
                                  disabled: false,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return SliverList.separated(
                    itemCount: enquiries!.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final enquiry = enquiries[index];
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 64.r,
                          backgroundColor: Colors.white,
                          child: Text(
                            Misc.getUserNameInitials(enquiry.content),
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                        title: Text(
                          enquiry.content.length > 34
                              ? enquiry.content.substring(0, 35).trim()
                              : enquiry.content +
                                  (enquiry.content.length > 35 ? ' ...' : ''),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        trailing: Text(
                          Misc.formatTimeFromDateTime(enquiry.createdAt),
                        ),
                        onTap:
                            () => context.router.push(
                              EnquiryRepliesRoute(enquiry: enquiry),
                            ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => context.router.pushNamed(
              PRFSuperAppRouter.createStudentEnquiryRoute,
            ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
