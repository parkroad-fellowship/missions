import 'package:app/features/home/student_enquiries/cubit/get_enquiries_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/prf_student_enquiry.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:app/utils/router.gr.dart';
import 'package:app/widgets/reply_status.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';

class StudentEnquiriesPageTablet extends StatefulWidget {
  const StudentEnquiriesPageTablet({super.key});

  @override
  State<StudentEnquiriesPageTablet> createState() =>
      _StudentEnquiriesPageTabletState();
}

class _StudentEnquiriesPageTabletState
    extends State<StudentEnquiriesPageTablet> {
  bool _selectedReplyStatus = false;
  @override
  void initState() {
    context.read<GetEnquiriesCubit>().getStudentEnquiries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    Misc.initDimensions(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: CustomScrollView(
            slivers: [
              // Start Navigation Bar
              SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        icon: const Icon(Icons.arrow_back_ios),
                        padding: const EdgeInsets.only(left: 8),
                        onPressed:
                            () => context.router.popUntilRouteWithPath(
                              PRFSuperAppRouter.landingRoute,
                            ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      l10n.studentQuestions,
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

              // End Navigation Bar
              SliverToBoxAdapter(child: SizedBox(height: 48.h)),
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
              SliverToBoxAdapter(child: SizedBox(height: 16.h)),
              SliverToBoxAdapter(
                child: BlocBuilder<GetEnquiriesCubit, GetEnquiriesState>(
                  builder:
                      (context, state) => state.maybeWhen(
                        orElse:
                            () =>
                                const Center(child: LinearProgressIndicator()),
                        error: (message) => const SizedBox.shrink(),
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
                                    .read<GetEnquiriesCubit>()
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
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.05,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    l10n.pleaseWait,
                                    style:
                                        Theme.of(
                                          context,
                                        ).textTheme.displayLarge,
                                  ),
                                ],
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
                              StudentEnquiryRepliesRoute(enquiry: enquiry),
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
    );
  }
}
