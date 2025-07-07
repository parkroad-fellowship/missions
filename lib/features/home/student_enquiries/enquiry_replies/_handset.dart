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
import 'package:app/widgets/navbar.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentEnquiryRepliesPageHandset extends StatefulWidget {
  const StudentEnquiryRepliesPageHandset({required this.enquiry, super.key});

  final PRFLocalStudentEnquiry enquiry;

  @override
  State<StudentEnquiryRepliesPageHandset> createState() =>
      _StudentEnquiryRepliesPageHandsetState();
}

class _StudentEnquiryRepliesPageHandsetState
    extends State<StudentEnquiryRepliesPageHandset> {
  PRFLocalStudentEnquiry get enquiry => widget.enquiry;

  final _enquiryReplyController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    context.read<GetEnquiryRepliesCubit>().getStudentEnquiryReplies(
      enquiryUlid: enquiry.ulid,
    );
    _subscribeToEnquiryReplies();

    // Scroll to bottom after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
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
        presenceChannels: getIt<SocketService>()
            .defaultConfig()
            .presenceChannels,
      ),
    );
  }

  Future<void> _sendReply(BuildContext context, String text) async {
    if (text.trim().isEmpty) return;

    await context.read<CreateEnquiryReplyCubit>().createStudentEnquiryReply(
      studentEnquiryUlid: enquiry.ulid,
      content: text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                controller: _scrollController, // Attach controller here
                slivers: [
                  PRFNavBar(
                    title: l10n.studentQuestions,
                    onBack: () => context.router.popUntilRouteWithPath(
                      PRFSuperAppRouter.studentEnquiriesRoute,
                    ),
                    backgroundColor: theme.colorScheme.surface,
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  StreamBuilder<List<PRFLocalStudentEnquiryReply>>(
                    stream: getIt<LocalDBService>().getStudentEnquiryReplies(
                      studentEnquiryUlid: enquiry.ulid,
                    ),
                    builder: (context, snapshot) {
                      // Scroll to bottom when new data arrives
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) => _scrollToBottom(),
                      );

                      if (!snapshot.hasData) {
                        return const SliverFillRemaining(
                          child: Center(child: PRFCircularProgressIndicator()),
                        );
                      }

                      final enquiryReplies = [
                        PRFLocalStudentEnquiryReply(
                          ulid: enquiry.ulid,
                          studentEnquiryUlid: enquiry.ulid,
                          content: enquiry.content,
                          createdAt: enquiry.createdAt,
                          commentorableType: PRFMorphType.student,
                          isStudent: true,
                        ),
                        if (snapshot.data != null) ...snapshot.data!,
                      ];

                      if (enquiryReplies.isEmpty) {
                        return SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: PRFEmptyView(
                              label: l10n.noQuestions,
                              description: l10n.pleaseWait,
                            ),
                          ),
                        );
                      }

                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final reply = enquiryReplies[index];
                            final isStudent = reply.isStudent;

                            return Align(
                              alignment: isStudent
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                              child: Container(
                                margin: EdgeInsets.only(
                                  left: isStudent ? 16 : 64,
                                  right: isStudent ? 64 : 16,
                                  top: 8,
                                  bottom: 8,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 14,
                                ),
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.sizeOf(context).width * 0.75,
                                ),
                                decoration: BoxDecoration(
                                  color: isStudent
                                      ? theme.colorScheme.secondaryContainer
                                      : theme.colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(18),
                                    topRight: const Radius.circular(18),
                                    bottomLeft: Radius.circular(
                                      isStudent ? 6 : 18,
                                    ),
                                    bottomRight: Radius.circular(
                                      isStudent ? 18 : 6,
                                    ),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.03,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  reply.content,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: isStudent
                                        ? theme.colorScheme.onSecondaryContainer
                                        : theme.colorScheme.onPrimaryContainer,
                                  ),
                                ),
                              ),
                            );
                          },
                          childCount: enquiryReplies.length,
                        ),
                      );
                    },
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 8)),
                ],
              ),
            ),
            // Reply input at bottom
            Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                top: 4,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: PRFTextAreaInput(
                      hintText: l10n.reply,
                      controller: _enquiryReplyController,
                      minLines: 1,
                      maxLines: 4,
                      enabled: !_isLoading,
                    ),
                  ),
                  const SizedBox(width: 8),
                  BlocConsumer<
                    CreateEnquiryReplyCubit,
                    CreateEnquiryReplyState
                  >(
                    listener: (context, state) {
                      state.mapOrNull(
                        loading: (_) {
                          setState(() => _isLoading = true);
                        },
                        loaded: (_) {
                          setState(() => _isLoading = false);
                          _enquiryReplyController.clear();
                          FocusScope.of(context).unfocus();
                        },
                      );
                    },
                    builder: (context, state) {
                      final loading = state.maybeWhen(
                        loading: () => true,
                        orElse: () => false,
                      );
                      return IconButton(
                        icon: loading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Icon(
                                Icons.near_me_rounded,
                                color: theme.colorScheme.primary,
                              ),
                        onPressed: loading
                            ? null
                            : () => _sendReply(
                                context,
                                _enquiryReplyController.text,
                              ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
