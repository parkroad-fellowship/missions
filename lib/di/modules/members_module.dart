import 'package:app/features/home/shared/cubit/get_member_engagement_cubit.dart';
import 'package:app/services/api/member_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

/// Members module for registering member-related services and cubits.
class MembersModule {
  static void register(GetIt getIt) {
    getIt.registerSingleton<MemberService>(MemberService());
  }

  static List<BlocProvider> registerCubits(GetIt getIt) {
    return [
      BlocProvider<GetMemberEngagementCubit>(
        create: (context) => GetMemberEngagementCubit(
          memberService: getIt(),
          hiveService: getIt(),
        ),
      ),
    ];
  }
}
