import 'package:app/features/home/shared/cubit/member_engagement_resource_cubit.dart';
import 'package:app/services/api/member_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

/// Feature-owned registrations for member engagement.
class MembersModule {
  static void register(GetIt getIt) {
    getIt.registerSingleton<MemberService>(MemberService());
  }

  static List<BlocProvider> registerCubits(GetIt getIt) {
    return [
      BlocProvider<MemberEngagementResourceCubit>(
        create: (context) => MemberEngagementResourceCubit(
          memberService: getIt(),
          hiveService: getIt(),
        ),
      ),
    ];
  }
}
