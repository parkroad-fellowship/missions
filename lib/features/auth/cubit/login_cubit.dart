import 'package:app/models/auth.dart';
import 'package:app/models/failure.dart';
import 'package:app/services/_index.dart';
import 'package:app/services/auth_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.dart';
part 'login_cubit.freezed.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required AuthService authService,
    required HiveService hiveService,
  }) : super(const LoginState.initial()) {
    _authService = authService;
    _hiveService = hiveService;
  }
  late HiveService _hiveService;
  late AuthService _authService;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(const LoginState.loading());
    try {
      final token = await _authService.signIn(
        signInDTO: SignInDTO(
          email: email,
          password: password,
        ),
      );

      _hiveService.persistToken(token);

      final user = await _authService.getUser();

      _hiveService.persistProfile(user);

      emit(const LoginState.loaded());
    } on Failure catch (e) {
      emit(LoginState.error(e.message));
    } catch (e) {
      emit(const LoginState.error('An unknown error occurred'));
    }
  }
}
