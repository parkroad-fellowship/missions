import 'package:app/features/home/mission_ground_suggestions/cubit/add_mission_ground_suggestion_cubit.dart';
import 'package:app/features/home/mission_ground_suggestions/cubit/get_mission_ground_suggestions_cubit.dart';
import 'package:app/features/home/mission_ground_suggestions/cubit/update_mission_ground_suggestion_cubit.dart';
import 'package:app/features/home/missions/cubit/audio_recording_cubit.dart';
import 'package:app/features/home/missions/cubit/get_class_groups_cubit.dart';
import 'package:app/features/home/missions/cubit/get_member_mission_subscriptions_cubit.dart';
import 'package:app/features/home/missions/cubit/get_mission_cubit.dart';
import 'package:app/features/home/missions/cubit/get_missions_cubit.dart';
import 'package:app/features/home/missions/cubit/get_subscribers_cubit.dart';
import 'package:app/features/home/missions/cubit/recording_upload_cubit.dart';
import 'package:app/features/home/missions/cubit/subscribe_cubit.dart';
import 'package:app/features/home/missions/cubit/withdraw_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/debrief_notes/cubit/add_debrief_note_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/debrief_notes/cubit/get_debrief_notes_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/gallery/cubit/get_mission_media_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/gallery/cubit/select_media_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/gallery/cubit/upload_media_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/mission_questions/cubit/add_mission_question_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/mission_questions/cubit/get_mission_questions_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/sessions/cubit/add_mission_session_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/sessions/cubit/delete_mission_session_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/sessions/cubit/get_mission_sessions_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/sessions/cubit/update_mission_session_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/sessions/session/cubit/download_file_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/sessions/session/cubit/get_mission_session_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/souls/cubit/add_soul_cubit.dart';
import 'package:app/features/home/missions/mission_details/widgets/souls/cubit/get_souls_cubit.dart';
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
      BlocProvider<GetMissionsCubit>(
        create: (context) => GetMissionsCubit(
          missionService: getIt(),
          isarService: getIt(),
        ),
      ),
      BlocProvider<GetMissionCubit>(
        create: (context) => GetMissionCubit(
          missionService: getIt(),
          isarService: getIt(),
        ),
      ),
      BlocProvider<GetSubscribersCubit>(
        create: (context) => GetSubscribersCubit(
          missionSubscriptionService: getIt(),
          isarService: getIt(),
        ),
      ),
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
      BlocProvider<GetSoulsCubit>(
        create: (context) => GetSoulsCubit(
          soulService: getIt(),
          isarService: getIt(),
        ),
      ),
      BlocProvider<GetClassGroupsCubit>(
        create: (context) => GetClassGroupsCubit(
          classGroupService: getIt(),
          hiveService: getIt(),
          isarService: getIt(),
        ),
      ),
      BlocProvider<AddSoulCubit>(
        create: (context) => AddSoulCubit(
          soulService: getIt(),
          isarService: getIt(),
        ),
      ),
      BlocProvider<GetDebriefNotesCubit>(
        create: (context) => GetDebriefNotesCubit(
          debriefNoteService: getIt(),
          isarService: getIt(),
        ),
      ),
      BlocProvider<AddDebriefNoteCubit>(
        create: (context) => AddDebriefNoteCubit(
          debriefNoteService: getIt(),
          isarService: getIt(),
        ),
      ),
      BlocProvider<GetMissionQuestionsCubit>(
        create: (context) => GetMissionQuestionsCubit(
          missionQuestionService: getIt(),
          isarService: getIt(),
        ),
      ),
      BlocProvider<AddMissionQuestionCubit>(
        create: (context) => AddMissionQuestionCubit(
          missionQuestionService: getIt(),
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
      BlocProvider<GetMissionMediaCubit>(
        create: (context) => GetMissionMediaCubit(missionService: getIt()),
      ),
      BlocProvider<GetMissionSessionsCubit>(
        create: (context) => GetMissionSessionsCubit(
          missionSessionService: getIt(),
          isarService: getIt(),
        ),
      ),
      BlocProvider<AddMissionSessionCubit>(
        create: (context) => AddMissionSessionCubit(
          missionSessionService: getIt(),
          isarService: getIt(),
        ),
      ),
      BlocProvider<UpdateMissionSessionCubit>(
        create: (context) => UpdateMissionSessionCubit(
          missionSessionService: getIt(),
          isarService: getIt(),
        ),
      ),
      BlocProvider<DeleteMissionSessionCubit>(
        create: (context) => DeleteMissionSessionCubit(
          missionSessionService: getIt(),
          isarService: getIt(),
        ),
      ),
      BlocProvider<GetMissionGroundSuggestionsCubit>(
        create: (context) => GetMissionGroundSuggestionsCubit(
          missionGroundSuggestionService: getIt(),
          hiveService: getIt(),
        ),
      ),
      BlocProvider<AddMissionGroundSuggestionCubit>(
        create: (context) => AddMissionGroundSuggestionCubit(
          missionGroundSuggestionService: getIt(),
          hiveService: getIt(),
        ),
      ),
      BlocProvider<UpdateMissionGroundSuggestionCubit>(
        create: (context) => UpdateMissionGroundSuggestionCubit(
          missionGroundSuggestionService: getIt(),
          hiveService: getIt(),
        ),
      ),
      BlocProvider<GetMissionSessionCubit>(
        create: (context) => GetMissionSessionCubit(
          missionSessionService: getIt(),
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
