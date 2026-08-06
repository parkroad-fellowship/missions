import 'package:app/features/missions/mission_details/widgets/record_sections.dart';
import 'package:app/features/missions/mission_details/widgets/subscribers/cubit/mission_subscription_resource_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/member/prf_member.dart';
import 'package:app/models/remote/mission/prf_mission_subscription.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:app/utils/helpers/url_helper.dart';
import 'package:app/utils/mixins/timezone_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class SubscribersViewHandset extends StatefulWidget {
  const SubscribersViewHandset({required this.missionUlid, super.key});

  final String missionUlid;

  @override
  State<SubscribersViewHandset> createState() => _SubscribersViewHandsetState();
}

class _SubscribersViewHandsetState extends State<SubscribersViewHandset>
    with TimezoneMixin {
  Future<void> _loadSubscriptions() {
    return context.read<MissionSubscriptionResourceCubit>().loadAll(
      filters: {'mission_ulid': widget.missionUlid},
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<
      MissionSubscriptionResourceCubit,
      ResourceState<PRFMissionSubscription>
    >(
      builder: (context, state) {
        final subscriptions = state.maybeWhen(
          listLoaded: (items, _, _) => items,
          mutating: (items, _) => items,
          error: (_, items) => items,
          orElse: () => <PRFMissionSubscription>[],
        );
        final error = state.mapOrNull(
          error: (state) => state.message,
        );
        final isLoading = state.maybeWhen(
          listLoading: (_) => true,
          orElse: () => false,
        );

        if (isLoading && subscriptions.isEmpty) {
          return const Center(child: PRFCircularProgressIndicator());
        }

        if (error != null && subscriptions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: PRFSpacingTokens.lg),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: PRFSpacingTokens.xl,
                  ),
                  child: Text(
                    error,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
                const SizedBox(height: PRFSpacingTokens.lg),
                FilledButton.icon(
                  onPressed: _loadSubscriptions,
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(context.l10n.retry),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _loadSubscriptions,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              PRFSpacingTokens.lg,
              PRFSpacingTokens.lg,
              PRFSpacingTokens.lg,
              PRFSpacingTokens.xxxl,
            ),
            children: [
              MissionSectionCard(
                title: context.l10n.missionSubscribers,
                subtitle: context.l10n.membersSubscribedToThisMission,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${subscriptions.length} subscribed',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: PRFSpacingTokens.md),
                    if (error != null)
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(
                          bottom: PRFSpacingTokens.md,
                        ),
                        padding: const EdgeInsets.all(PRFSpacingTokens.sm),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(
                            PRFRadiusTokens.md,
                          ),
                        ),
                        child: Text(
                          error,
                          style:
                              Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onErrorContainer,
                              ),
                        ),
                      ),
                    if (subscriptions.isEmpty)
                      PRFEmptyView(
                        label: l10n.noSubscribers,
                        description: l10n.pleaseWait,
                      )
                    else
                      ...subscriptions.map(
                        (subscription) => _SubscriptionCard(
                          subscription: subscription,
                          subtitle:
                              '${subscription.missionRole.name} · '
                              '${subscription.status.name} · '
                              'Subscribed ${DateFormatter.formatDateTime(subscription.createdAt, timezone)}',
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SubscriptionCard extends StatelessWidget {
  const _SubscriptionCard({
    required this.subscription,
    required this.subtitle,
  });

  final PRFMissionSubscription subscription;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final member = subscription.member;

    return Padding(
      padding: const EdgeInsets.only(bottom: PRFSpacingTokens.sm),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: PRFSpacingTokens.md,
          vertical: PRFSpacingTokens.md,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.38),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member?.fullName ?? 'N/A',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (member != null)
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerLeft,
                        foregroundColor: theme.colorScheme.primary,
                      ),
                      onPressed: () => _viewSubscriber(context, member),
                      child: Text(context.l10n.viewDetails),
                    ),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (member != null)
              IconButton(
                tooltip: 'View subscriber',
                onPressed: () => _viewSubscriber(context, member),
                icon: Icon(
                  Icons.visibility_outlined,
                  color: theme.colorScheme.primary,
                ),
              ),
            IconButton(
              tooltip: 'Call subscriber',
              onPressed: () => _makeCall(member),
              icon: Icon(
                Icons.phone_outlined,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _makeCall(PRFMember? member) async {
    final uri = Uri(
      scheme: 'tel',
      path: member?.phoneNumber,
    );
    await UrlHelper.openUrl(uri);
  }

  void _viewSubscriber(
    BuildContext context,
    PRFMember member,
  ) => PRFBottomSheet.show<void>(
    context,
    title: member.fullName,
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: PRFSpacingTokens.lg,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
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
              ),
              child: Container(
                margin: const EdgeInsets.all(PRFSpacingTokens.xs),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: PRFColors.white,
                ),
                child: ClipOval(
                  child:
                      member.profilePicture?.temporaryURL != null &&
                          member.profilePicture!.temporaryURL.isNotEmpty
                      ? Image.network(
                          member.profilePicture!.temporaryURL,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _buildProfileFallback(
                                Theme.of(context),
                                member,
                              ),
                        )
                      : _buildProfileFallback(
                          Theme.of(context),
                          member,
                        ),
                ),
              ),
            ),
            const SizedBox(height: PRFSpacingTokens.xl),

            // Member Name
            Text(
              member.fullName,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: PRFSpacingTokens.lg),

            // Bio Section
            if (member.bio != null && member.bio!.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(PRFSpacingTokens.lg),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(
                    PRFRadiusTokens.smd,
                  ),
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
              const SizedBox(height: PRFSpacingTokens.xl),
            ],

            // Contact Actions
            Row(
              children: [
                Expanded(
                  child: PRFButton(
                    onPressed: () => _makeCall(member),
                    title: context.l10n.callMember,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );

  Widget _buildProfileFallback(ThemeData theme, PRFMember member) {
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
          member.fullName[0].toUpperCase(),
          style: theme.textTheme.displayLarge?.copyWith(
            color: PRFColors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
