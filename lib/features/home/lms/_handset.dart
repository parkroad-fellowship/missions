import 'package:app/features/home/lms/cubit/get_courses_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LMSPageHandset extends StatefulWidget {
  const LMSPageHandset({super.key});

  @override
  State<LMSPageHandset> createState() => _LMSPageHandsetState();
}

class _LMSPageHandsetState extends State<LMSPageHandset> {
  @override
  void initState() {
    context.read<GetCoursesCubit>().getCourses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.learn,
          style: CustomTextTheme.customTextTheme()
              .displayLarge
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const SizedBox.shrink(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: BlocBuilder<GetCoursesCubit, GetCoursesState>(
          builder: (context, state) => state.maybeWhen(
            orElse: () => const Center(child: CircularProgressIndicator()),
            error: (message) => Center(child: Text(message)),
            loaded: () => StreamBuilder(
              stream: getIt<LocalDBService>().getCourses(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final courses = snapshot.data;

                if (courses != null && courses.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () =>
                        context.read<GetCoursesCubit>().getCourses(),
                    child: Column(
                      children: [
                        const Spacer(),
                        const Icon(
                          Icons.directions_walk,
                        ),
                        Center(
                          child: Text(
                            l10n.noMissions,
                            style: CustomTextTheme.customTextTheme()
                                .headlineMedium!
                                .copyWith(
                                  color: AppTheme.appTheme().kDullGreyColor,
                                  fontWeight: FontWeight.w600,
                                ),
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
                                style: CustomTextTheme.customTextTheme()
                                    .displayLarge!
                                    .copyWith(
                                      color:
                                          AppTheme.appTheme().kPrimaryColorV2,
                                      fontSize: 14,
                                    ),
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
                  onRefresh: () => context.read<GetCoursesCubit>().getCourses(),
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: courses!.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      return ExpansionTile(
                        initiallyExpanded: true,
                        trailing: Icon(
                          Icons.keyboard_arrow_right,
                          color: AppTheme.appTheme().kDullGreyColor,
                          size: 24,
                        ),
                        title: Text(
                          course.name.toUpperCase(),
                          style: CustomTextTheme.customTextTheme()
                              .headlineSmall!
                              .copyWith(
                                color:
                                    AppTheme.appTheme().kAccent2BackgroundColor,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        children: [
                          ListTile(
                            dense: true,
                            minLeadingWidth: 10.5,
                            contentPadding: const EdgeInsets.only(left: 20),
                            visualDensity: VisualDensity.compact,
                            // onTap: () => context.router.push(
                            //   MissionsDetailsRoute(mission: mission),
                            // ),
                            title: Text(
                              l10n.progress(
                                course.courseMember?.percentComplete ?? 0,
                              ),
                              style: CustomTextTheme.customTextTheme()
                                  .headlineMedium!
                                  .copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  course.description,
                                  style: CustomTextTheme.customTextTheme()
                                      .bodySmall!
                                      .copyWith(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
