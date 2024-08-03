import 'package:app/features/home/missions/cubit/get_souls_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/prf_soul.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SoulsViewHandset extends StatefulWidget {
  const SoulsViewHandset({
    required this.missionUlid,
    super.key,
  });

  final String missionUlid;

  @override
  State<SoulsViewHandset> createState() => _SoulsViewHandsetState();
}

class _SoulsViewHandsetState extends State<SoulsViewHandset> {
  String get missionUlid => widget.missionUlid;

  @override
  void initState() {
    context.read<GetSoulsCubit>().getSouls(missionUlid: missionUlid);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<GetSoulsCubit, GetSoulsState>(
      builder: (context, state) {
        return state.maybeWhen(
          orElse: () => const Center(child: CircularProgressIndicator()),
          loaded: (souls) {
            if (souls.isEmpty) {
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
              itemCount: souls.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) => SoulCard(soul: souls[index]),
            );
          },
        );
      },
    );
  }
}

class SoulCard extends StatelessWidget {
  const SoulCard({
    required this.soul,
    super.key,
  });

  final PRFSoul soul;

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  soul.fullName,
                  style:
                      CustomTextTheme.customTextTheme().displayLarge?.copyWith(
                            color: AppTheme.appTheme().kPrimaryColorV2,
                            fontWeight: FontWeight.w600,
                          ),
                ),
                SizedBox(height: 16.h),
                Text(soul.classGroup!.name),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
