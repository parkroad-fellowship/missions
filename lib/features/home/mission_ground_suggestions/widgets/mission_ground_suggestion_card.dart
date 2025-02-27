import 'package:app/models/remote/prf_mission_ground_suggestion.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MissionGroundSuggestionCard extends StatelessWidget {
  const MissionGroundSuggestionCard({
    required this.missionGroundSuggestion,
    super.key,
  });

  final PRFMissionGroundSuggestion missionGroundSuggestion;

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
              color: Theme.of(
                context,
              ).colorScheme.secondary.withValues(alpha: .3),
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
                          text: missionGroundSuggestion.name,
                          style: Theme.of(context).textTheme.bodyLarge,
                          children: [
                            TextSpan(
                              text: ', ${missionGroundSuggestion.status.name}',
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        missionGroundSuggestion.contactPerson,
                        style: Theme.of(context).textTheme.bodySmall,
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
                  child: Visibility(
                    visible: Misc.userCan('viewAny mission ground suggestion'),
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
                            path: missionGroundSuggestion.contactNumber,
                          );
                          await Misc.openUrl(uri);
                        },
                      ),
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
