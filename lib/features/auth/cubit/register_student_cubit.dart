import 'package:app/models/remote/auth.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_student_state.dart';
part 'register_student_cubit.freezed.dart';

class RegisterStudentCubit extends Cubit<RegisterStudentState> {
  RegisterStudentCubit({
    required AuthService authService,
    required HiveService hiveService,
  }) : super(const RegisterStudentState.initial()) {
    _authService = authService;
    _hiveService = hiveService;
  }

  late AuthService _authService;
  late HiveService _hiveService;

  Future<void> registerStudent() async {
    emit(const RegisterStudentState.loading());
    try {
      final user = await _authService.registerStudent();

      _hiveService
        ..persistToken(user.token!)
        ..persistProfile(user)
        ..persistStudentCredentials(email: user.email, password: user.password);

      emit(RegisterStudentState.loaded(user: user));
    } catch (e) {
      emit(RegisterStudentState.error(e.toString()));
    }
  }
}
