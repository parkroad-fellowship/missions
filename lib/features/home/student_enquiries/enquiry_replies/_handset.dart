import 'package:app/enums/prf_morph_types.dart';
import 'package:app/features/home/student_enquiries/cubit/create_student_enquiry_reply_cubit.dart';
import 'package:app/features/home/student_enquiries/cubit/get_student_enquiry_replies_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/prf_student_enquiry.dart';
import 'package:app/models/local/prf_student_enquiry_reply.dart';
import 'package:app/models/remote/socket_config.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:app/widgets/_index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class StudentEnquiryRepliesPageHandset extends StatefulWidget {
  const StudentEnquiryRepliesPageHandset({
    required this.enquiry,
    super.key,
  });

  final PRFLocalStudentEnquiry enquiry;

  @override
  State<StudentEnquiryRepliesPageHandset> createState() =>
      _StudentEnquiryRepliesPageHandsetState();
}

class _StudentEnquiryRepliesPageHandsetState
    extends State<StudentEnquiryRepliesPageHandset> {
  PRFLocalStudentEnquiry get enquiry => widget.enquiry;

  final _enquiryReplyController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    context
        .read<GetEnquiryRepliesCubit>()
        .getStudentEnquiryReplies(enquiryUlid: enquiry.ulid);

    _subscribeToEnquiryReplies();
    super.initState();
  }

  Future<void> _subscribeToEnquiryReplies() async {
    await getIt<SocketService>().init(
      socketConfig: SocketConfig(
        privateChannels: {
          ...getIt<SocketService>().defaultConfig().privateChannels,
          'App.Models.StudentEnquiry.${enquiry.ulid}': <String>[
            r'App\Events\StudentEnquiryReply\Created',
          ],
        },
        presenceChannels:
            getIt<SocketService>().defaultConfig().presenceChannels,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Start Navigation Bar
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              pinned: true,
              flexibleSpace: Padding(
                padding: EdgeInsets.symmetric(horizontal: 80.w),
                child: Row(
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
                          PRFSuperAppRouter.studentEnquiriesRoute,
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
                  ],
                ),
              ),
            ),
            // End Navigation Bar
            SliverToBoxAdapter(child: SizedBox(height: 48.h)),
            StreamBuilder<List<PRFLocalStudentEnquiryReply>>(
              stream: getIt<LocalDBService>()
                  .getStudentEnquiryReplies(studentEnquiryUlid: enquiry.ulid),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final enquiryReplies = [
                  // Add the enquiry as the first item
                  PRFLocalStudentEnquiryReply(
                    ulid: enquiry.ulid,
                    studentEnquiryUlid: enquiry.ulid,
                    content: enquiry.content,
                    createdAt: enquiry.createdAt,
                    commentorableType: PRFMorphType.student.apiKey,
                    isStudent: true,
                  ),
                  if (snapshot.data != null) ...snapshot.data!,
                ];

                return SliverList.builder(
                  itemCount: enquiryReplies.length,
                  itemBuilder: (context, index) {
                    final enquiryReply = enquiryReplies[index];

                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.w),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 16.h) +
                            EdgeInsets.only(
                              left: enquiryReply.isStudent ? 0 : 88.w,
                              right: enquiryReply.isStudent ? 88.w : 0,
                            ),
                        width: MediaQuery.sizeOf(context).width * 0.5,
                        padding: EdgeInsets.symmetric(
                          horizontal: 48.w,
                          vertical: 32.h,
                        ),
                        decoration: BoxDecoration(
                          color: enquiryReply.isStudent
                              ? AppTheme.appTheme()
                                  .kSecondaryColorV2
                                  .withOpacity(.2)
                              : AppTheme.appTheme().kGreyColor.withOpacity(.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(enquiryReply.content),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Animate(
        effects: const [
          FadeEffect(
            duration: Duration(milliseconds: 500),
            delay: Duration(milliseconds: 500),
          ),
          ShakeEffect(
            duration: Duration(milliseconds: 500),
            delay: Duration(milliseconds: 500),
          ),
        ],
        child: FloatingActionButton(
          onPressed: () => WoltModalSheet.show<void>(
            context: context,
            pageListBuilder: (modalSheetContext) {
              return [
                WoltModalSheetPage(
                  backgroundColor: Colors.white,
                  child: SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: FormFieldLabel(
                              label: l10n.reply,
                              isRequired: true,
                              color: AppTheme.appTheme().kBlackColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: FormFieldLabel(
                              label: l10n.rules,
                              isRequired: true,
                              color: AppTheme.appTheme().kErrorColor,
                            ),
                          ),
                          const SizedBox(height: 6),
                          InputFormField(
                            hintText: l10n.reply,
                            controller: _enquiryReplyController,
                            isTextBox: true,
                          ),
                          const SizedBox(height: 16),
                          BlocConsumer<CreateEnquiryReplyCubit,
                              CreateEnquiryReplyState>(
                            listener: (context, state) {
                              state.mapOrNull(
                                loading: (_) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                },
                                loaded: (_) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  _enquiryReplyController.clear();
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(l10n.replySent)),
                                  );
                                },
                              );
                            },
                            builder: (context, state) {
                              return state.maybeWhen(
                                orElse: () => PrimaryButton(
                                  title:
                                      _isLoading ? l10n.replying : l10n.reply,
                                  disabled: _isLoading,
                                  isLoading: _isLoading ? true : null,
                                  onPressed: () async {
                                    await context
                                        .read<CreateEnquiryReplyCubit>()
                                        .createStudentEnquiryReply(
                                          studentEnquiryUlid: enquiry.ulid,
                                          content: _enquiryReplyController.text,
                                        );
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ];
            },
          ),
          backgroundColor: AppTheme.appTheme().kPrimaryColorV2,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
