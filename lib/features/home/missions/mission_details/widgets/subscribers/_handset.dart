import 'package:app/enums/prf_mission_role.dart';
import 'package:app/enums/prf_mission_subscription_status.dart';
import 'package:app/features/home/missions/cubit/get_subscribers_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/prf_mission_subscription.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscribersViewHandset extends StatefulWidget {
  const SubscribersViewHandset({required this.missionUlid, super.key});

  final String missionUlid;

  @override
  State<SubscribersViewHandset> createState() => _SubscribersViewHandsetState();
}

class _SubscribersViewHandsetState extends State<SubscribersViewHandset> {
  @override
  void initState() {
    context
        .read<GetSubscribersCubit>()
        .getSubscriptions(missionUlid: widget.missionUlid);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<GetSubscribersCubit, GetSubscribersState>(
      builder: (context, state) {
        return state.maybeWhen(
          orElse: () => const Center(child: CircularProgressIndicator()),
          loaded: (subscriptions) {
            if (subscriptions.isEmpty) {
              return Center(
                child: Text(
                  l10n.noSubscribers,
                  style:
                      CustomTextTheme.customTextTheme().headlineSmall!.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.appTheme().kPrimaryColorV2,
                          ),
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: subscriptions.length,
              separatorBuilder: (context, index) => SizedBox(height: 16.h),
              itemBuilder: (context, index) =>
                  SubscriberActionCard(subscription: subscriptions[index]),
            );
          },
        );
      },
    );
  }
}

class SubscriberActionCard extends StatelessWidget {
  const SubscriberActionCard({
    required this.subscription,
    super.key,
  });

  final PRFMissionSubscription subscription;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Animate(
      effects: const [
        SaturateEffect(),
      ],
      child: Stack(
        children: [
          Container(
            width: width,
            padding: EdgeInsets.symmetric(
              horizontal: 50.w,
              vertical: 60.h,
            ),
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: AppTheme.appTheme().kSecondaryColorV2.withOpacity(.3),
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
                          text: subscription.member!.fullName,
                          style: CustomTextTheme.customTextTheme()
                              .displayLarge
                              ?.copyWith(
                                color: AppTheme.appTheme().kPrimaryColorV2,
                                fontWeight: FontWeight.w600,
                              ),
                          children: [
                            if (subscription.missionRole !=
                                PRFMissionRole.member)
                              TextSpan(
                                text: ' ${subscription.missionRole.name}',
                                style: CustomTextTheme.customTextTheme()
                                    .displaySmall
                                    ?.copyWith(
                                      color:
                                          AppTheme.appTheme().kPrimaryColorV2,
                                    ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        subscription.status.name,
                      ),
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
                  child: IconButton(
                    icon: const Icon(Icons.call),
                    color: AppTheme.appTheme().kPrimaryColorV2,
                    onPressed: () async {
                      final uri = Uri(
                        scheme: 'tel',
                        path: subscription.member!.phoneNumber,
                      );
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(
                          uri,
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    },
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
