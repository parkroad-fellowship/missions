import 'package:app/features/home/missions/cubit/get_mission_questions_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MissionQuestionsViewHandset extends StatefulWidget {
  const MissionQuestionsViewHandset({
    required this.missionUlid,
    super.key,
  });

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
    context
        .read<GetMissionQuestionsCubit>()
        .getMissionQuestions(missionUlid: missionUlid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<GetMissionQuestionsCubit, GetMissionQuestionsState>(
      builder: (context, state) {
        return state.maybeWhen(
          orElse: () => const Center(child: CircularProgressIndicator()),
          loaded: (missionQuestions) {
            if (missionQuestions.isEmpty) {
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
              itemCount: missionQuestions.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final missionQuestion = missionQuestions[index];
                return ListTile(
                  title: Text(missionQuestion.question),
                  subtitle:
                      Text(Misc.formatDateTime(missionQuestion.createdAt)),
                  onTap: () {},
                );
              },
            );
          },
        );
      },
    );
  }
}
