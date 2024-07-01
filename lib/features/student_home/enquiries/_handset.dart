import 'package:app/features/student_home/enquiries/cubit/get_student_enquiries_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnquiriesPageHandset extends StatefulWidget {
  const EnquiriesPageHandset({super.key});

  @override
  State<EnquiriesPageHandset> createState() => _EnquiriesPageHandsetState();
}

class _EnquiriesPageHandsetState extends State<EnquiriesPageHandset> {
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
        title: Text(
          l10n.myQuestions,
          style: CustomTextTheme.customTextTheme().displayLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const SizedBox.shrink(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: BlocBuilder<GetStudentEnquiriesCubit, GetStudentEnquiriesState>(
          builder: (context, state) {
            return state.maybeWhen(
              orElse: () => const Center(child: CircularProgressIndicator()),
              error: (message) => Center(child: Text(message)),
              loaded: (enquiries) {
                if (enquiries.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () => context
                        .read<GetStudentEnquiriesCubit>()
                        .getStudentEnquiries(),
                    child: Column(
                      children: [
                        const Spacer(),
                        const Icon(
                          Icons.directions_walk,
                        ),
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
                        const Spacer(),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () => context
                      .read<GetStudentEnquiriesCubit>()
                      .getStudentEnquiries(),
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: enquiries.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final enquiry = enquiries[index];
                      return ListTile(
                        dense: true,
                        minLeadingWidth: 10.5,
                        contentPadding: const EdgeInsets.only(left: 20),
                        visualDensity: VisualDensity.compact,
                        // onTap: () => context.router.push(
                        //   MissionsDetailsRoute(mission: mission),
                        // ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              enquiry.content,
                              style: CustomTextTheme.customTextTheme()
                                  .bodySmall!
                                  .copyWith(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                            ),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
