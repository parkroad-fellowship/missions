import 'package:app/enums/prf_mission_subscription_status.dart';
import 'package:app/features/home/missions/cubit/get_subscribers_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    context.read<GetSubscribersCubit>().getSubscriptions(
          missionUlid: widget.missionUlid,
          // subscriptionStatus: PRFMissionSubscriptionStatus.pending,
        );

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
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final subscription = subscriptions[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          flex: 8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Card(
                                    elevation: 0,
                                    color: AppTheme.appTheme()
                                        .kPrimaryColorV2Accent,
                                    surfaceTintColor: AppTheme.appTheme()
                                        .kPrimaryColorV2Accent,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5,
                                        horizontal: 8,
                                      ),
                                      child: Text(
                                        subscription.member!.fullName,
                                        style: CustomTextTheme.customTextTheme()
                                            .headlineSmall!
                                            .copyWith(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: AppTheme.appTheme()
                                                  .kPrimaryColorV2,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.comingFrom(
                                        subscription.member!.residence,
                                      ),
                                      overflow: TextOverflow.clip,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: Column(
                            children: [
                              IconButton(
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
                                icon: Icon(
                                  Icons.call,
                                  color: AppTheme.appTheme().kPrimaryColorV2,
                                ),
                              ),
                              Text(
                                PRFMissionSubscriptionStatusExtension.fromIndex(
                                  subscription.status,
                                ).name,
                                style:
                                    CustomTextTheme.customTextTheme().bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
