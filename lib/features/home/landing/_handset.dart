import 'package:app/features/home/account/account.dart';
import 'package:app/features/home/lms/lms.dart';
import 'package:app/features/home/missions/cubit/get_class_groups_cubit.dart';
import 'package:app/features/home/missions/missions.dart';
import 'package:app/features/home/my_missions/my_missions.dart';
import 'package:app/features/home/student_enquiries/student_enquiries.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LandingPageHandset extends StatefulWidget {
  const LandingPageHandset({super.key});

  @override
  State<LandingPageHandset> createState() => _LandingPageHandsetState();
}

class _LandingPageHandsetState extends State<LandingPageHandset> {
  int _currentIndex = 0;

  @override
  void initState() {
    context.read<GetClassGroupsCubit>().getClassGroups();
    super.initState();
  }

  final List<Widget> _pages = const [
    MissionsPage(),
    MyMissionsPage(),
    LMSPage(),
    StudentEnquiriesPage(),
    AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          selectedIconTheme: IconThemeData(
            color: AppTheme.appTheme().kBlackColor,
          ),
          selectedItemColor: Colors.black,
          backgroundColor: Colors.white,
          currentIndex: _currentIndex,
          onTap: (int index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: SizedBox(
                  height: 25,
                  width: 25,
                  child: Icon(
                    Icons.search,
                    color: _currentIndex == 0
                        ? AppTheme.appTheme().kPrimaryColorV2
                        : AppTheme.appTheme().kDullGreyColor,
                  ),
                ),
              ),
              label: l10n.missions,
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: SizedBox(
                  height: 25,
                  width: 25,
                  child: Icon(
                    Icons.list,
                    color: _currentIndex == 1
                        ? AppTheme.appTheme().kPrimaryColorV2
                        : AppTheme.appTheme().kDullGreyColor,
                  ),
                ),
              ),
              label: l10n.myMissions,
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: SizedBox(
                  height: 25,
                  width: 25,
                  child: Icon(
                    Icons.menu_book_rounded,
                    color: _currentIndex == 2
                        ? AppTheme.appTheme().kPrimaryColorV2
                        : AppTheme.appTheme().kDullGreyColor,
                  ),
                ),
              ),
              label: l10n.learn,
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: SizedBox(
                  height: 25,
                  width: 25,
                  child: Icon(
                    Icons.online_prediction_outlined,
                    color: _currentIndex == 3
                        ? AppTheme.appTheme().kPrimaryColorV2
                        : AppTheme.appTheme().kDullGreyColor,
                  ),
                ),
              ),
              label: l10n.studentEnquiries,
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: SizedBox(
                  height: 25,
                  width: 25,
                  child: Icon(
                    Icons.person,
                    color: _currentIndex == 4
                        ? AppTheme.appTheme().kPrimaryColorV2
                        : AppTheme.appTheme().kDullGreyColor,
                  ),
                ),
              ),
              label: l10n.myAccount,
            ),
          ],
        ),
      ),
    );
  }
}
