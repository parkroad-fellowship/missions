import 'package:app/features/home/mission_ground_suggestions/cubit/ground_suggestion_resource_cubit.dart';
import 'package:app/features/home/missions/cubit/audio_recording_cubit.dart';
import 'package:app/features/home/missions/cubit/class_group_resource_cubit.dart';
import 'package:app/features/home/missions/cubit/get_member_mission_subscriptions_cubit.dart';
import 'package:app/features/home/missions/cubit/mission_resource_cubit.dart';
import 'package:app/features/home/missions/cubit/past_mission_resource_cubit.dart';
import 'package:app/features/home/missions/cubit/mission_subscription_resource_cubit.dart';
import 'package:app/features/home/missions/cubit/recording_upload_cubit.dart';
import 'package:app/features/home/missions/cubit/subscribe_cubit.dart';
import 'package:app/features/home/missions/cubit/withdraw_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/debrief_notes/cubit/debrief_note_resource_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/gallery/cubit/mission_media_resource_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/gallery/cubit/select_media_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/gallery/cubit/upload_media_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/mission_questions/cubit/mission_question_resource_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/sessions/cubit/mission_session_resource_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/sessions/session/cubit/download_file_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/souls/cubit/soul_resource_cubit.dart';
import 'package:app/services/api/class_group_service.dart';
import 'package:app/services/api/debrief_note_service.dart';
import 'package:app/services/api/mission_ground_suggestion_service.dart';
import 'package:app/services/api/mission_question_service.dart';
import 'package:app/services/api/mission_service.dart';
import 'package:app/services/api/mission_session_service.dart';
import 'package:app/services/api/mission_subscription_service.dart';
import 'package:app/services/api/soul_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

/// Missions module for registering mission-related services and cubits.
///
/// Includes:
/// - Mission services (missions, sessions, subscriptions, questions)
/// - Debrief notes
/// - Soul tracking
/// - Class groups
/// - Mission ground suggestions
class MissionsModule {
  static void register(GetIt getIt) {
    getIt
      ..registerSingleton<MissionService>(MissionService())
      ..registerSingleton<MissionSubscriptionService>(
        MissionSubscriptionService(),
      )
      ..registerSingleton<MissionSessionService>(MissionSessionService())
      ..registerSingleton<MissionQuestionService>(MissionQuestionService())
      ..registerSingleton<DebriefNoteService>(DebriefNoteService())
      ..registerSingleton<MissionGroundSuggestionService>(
        MissionGroundSuggestionService(),
      )
      ..registerSingleton<ClassGroupService>(ClassGroupService())
      ..registerSingleton<SoulService>(SoulService());
  }

  static List<BlocProvider> registerCubits(GetIt getIt) {
    return [
      // --- ResourceCubit replacements ---
      BlocProvider<MissionResourceCubit>(
        create: (context) => MissionResourceCubit(
          missionService: getIt(),
        ),
      ),
      BlocProvider<PastMissionResourceCubit>(
        create: (context) => PastMissionResourceCubit(
          missionService: getIt(),
        ),
      ),
      BlocProvider<MissionSubscriptionResourceCubit>(
        create: (context) => MissionSubscriptionResourceCubit(
          missionSubscriptionService: getIt(),
        ),
      ),
      BlocProvider<ClassGroupResourceCubit>(
        create: (context) => ClassGroupResourceCubit(
          classGroupService: getIt(),
        ),
      ),
      BlocProvider<SoulResourceCubit>(
        create: (context) => SoulResourceCubit(
          soulService: getIt(),
        ),
      ),
      BlocProvider<DebriefNoteResourceCubit>(
        create: (context) => DebriefNoteResourceCubit(
          debriefNoteService: getIt(),
        ),
      ),
      BlocProvider<MissionQuestionResourceCubit>(
        create: (context) => MissionQuestionResourceCubit(
          missionQuestionService: getIt(),
        ),
      ),
      BlocProvider<MissionSessionResourceCubit>(
        create: (context) => MissionSessionResourceCubit(
          missionSessionService: getIt(),
        ),
      ),
      BlocProvider<MissionMediaResourceCubit>(
        create: (context) => MissionMediaResourceCubit(
          missionService: getIt(),
        ),
      ),
      BlocProvider<GroundSuggestionResourceCubit>(
        create: (context) => GroundSuggestionResourceCubit(
          missionGroundSuggestionService: getIt(),
        ),
      ),

      // --- Keep-as-is cubits (special logic) ---
      BlocProvider<SubscribeCubit>(
        create: (context) => SubscribeCubit(
          missionSubscriptionService: getIt(),
          hiveService: getIt(),
          isarService: getIt(),
        ),
      ),
      BlocProvider<WithdrawCubit>(
        create: (context) => WithdrawCubit(
          missionSubscriptionService: getIt(),
          hiveService: getIt(),
        ),
      ),
      BlocProvider<GetMemberMissionSubscriptionsCubit>(
        create: (context) => GetMemberMissionSubscriptionsCubit(
          missionSubscriptionService: getIt(),
          hiveService: getIt(),
          isarService: getIt(),
        ),
      ),
      BlocProvider<SelectMediaCubit>(
        create: (context) => SelectMediaCubit(
          mediaService: getIt(),
          isarService: getIt(),
        ),
      ),
      BlocProvider<UploadMediaCubit>(
        create: (context) => UploadMediaCubit(
          mediaService: getIt(),
          isarService: getIt(),
        ),
      ),
      BlocProvider<DownloadFileCubit>(
        create: (context) => DownloadFileCubit(mediaService: getIt()),
      ),
      BlocProvider<AudioRecordingCubit>(
        create: (context) => AudioRecordingCubit(recordingService: getIt()),
      ),
      BlocProvider<RecordingUploadCubit>(
        create: (context) => RecordingUploadCubit(
          mediaService: getIt(),
          failedUploadService: getIt(),
        ),
      ),
    ];
  }
}
