import 'package:app/enums/prf_mission_role.dart';
import 'package:app/features/home/missions/cubit/get_subscribers_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/prf_local_mission_subscription.dart';
import 'package:app/services/local_db_service.dart';
import 'package:app/utils/_index.dart';
import 'package:app/widgets/circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
            onRefresh:
                () => context.read<GetSubscribersCubit>().getSubscriptions(
                  missionUlid: widget.missionUlid,
                ),
            child: Column(
              children: [
                const Spacer(),
                const Icon(Icons.directions_walk),
                Center(
                  child: Text(
                    l10n.noSubscribers,
                    style: Theme.of(context).textTheme.headlineMedium!,
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
                        style: Theme.of(context).textTheme.displayLarge!,
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
          onRefresh:
              () => context.read<GetSubscribersCubit>().getSubscriptions(
                missionUlid: widget.missionUlid,
              ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: subscriptions!.length,
            separatorBuilder: (context, index) => SizedBox(height: 16.h),
            itemBuilder:
                (context, index) =>
                    SubscriberActionCard(subscription: subscriptions[index]),
          ),
        );
      },
    );
  }
}

class SubscriberActionCard extends StatelessWidget {
  const SubscriberActionCard({required this.subscription, super.key});

  final PRFLocalMissionSubscription subscription;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Animate(
      effects: const [SaturateEffect()],
      child: Stack(
        children: [
          Container(
            width: width,
            padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 60.h),
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
               color: Theme.of(context).colorScheme.secondary.withValues(alpha:.3),
              borderRadius: BorderRadius.circular(48.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: subscription.member.fullName,
                          style: Theme.of(context).textTheme.displayLarge,
                          children: [
                            if (subscription.missionRole !=
                                PRFMissionRole.member)
                              TextSpan(
                                text: ' ${subscription.missionRole.name}',
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(subscription.status.name),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 32.w,
                    vertical: 4.h,
                  ),
                  child: Animate(
                    effects: const [
                      ShakeEffect(
                        duration: Duration(seconds: 2),
                        delay: Duration(milliseconds: 500),
                      ),
                    ],
                    child: IconButton(
                      icon: const Icon(Icons.call),
                     color: Theme.of(context).colorScheme.primary,
                      onPressed: () async {
                        final uri = Uri(
                          scheme: 'tel',
                          path: subscription.member.phoneNumber,
                        );
                        await Misc.openUrl(uri);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
