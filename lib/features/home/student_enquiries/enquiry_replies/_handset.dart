import 'package:app/enums/common/prf_morph_types.dart';
import 'package:app/features/home/student_enquiries/cubit/enquiry_reply_resource_cubit.dart';
import 'package:app/features/home/student_enquiries/cubit/enquiry_resource_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/common/socket_config.dart';
import 'package:app/models/remote/enquiry/prf_student_enquiry.dart';
import 'package:app/models/remote/enquiry/prf_student_enquiry_reply.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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
    _animationController.dispose();
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
      data: {
        'student_enquiry_ulid': enquiryUlid,
        'content': text.trim(),
      },
    );
  }

  String _formatTimestamp(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return DateFormat('HH:mm').format(dateTime);
    } else if (difference.inDays == 1) {
      return 'Yesterday ${DateFormat('HH:mm').format(dateTime)}';
    } else if (difference.inDays < 7) {
      return DateFormat('EEE HH:mm').format(dateTime);
    } else {
      return DateFormat('MMM d, HH:mm').format(dateTime);
    }
  }

  bool _isStudentReply(PRFStudentEnquiryReply reply) =>
      reply.commentorableType == PRFMorphType.student;

  Widget _buildMessageBubble(PRFStudentEnquiryReply reply, int index) {
    final isStudent = _isStudentReply(reply);
    final l10n = context.l10n;
    final semanticRole = isStudent ? l10n.unread : l10n.replied;

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 220 + (index * 35)),
      tween: Tween(begin: 0, end: 1),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: Semantics(
        label:
            '$semanticRole: ${reply.content}. ${_formatTimestamp(reply.createdAt)}',
        child: PRFMessageBubble(
          message: reply.content,
          timestamp: _formatTimestamp(reply.createdAt),
          isIncoming: isStudent,
          showStatusIndicator: !isStudent,
          margin: EdgeInsets.only(
            left: isStudent
                ? PRFSpacingTokens.lg
                : 76, // 76 keeps outgoing alignment while reducing crowding
            right: isStudent
                ? 76
                : PRFSpacingTokens
                      .lg, // 76 keeps incoming alignment while reducing crowding
            top: PRFSpacingTokens.xs,
            bottom: PRFSpacingTokens.xs,
          ),
          maxWidth: MediaQuery.sizeOf(context).width * 0.77,
        ),
      ),
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
          mutated: (_) {
            _enquiryReplyController.clear();
            FocusScope.of(context).unfocus();
            PRFSnackbar.success(context, context.l10n.replySent);
          },
        );
      },
      builder: (context, state) {
        final loading = state.maybeWhen(
          listLoading: () => true,
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
                  listLoading: () => const Scaffold(
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
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => _scrollToBottom(),
                  );

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
                        _buildMessageBubble(message, index),
                    composer: _buildEnhancedInputArea(),
                  );
                },
              );
            },
          ),
    );
  }
}
