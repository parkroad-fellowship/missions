import 'package:app/features/home/student_enquiries/cubit/get_enquiries_cubit.dart';
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

class StudentEnquiriesPageHandset extends StatefulWidget {
  const StudentEnquiriesPageHandset({super.key});

  @override
  State<StudentEnquiriesPageHandset> createState() =>
      _StudentEnquiriesPageHandsetState();
}

class _StudentEnquiriesPageHandsetState
    extends State<StudentEnquiriesPageHandset> {
  bool _selectedReplyStatus = false;
  String get timezone => getIt<HiveService>().timezone;
  @override
  void initState() {
    context.read<GetEnquiriesCubit>().getStudentEnquiries();
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
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
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
                        child: PRFEmptyView(
                          label: l10n.noQuestions,
                          description: l10n.pleaseWait,
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
                          Misc.formatTimeFromDateTime(
                            enquiry.createdAt,
                            timezone,
                          ),
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
