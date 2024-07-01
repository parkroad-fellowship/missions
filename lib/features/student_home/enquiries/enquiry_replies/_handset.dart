import 'package:app/features/student_home/enquiries/cubit/create_student_enquiry_reply_cubit.dart';
import 'package:app/features/student_home/enquiries/cubit/get_student_enquiry_replies_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/prf_student_enquiry.dart';
import 'package:app/models/local/prf_student_enquiry_reply.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:app/utils/router.gr.dart';
import 'package:app/widgets/_index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class EnquiryRepliesPageHandset extends StatefulWidget {
  const EnquiryRepliesPageHandset({
    required this.enquiry,
    super.key,
  });

  final PRFLocalStudentEnquiry enquiry;

  @override
  State<EnquiryRepliesPageHandset> createState() =>
      _EnquiryRepliesPageHandsetState();
}

class _EnquiryRepliesPageHandsetState extends State<EnquiryRepliesPageHandset> {
  PRFLocalStudentEnquiry get enquiry => widget.enquiry;

  final _enquiryReplyController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    context
        .read<GetStudentEnquiryRepliesCubit>()
        .getStudentEnquiryReplies(enquiryUlid: enquiry.ulid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.replies,
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
            ListTile(
              contentPadding: EdgeInsets.zero,
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(l10n.yourQuestion),
                  Text(enquiry.content),
                ],
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                l10n.replies.toUpperCase(),
                style:
                    CustomTextTheme.customTextTheme().headlineMedium!.copyWith(
                          color: AppTheme.appTheme().kAccent2BackgroundColor,
                          fontWeight: FontWeight.w600,
                        ),
              ),
            ),
            BlocBuilder<GetStudentEnquiryRepliesCubit,
                GetStudentEnquiryRepliesState>(
              builder: (context, state) => state.maybeWhen(
                orElse: () => const Center(child: LinearProgressIndicator()),
                error: (message) => Center(child: Text(message)),
                loaded: SizedBox.shrink,
              ),
            ),
            StreamBuilder<List<PRFLocalStudentEnquiryReply>>(
              stream: getIt<LocalDBService>()
                  .getStudentEnquiryReplies(studentEnquiryUlid: enquiry.ulid),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final enquiryReplies = snapshot.data;

                if (enquiryReplies != null && enquiryReplies.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () => context
                        .read<GetStudentEnquiryRepliesCubit>()
                        .getStudentEnquiryReplies(enquiryUlid: enquiry.ulid),
                    child: Column(
                      children: [
                        const Spacer(),
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
                        const Spacer(),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => context
                      .read<GetStudentEnquiryRepliesCubit>()
                      .getStudentEnquiryReplies(enquiryUlid: enquiry.ulid),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: enquiryReplies!.length,
                    itemBuilder: (context, index) {
                      final enquiryReply = enquiryReplies[index];
                      return ListTile(
                        dense: true,
                        minLeadingWidth: 10.5,
                        contentPadding: const EdgeInsets.only(left: 20),
                        visualDensity: VisualDensity.compact,
                        subtitle: Text(
                          enquiryReply.content,
                          style: CustomTextTheme.customTextTheme()
                              .bodySmall!
                              .copyWith(
                                color: Colors.black,
                                fontSize: 14,
                              ),
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
        onPressed: () => WoltModalSheet.show<void>(
          context: context,
          pageListBuilder: (modalSheetContext) {
            return [
              WoltModalSheetPage(
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
                        const SizedBox(height: 6),
                        InputFormField(
                          hintText: l10n.reply,
                          controller: _enquiryReplyController,
                          isTextBox: true,
                        ),
                        const SizedBox(height: 16),
                        BlocConsumer<CreateStudentEnquiryReplyCubit,
                            CreateStudentEnquiryReplyState>(
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
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(l10n.replySent),
                                  ),
                                );
                              },
                            );
                          },
                          builder: (context, state) {
                            return state.maybeWhen(
                              orElse: () => PrimaryButton(
                                title: _isLoading ? l10n.replying : l10n.reply,
                                disabled: _isLoading,
                                isLoading: _isLoading ? true : null,
                                onPressed: () async {
                                  await context
                                      .read<CreateStudentEnquiryReplyCubit>()
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
          maxDialogWidth: 560,
          minDialogWidth: 400,
          minPageHeight: 0,
          maxPageHeight: 0.9,
        ),
        backgroundColor: AppTheme.appTheme().kPrimaryColorV2,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
