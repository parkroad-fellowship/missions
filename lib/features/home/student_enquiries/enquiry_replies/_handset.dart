import 'dart:async';

import 'package:app/di/di_container.dart';
import 'package:app/enums/common/prf_morph_types.dart';
import 'package:app/features/home/student_enquiries/cubit/enquiry_reply_resource_cubit.dart';
import 'package:app/features/home/student_enquiries/cubit/enquiry_resource_cubit.dart';
import 'package:app/features/home/student_enquiries/enquiry_replies/_shared.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/common/socket_config.dart';
import 'package:app/models/remote/enquiry/prf_student_enquiry.dart';
import 'package:app/models/remote/enquiry/prf_student_enquiry_reply.dart';
import 'package:app/services/socket_service.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:app/utils/router/router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class StudentEnquiryRepliesPageHandset extends StatefulWidget {
  const StudentEnquiryRepliesPageHandset({
    required this.enquiryUlid,
    super.key,
  });

  final String enquiryUlid;

  @override
  State<StudentEnquiryRepliesPageHandset> createState() =>
      _StudentEnquiryRepliesPageHandsetState();
}

class _StudentEnquiryRepliesPageHandsetState
    extends State<StudentEnquiryRepliesPageHandset>
    with TickerProviderStateMixin {
  String get enquiryUlid => widget.enquiryUlid;
  final _enquiryReplyController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool _isComposing = false;
  int _lastMessageCount = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    context.read<EnquiryResourceCubit>().loadAll(
      filters: {'student_enquiry_ulid': enquiryUlid},
    );
    // Fetch initial replies
    context.read<EnquiryReplyResourceCubit>().loadAll(
      filters: {'student_enquiry_ulid': enquiryUlid},
    );
    _subscribeToEnquiryReplies();

    _animationController = AnimationController(
      duration: PRFMotionTokens.slow,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _enquiryReplyController.addListener(() {
      setState(() {
        _isComposing = _enquiryReplyController.text.trim().isNotEmpty;
      });
    });

    // Scroll to bottom after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    getIt<SocketService>().unsubscribePrivateChannels({
      'App.Models.StudentEnquiry.$enquiryUlid',
    });
    _animationController.dispose();
    _enquiryReplyController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: PRFMotionTokens.slow,
        curve: Curves.easeOutCubic,
      );
    }
  }

  Future<void> _subscribeToEnquiryReplies() async {
    await getIt<SocketService>().init(
      socketConfig: SocketConfig(
        privateChannels: {
          ...getIt<SocketService>().defaultConfig().privateChannels,
          'App.Models.StudentEnquiry.$enquiryUlid': <String>[
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

    await context.read<EnquiryReplyResourceCubit>().createReply(
      studentEnquiryUlid: enquiryUlid,
      content: text.trim(),
    );
  }

  Widget _buildEnhancedInputArea() {
    final l10n = context.l10n;

    return BlocConsumer<
      EnquiryReplyResourceCubit,
      ResourceState<PRFStudentEnquiryReply>
    >(
      listener: (context, state) {
        state.mapOrNull(
          listLoaded: (_) {
            _enquiryReplyController.clear();
            FocusScope.of(context).unfocus();
            PRFSnackbar.success(context, context.l10n.replySent);
          },
        );
      },
      builder: (context, state) {
        final loading = state.maybeWhen(
          listLoading: (_) => true,
          mutating: (_, _) => true,
          orElse: () => false,
        );

        return AnimatedContainer(
          duration: PRFMotionTokens.standard,
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              if (_focusNode.hasFocus)
                BoxShadow(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.12),
                  blurRadius: 18,
                  offset: const Offset(0, -2),
                ),
            ],
          ),
          child: PRFReplyComposer(
            controller: _enquiryReplyController,
            hintText: l10n.reply,
            isComposing: _isComposing,
            isLoading: loading,
            hasFocus: _focusNode.hasFocus,
            bottomInset: MediaQuery.of(context).viewInsets.bottom,
            onSend: () => _sendReply(
              context,
              _enquiryReplyController.text,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return FadeTransition(
      opacity: _fadeAnimation,
      child:
          BlocBuilder<EnquiryResourceCubit, ResourceState<PRFStudentEnquiry>>(
            builder: (context, enquiryState) {
              final enquiry = enquiryState.maybeWhen(
                listLoaded: (items, _, _) =>
                    items.isNotEmpty ? items.first : null,
                orElse: () => null,
              );

              if (enquiry == null) {
                return enquiryState.maybeWhen(
                  listLoading: (_) => const Scaffold(
                    body: Center(
                      child: PRFCircularProgressIndicator(),
                    ),
                  ),
                  orElse: () => Scaffold(
                    body: Center(
                      child: PRFEmptyView(
                        label: l10n.noQuestions,
                        description: l10n.pleaseWait,
                      ),
                    ),
                  ),
                );
              }

              return BlocBuilder<
                EnquiryReplyResourceCubit,
                ResourceState<PRFStudentEnquiryReply>
              >(
                builder: (context, replyState) {
                  final replies = replyState.maybeWhen(
                    listLoaded: (items, _, _) => items,
                    orElse: () => null,
                  );

                  final enquiryReplies = replies == null
                      ? <PRFStudentEnquiryReply>[]
                      : <PRFStudentEnquiryReply>[
                          PRFStudentEnquiryReply(
                            enquiryUlid,
                            enquiry.content,
                            PRFMorphType.student,
                            enquiry.createdAt,
                            enquiry.updatedAt,
                          ),
                          ...replies,
                        ];

                  if (enquiryReplies.length != _lastMessageCount) {
                    _lastMessageCount = enquiryReplies.length;
                    WidgetsBinding.instance.addPostFrameCallback(
                      (_) => _scrollToBottom(),
                    );
                  }

                  return PRFChatView<PRFStudentEnquiryReply>(
                    title: l10n.studentQuestions,
                    onBack: () => context.router.popUntilRouteWithPath(
                      PRFSuperAppRouter.studentEnquiriesRoute,
                    ),
                    scrollController: _scrollController,
                    loading: replies == null,
                    emptyLabel: l10n.noQuestions,
                    emptyDescription: l10n.pleaseWait,
                    messages: enquiryReplies,
                    messageBuilder: (context, message, index) =>
                        buildMessageBubble(context, l10n, message, index),
                    composer: _buildEnhancedInputArea(),
                  );
                },
              );
            },
          ),
    );
  }
}
