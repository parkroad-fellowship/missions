import 'package:app/features/home/missions/cubit/get_mission_questions_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/prf_mission_question.dart';
import 'package:app/models/remote/prf_mission_question.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MissionQuestionsViewHandset extends StatefulWidget {
  const MissionQuestionsViewHandset({required this.missionUlid, super.key});

  final String missionUlid;

  @override
  State<MissionQuestionsViewHandset> createState() =>
      _MissionQuestionsViewHandsetState();
}

class _MissionQuestionsViewHandsetState
    extends State<MissionQuestionsViewHandset> {
  String get missionUlid => widget.missionUlid;

  @override
  void initState() {
    context.read<GetMissionQuestionsCubit>().getMissionQuestions(
      missionUlid: missionUlid,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SingleStreamWrapper(
      stream: getIt<LocalDBService>().getMissionQuestions(
        missionUlid: missionUlid,
      ),
      nullWidget: Center(
        child: Text(
          l10n.noQuestions,
          style: PRFText.theme().headlineSmall!.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: PRFApp.theme().kPrimaryColorV2,
          ),
        ),
      ),
      widget:
          (context, missionQuestions) => ListView.separated(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: missionQuestions.length,
            separatorBuilder: (context, index) => SizedBox(height: 8.h),
            itemBuilder:
                (context, index) => MissionQuestionCard(
                  missionQuestion: missionQuestions[index],
                ),
          ),
    );
    ;
  }
}

class MissionQuestionCard extends StatelessWidget {
  const MissionQuestionCard({required this.missionQuestion, super.key});

  final PRFLocalMissionQuestion missionQuestion;

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
              color: PRFApp.theme().kSecondaryColorV2.withValues(alpha: .3),
              borderRadius: BorderRadius.circular(48.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  missionQuestion.question,
                  style: PRFText.theme().bodySmall,
                ),
                SizedBox(height: 8.h),
                Text(
                  Misc.formatDateTime(missionQuestion.createdAt),
                  style: PRFText.theme().bodySmall,
                ),
                SizedBox(height: 8.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
