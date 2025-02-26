import 'package:app/features/student_home/faqs/cubit/get_faq_categories_cubit.dart';
import 'package:app/features/student_home/faqs/cubit/get_faqs_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:app/widgets/home_action_card/home_action_card.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class StudentLandingPageTablet extends StatefulWidget {
  const StudentLandingPageTablet({super.key});

  @override
  State<StudentLandingPageTablet> createState() =>
      _StudentLandingPageTabletState();
}

class _StudentLandingPageTabletState extends State<StudentLandingPageTablet> {
  @override
  void initState() {
    super.initState();
    context.read<GetFaqCategoriesCubit>().getFaqCategories();
    context.read<GetFaqsCubit>().getFaqs();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    Misc.initDimensions(context);
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap:
                            () => context.router.pushNamed(
                              PRFSuperAppRouter.studentAccountRoute,
                            ),
                        child: CircleAvatar(
                          radius: 70.r,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            child: Text(
                              Misc.getUserNameInitials(
                                getIt<HiveService>().retrieveProfile()!.name,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 32.w),
                      Text(
                        l10n.hello(
                          getIt<HiveService>().retrieveProfile()!.student!.name,
                        ),
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w) +
                      EdgeInsets.only(bottom: 80.h),
                  child: Text(
                    l10n.lookingFor,
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ),
                SizedBox(height: 16.h),
                Animate(
                  effects: [
                    MoveEffect(
                      duration: .5.seconds,
                      curve: Curves.easeOutQuad,
                      begin: const Offset(-160, 0),
                    ),
                  ],
                  child: HomeActionCard(
                    title: l10n.faqs,
                    assetPath: 'assets/svgs/explore.svg',
                    onTap:
                        () => context.router.pushNamed(
                          PRFSuperAppRouter.learnerFaqs,
                        ),
                  ),
                ),
                SizedBox(height: 32.h),
                Animate(
                  effects: [
                    MoveEffect(
                      duration: .5.seconds,
                      curve: Curves.easeOutQuad,
                      begin: const Offset(160, 0),
                    ),
                  ],
                  child: HomeActionCard(
                    title: l10n.askQuestion,
                    assetPath: 'assets/svgs/ask.svg',
                    onTap:
                        () => context.router.pushNamed(
                          PRFSuperAppRouter.learnerEnquiriesRoute,
                        ),
                  ),
                ),
                SizedBox(height: 32.h),
                ValueListenableBuilder(
                  valueListenable:
                      Hive.box<dynamic>(
                        PRFSuperAppConfig.instance!.values.hiveBox,
                      ).listenable(),
                  builder: (context, _, __) {
                    final (email, password) =
                        getIt<HiveService>().retrieveStudentCredentials();
                    if (password == null) {
                      return const SizedBox.shrink();
                    }
                    return Animate(
                      effects: [
                        MoveEffect(
                          duration: .5.seconds,
                          curve: Curves.easeOutQuad,
                          begin: const Offset(160, 0),
                        ),
                      ],
                      child: HomeActionCard(
                        title: l10n.viewCredentials,
                        assetPath: 'assets/svgs/credentials.svg',
                        onTap: () {
                          WoltModalSheet.show<void>(
                            context: context,
                            pageListBuilder: (modalSheetContext) {
                              return [
                                WoltModalSheetPage(
                                  backgroundColor: Colors.white,
                                  surfaceTintColor: Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                    ),
                                    child: SizedBox(
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                          0.4,
                                      child: Column(
                                        children: [
                                          Align(
                                            child: Text(
                                              l10n.credentials(email, password),
                                              style:
                                                  Theme.of(context).textTheme.headlineLarge,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ];
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
