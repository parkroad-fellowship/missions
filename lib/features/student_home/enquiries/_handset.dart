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

class LearnerEnquiriesPageHandset extends StatefulWidget {
  const LearnerEnquiriesPageHandset({super.key});

  @override
  State<LearnerEnquiriesPageHandset> createState() =>
      _LearnerEnquiriesPageHandsetState();
}

class _LearnerEnquiriesPageHandsetState
    extends State<LearnerEnquiriesPageHandset> {
  @override
  void initState() {
    context.read<GetStudentEnquiriesCubit>().getStudentEnquiries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          l10n.myQuestions,
          style: CustomTextTheme.customTextTheme().displayLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            BlocBuilder<GetStudentEnquiriesCubit, GetStudentEnquiriesState>(
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
                    onRefresh: () => context
                        .read<GetStudentEnquiriesCubit>()
                        .getStudentEnquiries(),
                    child: Column(
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
                        PrimaryButton(
                          onPressed: () => context.router.pushNamed(
                            PRFSuperAppRouter.createStudentEnquiryRoute,
                          ),
                          title: l10n.askQuestion,
                          disabled: false,
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => context
                      .read<GetStudentEnquiriesCubit>()
                      .getStudentEnquiries(),
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
                          EnquiryRepliesRoute(enquiry: enquiry),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.router
            .pushNamed(PRFSuperAppRouter.createStudentEnquiryRoute),
        backgroundColor: AppTheme.appTheme().kPrimaryColorV2,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
