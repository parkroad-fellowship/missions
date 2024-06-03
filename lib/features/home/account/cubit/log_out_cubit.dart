import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'log_out_state.dart';
part 'log_out_cubit.freezed.dart';

class LogOutCubit extends Cubit<LogOutState> {
  LogOutCubit({
    required HiveService hiveService,
  }) : super(const LogOutState.initial()) {
    _hiveService = hiveService;
  }

  late HiveService _hiveService;

  Future<void> logOut() async {
    emit(const LogOutState.loading());

    try {
      _hiveService.clearPrefs();
      emit(const LogOutState.loaded());
    } catch (e) {
      emit(const LogOutState.loaded());
    }
  }
}
