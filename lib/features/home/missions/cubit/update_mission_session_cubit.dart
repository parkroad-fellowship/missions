import 'package:app/models/remote/prf_mission_session.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_mission_session_state.dart';
part 'update_mission_session_cubit.freezed.dart';

class UpdateMissionSessionCubit extends Cubit<UpdateMissionSessionState> {
  UpdateMissionSessionCubit() : super(UpdateMissionSessionState.initial());
}
