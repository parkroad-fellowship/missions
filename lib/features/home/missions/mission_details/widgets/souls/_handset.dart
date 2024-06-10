import 'package:app/features/home/missions/cubit/get_souls_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
              itemBuilder: (context, index) {
                final soul = souls[index];
                return ListTile(
                  title: Text(soul.fullName),
                  subtitle: Text(soul.classGroup!.name),
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
