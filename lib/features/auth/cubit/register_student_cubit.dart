import 'package:app/models/remote/auth.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_student_state.dart';
part 'register_student_cubit.freezed.dart';

class RegisterStudentCubit extends Cubit<RegisterStudentState> {
  RegisterStudentCubit({
    required AuthService authService,
  }) : super(const RegisterStudentState.initial()) {
    _authService = authService;
  }

  late AuthService _authService;

  Future<void> registerStudent() async {
    emit(const RegisterStudentState.loading());
    try {
      final user = await _authService.registerStudent();
      emit(RegisterStudentState.loaded(user: user));
    } catch (e) {
      emit(RegisterStudentState.error(e.toString()));
    }
  }
}
