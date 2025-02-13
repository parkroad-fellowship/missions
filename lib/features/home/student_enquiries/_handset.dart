import 'package:app/features/home/student_enquiries/cubit/get_enquiries_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/prf_student_enquiry.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:app/utils/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentEnquiriesPageHandset extends StatefulWidget {
  const StudentEnquiriesPageHandset({super.key});

  @override
  State<StudentEnquiriesPageHandset> createState() =>
      _StudentEnquiriesPageHandsetState();
}

class _StudentEnquiriesPageHandsetState
    extends State<StudentEnquiriesPageHandset> {
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
                  padding: EdgeInsets.symmetric(horizontal: 80.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppTheme.appTheme().kPrimaryColorV2,
                            width: 1.w,
                          ),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          padding: const EdgeInsets.only(left: 8),
                          onPressed: () => context.router.popUntilRouteWithPath(
                            PRFSuperAppRouter.landingRoute,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        l10n.studentQuestions,
                        style: CustomTextTheme.customTextTheme()
                            .displayLarge
                            ?.copyWith(fontSize: 80.sp),
                      ),
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.only(right: 16.w),
                        child: Visibility(
                          visible: true,
                          child: Icon(Icons.abc, color: Colors.white,),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // End Navigation Bar
              SliverToBoxAdapter(child: SizedBox(height: 48.h)),
              SliverToBoxAdapter(
                child: BlocBuilder<GetEnquiriesCubit, GetEnquiriesState>(
                  builder: (context, state) => state.maybeWhen(
                    orElse: () =>
                        const Center(child: LinearProgressIndicator()),
                    error: (message) => Center(child: Text(message)),
                    loaded: SizedBox.shrink,
                  ),
                ),
              ),

              StreamBuilder<List<PRFLocalStudentEnquiry>>(
                stream: getIt<LocalDBService>().getStudentEnquiries(),
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
                        onRefresh: () => context
                            .read<GetEnquiriesCubit>()
                            .getStudentEnquiries(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.directions_walk),
                            Center(
                              child: Text(
                                l10n.noQuestions,
                                style: CustomTextTheme.customTextTheme()
                                    .headlineMedium!
                                    .copyWith(
                                      color: AppTheme.appTheme().kDullGreyColor,
                                      fontWeight: FontWeight.w600,
                                    ),
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
                                    style: CustomTextTheme.customTextTheme()
                                        .displayLarge!
                                        .copyWith(
                                          color: AppTheme.appTheme()
                                              .kPrimaryColorV2,
                                          fontSize: 14,
                                        ),
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
                          enquiry.content,
                          style: CustomTextTheme.customTextTheme()
                              .bodySmall!
                              .copyWith(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                        ),
                        trailing: Text(
                          Misc.formatTimeFromDateTime(enquiry.createdAt),
                        ),
                        onTap: () => context.router.push(
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
