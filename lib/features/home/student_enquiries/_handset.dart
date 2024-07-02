import 'package:app/features/home/student_enquiries/cubit/get_enquiries_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/prf_student_enquiry.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:app/utils/router.gr.dart';
import 'package:app/widgets/notification_bell.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          l10n.studentQuestions,
          style: CustomTextTheme.customTextTheme().displayLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [
          NotificationBell(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            BlocBuilder<GetEnquiriesCubit, GetEnquiriesState>(
              builder: (context, state) => state.maybeWhen(
                orElse: () => const Center(child: LinearProgressIndicator()),
                error: (message) => Center(child: Text(message)),
                loaded: SizedBox.shrink,
              ),
            ),
            StreamBuilder<List<PRFLocalStudentEnquiry>>(
              stream: getIt<LocalDBService>().getStudentEnquiries(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final enquiries = snapshot.data;

                if (enquiries != null && enquiries.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () =>
                        context.read<GetEnquiriesCubit>().getStudentEnquiries(),
                    child: Column(
                      children: [
                        const Icon(Icons.directions_walk),
                        Center(
                          child: Text(
                            l10n.noReplies,
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                l10n.pleaseWait,
                                style: CustomTextTheme.customTextTheme()
                                    .displayLarge!
                                    .copyWith(
                                      color:
                                          AppTheme.appTheme().kPrimaryColorV2,
                                      fontSize: 14,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () =>
                      context.read<GetEnquiriesCubit>().getStudentEnquiries(),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: enquiries!.length,
                    itemBuilder: (context, index) {
                      final enquiry = enquiries[index];
                      return ListTile(
                        dense: true,
                        minLeadingWidth: 10.5,
                        contentPadding: const EdgeInsets.only(left: 20),
                        visualDensity: VisualDensity.compact,
                        subtitle: Text(
                          enquiry.content,
                          style: CustomTextTheme.customTextTheme()
                              .bodySmall!
                              .copyWith(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () => context.router.push(
                          StudentEnquiryRepliesRoute(enquiry: enquiry),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
