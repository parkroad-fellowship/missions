import 'package:app/features/missions/cubit/class_group_resource_cubit.dart';
import 'package:app/features/missions/cubit/mission_resource_cubit.dart';
import 'package:app/features/missions/cubit/mission_subscription_resource_cubit.dart';
import 'package:app/features/missions/cubit/past_mission_resource_cubit.dart';
import 'package:app/features/missions/cubit/subscribe_cubit.dart';
import 'package:app/features/missions/cubit/withdraw_cubit.dart';
import 'package:app/features/missions/mission_details/widgets/debrief_notes/cubit/debrief_note_resource_cubit.dart';
import 'package:app/features/missions/mission_details/widgets/gallery/cubit/mission_media_resource_cubit.dart';
import 'package:app/features/missions/mission_details/widgets/mission_questions/cubit/mission_question_resource_cubit.dart';
import 'package:app/features/missions/mission_details/widgets/sessions/cubit/mission_session_resource_cubit.dart';
import 'package:app/features/missions/mission_details/widgets/sessions/session/cubit/download_file_cubit.dart';
import 'package:app/features/missions/mission_details/widgets/souls/cubit/soul_resource_cubit.dart';
import 'package:app/features/missions/mission_ground_suggestions/cubit/ground_suggestion_resource_cubit.dart';
import 'package:app/services/api/class_group_service.dart';
import 'package:app/services/api/debrief_note_service.dart';
import 'package:app/services/api/mission_ground_suggestion_service.dart';
import 'package:app/services/api/mission_question_service.dart';
import 'package:app/services/api/mission_service.dart';
import 'package:app/services/api/mission_session_service.dart';
import 'package:app/services/api/mission_subscription_service.dart';
import 'package:app/services/api/soul_service.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:app/shared/media_upload/cubit/audio_recording_cubit.dart';
import 'package:app/shared/media_upload/cubit/recording_upload_cubit.dart';
import 'package:app/shared/media_upload/cubit/select_media_cubit.dart';
import 'package:app/shared/media_upload/cubit/upload_media_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

/// Feature-owned missions registrations.
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
      BlocProvider<MissionResourceCubit>(
        create: (context) => MissionResourceCubit(
          missionService: getIt(),
          hiveService: getIt<HiveService>(),
        ),
      ),
      BlocProvider<PastMissionResourceCubit>(
        create: (context) => PastMissionResourceCubit(
          missionService: getIt(),
          hiveService: getIt<HiveService>(),
        ),
      ),
      BlocProvider<MissionSubscriptionResourceCubit>(
        create: (context) => MissionSubscriptionResourceCubit(
          missionSubscriptionService: getIt(),
          hiveService: getIt<HiveService>(),
        ),
      ),
      BlocProvider<ClassGroupResourceCubit>(
        create: (context) => ClassGroupResourceCubit(
          classGroupService: getIt(),
          hiveService: getIt<HiveService>(),
        ),
      ),
      BlocProvider<SoulResourceCubit>(
        create: (context) => SoulResourceCubit(
          soulService: getIt(),
          hiveService: getIt<HiveService>(),
        ),
      ),
      BlocProvider<DebriefNoteResourceCubit>(
        create: (context) => DebriefNoteResourceCubit(
          debriefNoteService: getIt(),
          hiveService: getIt<HiveService>(),
        ),
      ),
      BlocProvider<MissionQuestionResourceCubit>(
        create: (context) => MissionQuestionResourceCubit(
          missionQuestionService: getIt(),
          hiveService: getIt<HiveService>(),
        ),
      ),
      BlocProvider<MissionSessionResourceCubit>(
        create: (context) => MissionSessionResourceCubit(
          missionSessionService: getIt(),
          hiveService: getIt<HiveService>(),
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
          hiveService: getIt<HiveService>(),
        ),
      ),
      BlocProvider<SubscribeCubit>(
        create: (context) => SubscribeCubit(
          missionSubscriptionService: getIt(),
          hiveService: getIt<HiveService>(),
        ),
      ),
      BlocProvider<WithdrawCubit>(
        create: (context) => WithdrawCubit(
          missionSubscriptionService: getIt(),
          hiveService: getIt<HiveService>(),
        ),
      ),
      BlocProvider<SelectMediaCubit>(
        create: (context) => SelectMediaCubit(
          mediaService: getIt(),
          hiveService: getIt<HiveService>(),
        ),
      ),
      BlocProvider<UploadMediaCubit>(
        create: (context) => UploadMediaCubit(
          mediaService: getIt(),
          hiveService: getIt<HiveService>(),
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
          hiveService: getIt<HiveService>(),
        ),
      ),
    ];
  }
}
