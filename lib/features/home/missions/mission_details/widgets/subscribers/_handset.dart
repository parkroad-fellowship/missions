import 'package:app/enums/prf_mission_role.dart';
import 'package:app/enums/prf_mission_subscription_status.dart';
import 'package:app/features/home/missions/cubit/get_subscribers_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/prf_local_mission_subscription.dart';
import 'package:app/models/local/shared_embeds.dart';
import 'package:app/services/local_db_service.dart';
import 'package:app/utils/_index.dart';
import 'package:app/widgets/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class SubscribersViewHandset extends StatefulWidget {
  const SubscribersViewHandset({required this.missionUlid, super.key});

  final String missionUlid;

  @override
  State<SubscribersViewHandset> createState() => _SubscribersViewHandsetState();
}

class _SubscribersViewHandsetState extends State<SubscribersViewHandset> {
  @override
  void initState() {
    context.read<GetSubscribersCubit>().getSubscriptions(
      missionUlid: widget.missionUlid,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return StreamBuilder<List<PRFLocalMissionSubscription>>(
      stream: getIt<LocalDBService>().getMissionSubscriptions(
        missionUlid: widget.missionUlid,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const PRFCircularProgressIndicator();
        }

        final subscriptions = snapshot.data;

        if (subscriptions != null && subscriptions.isEmpty) {
          return RefreshIndicator(
            onRefresh: () =>
                context.read<GetSubscribersCubit>().getSubscriptions(
                  missionUlid: widget.missionUlid,
                ),
            child: PRFEmptyView(
              label: l10n.noSubscribers,
              description: l10n.pleaseWait,
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => context.read<GetSubscribersCubit>().getSubscriptions(
            missionUlid: widget.missionUlid,
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 64),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: subscriptions!.length,
              separatorBuilder: (context, index) => const SizedBox(height: 0),
              itemBuilder: (context, index) =>
                  BeautifulSubscriberCard(
                        subscription: subscriptions[index],
                        index: index,
                      )
                      .animate(delay: (index * 100).ms)
                      .fadeIn()
                      .slideX(begin: -0.3, end: 0),
            ),
          ),
        );
      },
    );
  }
}

class BeautifulSubscriberCard extends StatelessWidget {
  const BeautifulSubscriberCard({
    required this.subscription,
    required this.index,
    super.key,
  });

  final PRFLocalMissionSubscription subscription;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLeader = subscription.missionRole != PRFMissionRole.member;

    return GestureDetector(
      onTap: () => _viewSubscriber(context, subscription.member),
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: .08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: .04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: .1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with avatar and name
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _buildAvatarIcon(theme),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              subscription.member.fullName!,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isLeader) ...[
                            const SizedBox(width: 8),
                            _buildRoleBadge(theme),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      _buildStatusChip(theme),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Action buttons row
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildActionButton(
                  theme,
                  Icons.call_outlined,
                  'Call',
                  _makeCall,
                ),
                const SizedBox(width: 12),
                _buildActionButton(
                  theme,
                  Icons.visibility_outlined,
                  'View',
                  () => _viewSubscriber(context, subscription.member),
                ),
              ],
            ),
          ],
        ),
      ).animate(effects: const [SaturateEffect()]),
    );
  }

  Widget _buildAvatarIcon(ThemeData theme) {
    if (subscription.member.profilePictureUrl != null &&
        subscription.member.profilePictureUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          subscription.member.profilePictureUrl!,
          width: 24,
          height: 24,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Icon(
            Icons.person_rounded,
            color: theme.colorScheme.onPrimaryContainer,
            size: 24,
          ),
        ),
      );
    }

    return Icon(
      Icons.person_rounded,
      color: theme.colorScheme.onPrimaryContainer,
      size: 24,
    );
  }

  Widget _buildRoleBadge(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.secondary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            size: 12,
            color: theme.colorScheme.secondary,
          ),
          const SizedBox(width: 4),
          Text(
            subscription.missionRole.name.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(ThemeData theme) {
    final isApproved =
        subscription.status == PRFMissionSubscriptionStatus.approved;
    final isPending =
        subscription.status == PRFMissionSubscriptionStatus.pending;

    Color backgroundColor;
    Color textColor;
    Color borderColor;

    if (isApproved) {
      backgroundColor = theme.colorScheme.primary.withValues(alpha: 0.1);
      textColor = theme.colorScheme.primary;
      borderColor = theme.colorScheme.primary.withValues(alpha: 0.3);
    } else if (isPending) {
      backgroundColor = theme.colorScheme.secondary.withValues(alpha: 0.1);
      textColor = theme.colorScheme.secondary;
      borderColor = theme.colorScheme.secondary.withValues(alpha: 0.3);
    } else {
      backgroundColor = theme.colorScheme.outline.withValues(alpha: 0.1);
      textColor = theme.colorScheme.onSurfaceVariant;
      borderColor = theme.colorScheme.outline.withValues(alpha: 0.3);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        subscription.status.name,
        style: theme.textTheme.bodySmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildActionButton(
    ThemeData theme,
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _makeCall() async {
    final uri = Uri(
      scheme: 'tel',
      path: subscription.member.phoneNumber,
    );
    await Misc.openUrl(uri);
  }

  void _viewSubscriber(
    BuildContext context,
    PRFLocalMember member,
  ) => WoltModalSheet.show<void>(
    context: context,
    pageListBuilder: (modalSheetContext) {
      return [
        WoltModalSheetPage(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.5,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Enhanced Profile Section
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: ClipOval(
                        child:
                            member.profilePictureUrl != null &&
                                member.profilePictureUrl!.isNotEmpty
                            ? Image.network(
                                member.profilePictureUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    _buildProfileFallback(
                                      Theme.of(context),
                                      member,
                                    ),
                              )
                            : _buildProfileFallback(Theme.of(context), member),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Member Name
                  Text(
                    member.fullName!,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Bio Section
                  if (member.bio != null && member.bio!.isNotEmpty) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.outline.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Text(
                        member.bio!,
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Contact Actions
                  Row(
                    children: [
                      Expanded(
                        child: PRFPrimaryButton(
                          onPressed: _makeCall,
                          title: 'Call Member',
                          disabled: false,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ];
    },
  );

  Widget _buildProfileFallback(ThemeData theme, PRFLocalMember member) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.8),
            theme.colorScheme.secondary.withValues(alpha: 0.6),
          ],
        ),
      ),
      child: Center(
        child: Text(
          member.fullName![0].toUpperCase(),
          style: theme.textTheme.displayLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
