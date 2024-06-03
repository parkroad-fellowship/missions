import 'package:app/features/home/account/cubit/sign_out_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:app/utils/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountPageHandset extends StatelessWidget {
  const AccountPageHandset({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.myAccount,
          style: CustomTextTheme.customTextTheme().displayLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const SizedBox.shrink(),
        actions: <Widget>[
          BlocListener<SignOutCubit, SignOutState>(
            listener: (context, state) {
              state.maybeWhen(
                orElse: () =>
                    context.router.replaceAll([const DecisionRoute()]),
              );
            },
            child: GestureDetector(
              onTap: () => context.read<SignOutCubit>().signOut(),
              child: Padding(
                padding: const EdgeInsets.only(right: 17),
                child: Center(
                  child: Text(
                    l10n.signOut,
                    style: CustomTextTheme.customTextTheme()
                        .headlineMedium!
                        .copyWith(
                          color: AppTheme.appTheme().kPrimaryColorV2,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<dynamic>(
          PRFSuperAppConfig.instance!.values.hiveBox,
        ).listenable(),
        builder: (context, box, _) {
          final profile = getIt<HiveService>().retrieveProfile();
          if (profile == null) {
            return const Center(
              child: SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(),
              ),
            );
          }
          return ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              const SizedBox(height: 15),
              SizedBox(
                height: 70,
                child: ListTile(
                  minLeadingWidth: 11,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  visualDensity: VisualDensity.compact,
                  leading: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: AppTheme.appTheme().kPrimaryColorV2,
                        ),
                        child: Center(
                          child: Text(
                            Misc.getUserNameInitials(
                              profile.name,
                            ),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: AppTheme.appTheme().kBackgroundColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  title: Text(
                    profile.name,
                    style:
                        CustomTextTheme.customTextTheme().titleLarge!.copyWith(
                              color: AppTheme.appTheme().kBlackColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          profile.email,
                          style: CustomTextTheme.customTextTheme()
                              .titleLarge!
                              .copyWith(
                                color: AppTheme.appTheme().kAccent5GreyColor,
                                fontSize: 13,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 4),
              ListTile(
                dense: true,
                minLeadingWidth: 9.95,
                contentPadding: const EdgeInsets.only(left: 20),
                visualDensity: VisualDensity.compact,
                onTap: () => context.router.pushNamed(
                  PRFSuperAppRouter.profileRoute,
                ),
                leading: SizedBox(
                  height: 20,
                  width: 20,
                  child: Icon(
                    Icons.person,
                    color: AppTheme.appTheme().kPrimaryColorV2,
                    size: 20,
                  ),
                ),
                title: Text(
                  l10n.viewProfile,
                  style:
                      CustomTextTheme.customTextTheme().headlineSmall!.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                ),
                subtitle: Text(
                  l10n.viewProfileDetails,
                  style: CustomTextTheme.customTextTheme().titleLarge!.copyWith(
                        color: AppTheme.appTheme().kAccent5GreyColor,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 10),
              Divider(
                color: AppTheme.appTheme().kAccent4GreyColor,
                height: 1,
              ),
              const SizedBox(width: 30),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    bottom: 20,
                    top: 30,
                  ),
                  child: Text.rich(
                    TextSpan(
                    text: l10n.byUsing,
                      style: CustomTextTheme.customTextTheme()
                          .displaySmall!
                          .copyWith(
                            fontSize: 12,
                            color: const Color(0xFF727272),
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                      children: [
                        TextSpan(
                          text: l10n.terms,
                          style: CustomTextTheme.customTextTheme()
                              .displaySmall!
                              .copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.appTheme().kPrimaryColorV2,
                              ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final uri = Uri(
                                scheme: 'https',
                                host: 'parkroadfellowship.org',
                                path: '/privacy-policy',
                              );
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(
                                  uri,
                                  mode: LaunchMode.externalApplication,
                                );
                              }
                            },
                        ),
                        TextSpan(
                          text: l10n.and,
                          style: CustomTextTheme.customTextTheme()
                              .displaySmall!
                              .copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: AppTheme.appTheme().kBlackColor,
                              ),
                        ),
                        TextSpan(
                          text: l10n.privacyPolicy,
                          style: CustomTextTheme.customTextTheme()
                              .displaySmall!
                              .copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.appTheme().kPrimaryColorV2,
                              ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final uri = Uri(
                                scheme: 'https',
                                host: 'parkroadfellowship.org',
                                path: 'privacy-policy',
                              );
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(
                                  uri,
                                  mode: LaunchMode.externalApplication,
                                );
                              }
                            },
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
