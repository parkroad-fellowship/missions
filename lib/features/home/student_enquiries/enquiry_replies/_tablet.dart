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

class StudentEnquiryRepliesPageTablet extends StatefulWidget {
  const StudentEnquiryRepliesPageTablet({
    required this.enquiryUlid,
    super.key,
  });

  final String enquiryUlid;

  @override
  State<StudentEnquiryRepliesPageTablet> createState() =>
      _StudentEnquiryRepliesPageTabletState();
}

class _StudentEnquiryRepliesPageTabletState
    extends State<StudentEnquiryRepliesPageTablet>
    with TickerProviderStateMixin {
  String get enquiryUlid => widget.enquiryUlid;

  final _enquiryReplyController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool _isLoading = false;
  bool _isComposing = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    context.read<EnquiryResourceCubit>().loadAll(
      filters: {'student_enquiry_ulid': enquiryUlid},
    );
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
    final theme = Theme.of(context);
    final isStudent = _isStudentReply(reply);

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 50)),
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
      child: Container(
        margin: EdgeInsets.only(
          left: isStudent ? 16 : 80,
          right: isStudent ? 80 : 16,
          top: PRFSpacingTokens.xs,
          bottom: PRFSpacingTokens.xs,
        ),
        child: Column(
          crossAxisAlignment: isStudent
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: PRFSpacingTokens.lg,
                vertical: PRFSpacingTokens.md,
              ),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.sizeOf(context).width * 0.75,
              ),
              decoration: BoxDecoration(
                gradient: isStudent
                    ? LinearGradient(
                        colors: [
                          theme.colorScheme.secondaryContainer,
                          theme.colorScheme.secondaryContainer.withValues(
                            alpha: 0.8,
                          ),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : LinearGradient(
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.primary.withValues(alpha: 0.9),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isStudent ? 4 : 20),
                  bottomRight: Radius.circular(isStudent ? 20 : 4),
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        (isStudent
                                ? theme.colorScheme.secondaryContainer
                                : theme.colorScheme.primary)
                            .withValues(alpha: 0.3),
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
                      : Colors.white,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: PRFSpacingTokens.xs),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: PRFSpacingTokens.sm,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatTimestamp(reply.createdAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 11,
                    ),
                  ),
                  if (!isStudent) ...[
                    const SizedBox(width: PRFSpacingTokens.xs),
                    Icon(
                      Icons.check_circle,
                      size: 12,
                      color: theme.colorScheme.primary.withValues(alpha: 0.7),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedInputArea() {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: PRFSpacingTokens.lg,
          right: PRFSpacingTokens.lg,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          top: 12,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(PRFRadiusTokens.xl),
                  border: Border.all(
                    color: _focusNode.hasFocus
                        ? theme.colorScheme.primary.withValues(alpha: 0.5)
                        : theme.colorScheme.outline.withValues(alpha: 0.3),
                  ),
                ),
                child: PRFTextAreaInput(
                  hintText: l10n.reply,
                  controller: _enquiryReplyController,
                  minLines: 1,
                  maxLines: 4,
                  enabled: !_isLoading,
                ),
              ),
            ),
            const SizedBox(width: PRFSpacingTokens.md),
            BlocConsumer<
              EnquiryReplyResourceCubit,
              ResourceState<PRFStudentEnquiryReply>
            >(
              listener: (context, state) {
                state.mapOrNull(
                  mutating: (_) {
                    setState(() => _isLoading = true);
                  },
                  mutated: (_) {
                    setState(() => _isLoading = false);
                    _enquiryReplyController.clear();
                    FocusScope.of(context).unfocus();
                  },
                );
              },
              builder: (context, state) {
                final loading = state.maybeWhen(
                  listLoading: () => true,
                  orElse: () => false,
                );

                return AnimatedContainer(
                  duration: PRFMotionTokens.standard,
                  decoration: BoxDecoration(
                    gradient: _isComposing
                        ? LinearGradient(
                            colors: [
                              theme.colorScheme.primary,
                              theme.colorScheme.primary.withValues(alpha: 0.8),
                            ],
                          )
                        : null,
                    color: _isComposing
                        ? null
                        : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(PRFRadiusTokens.xl),
                    boxShadow: _isComposing
                        ? [
                            BoxShadow(
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.3,
                              ),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: IconButton(
                    icon: loading
                        ? SizedBox(
                            width: PRFSpacingTokens.xl,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _isComposing
                                    ? Colors.white
                                    : theme.colorScheme.primary,
                              ),
                            ),
                          )
                        : Icon(
                            Icons.send_rounded,
                            color: _isComposing
                                ? Colors.white
                                : theme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                    onPressed: loading || !_isComposing
                        ? null
                        : () => _sendReply(
                            context,
                            _enquiryReplyController.text,
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
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
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: BlocBuilder<
                  EnquiryResourceCubit,
                  ResourceState<PRFStudentEnquiry>
                >(
                  builder: (context, enquiryState) {
                    final enquiry = enquiryState.maybeWhen(
                      listLoaded: (items, _, _) =>
                          items.isNotEmpty ? items.first : null,
                      orElse: () => null,
                    );

                    if (enquiry == null) {
                      return enquiryState.maybeWhen(
                        listLoading: () => const Center(
                          child: PRFCircularProgressIndicator(),
                        ),
                        orElse: () => Center(
                          child: PRFEmptyView(
                            label: l10n.noQuestions,
                            description: l10n.pleaseWait,
                          ),
                        ),
                      );
                    }

                    return CustomScrollView(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        PRFNavBar(
                          title: l10n.studentQuestions,
                          onBack: () => context.router.popUntilRouteWithPath(
                            PRFSuperAppRouter.studentEnquiriesRoute,
                          ),
                          backgroundColor: theme.colorScheme.surface,
                        ),
                        const SliverToBoxAdapter(
                          child: SizedBox(height: PRFSpacingTokens.lg),
                        ),
                        BlocBuilder<
                          EnquiryReplyResourceCubit,
                          ResourceState<PRFStudentEnquiryReply>
                        >(
                          builder: (context, replyState) {
                            // Scroll to bottom when new data arrives
                            WidgetsBinding.instance.addPostFrameCallback(
                              (_) => _scrollToBottom(),
                            );

                            final replies = replyState.maybeWhen(
                              listLoaded: (items, _, _) => items,
                              orElse: () => null,
                            );

                            if (replies == null) {
                              return const SliverFillRemaining(
                                child: Center(
                                  child: PRFCircularProgressIndicator(),
                                ),
                              );
                            }

                            // Create synthetic first message from enquiry
                            final syntheticFirst = PRFStudentEnquiryReply(
                              enquiryUlid,
                              enquiry.content,
                              PRFMorphType.student,
                              enquiry.createdAt,
                              enquiry.updatedAt,
                            );

                            final enquiryReplies = [
                              syntheticFirst,
                              ...replies,
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
                                  return _buildMessageBubble(reply, index);
                                },
                                childCount: enquiryReplies.length,
                              ),
                            );
                          },
                        ),
                        const SliverToBoxAdapter(
                          child: SizedBox(height: PRFSpacingTokens.lg),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            _buildEnhancedInputArea(),
          ],
        ),
      ),
    );
  }
}
