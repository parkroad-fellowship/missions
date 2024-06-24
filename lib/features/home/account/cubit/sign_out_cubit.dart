import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_out_state.dart';
part 'sign_out_cubit.freezed.dart';

class SignOutCubit extends Cubit<SignOutState> {
  SignOutCubit({
    required HiveService hiveService,
    required LocalDBService localDBService,
  }) : super(const SignOutState.initial()) {
    _hiveService = hiveService;
    _localDBService = localDBService;
  }

  late HiveService _hiveService;
  late LocalDBService _localDBService;

  Future<void> signOut() async {
    emit(const SignOutState.loading());

    try {
      await _localDBService.clearAllTables();
      _hiveService.clearPrefs();
      emit(const SignOutState.loaded());
    } catch (e) {
      emit(const SignOutState.loaded());
    }
  }
}
