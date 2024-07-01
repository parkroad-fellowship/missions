import 'package:app/features/student_home/account/account.dart';
import 'package:app/features/student_home/faqs/faqs.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';

class StudentLandingPageHandset extends StatefulWidget {
  const StudentLandingPageHandset({super.key});

  @override
  State<StudentLandingPageHandset> createState() =>
      _StudentLandingPageHandsetState();
}

class _StudentLandingPageHandsetState extends State<StudentLandingPageHandset> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    FAQPage(),
    StudentAccountPage(),
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
                    Icons.question_answer,
                    color: _currentIndex == 0
                        ? AppTheme.appTheme().kPrimaryColorV2
                        : AppTheme.appTheme().kDullGreyColor,
                  ),
                ),
              ),
              label: l10n.faq,
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: SizedBox(
                  height: 25,
                  width: 25,
                  child: Icon(
                    Icons.person,
                    color: _currentIndex == 1
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
