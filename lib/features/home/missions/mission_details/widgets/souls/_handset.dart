import 'package:app/features/home/missions/cubit/get_souls_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/prf_soul.dart';
import 'package:app/services/local_db_service.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SoulsViewHandset extends StatefulWidget {
  const SoulsViewHandset({required this.missionUlid, super.key});

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

    return SingleStreamWrapper(
      stream: getIt<LocalDBService>().getSouls(missionUlid: missionUlid),
      nullWidget: Center(
        child: Text(
          l10n.noSubscribers,
          style: Theme.of(context).textTheme.headlineSmall!,
        ),
      ),
      widget:
          (context, souls) => ListView.separated(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: souls.length,
            separatorBuilder: (context, index) => SizedBox(height: 16.h),
            itemBuilder: (context, index) => SoulCard(soul: souls[index]),
          ),
    );
  }
}

class SoulCard extends StatelessWidget {
  const SoulCard({required this.soul, super.key});

  final PRFLocalSoul soul;

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
                  soul.fullName,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                SizedBox(height: 16.h),
                Text(soul.classGroup.name.toString()),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
