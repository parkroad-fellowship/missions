import 'package:app/models/auth.dart';
import 'package:app/models/failure.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_in_state.dart';
part 'sign_in_cubit.freezed.dart';

class SigninCubit extends Cubit<SignInState> {
  SigninCubit({
    required AuthService authService,
    required HiveService hiveService,
  }) : super(const SignInState.initial()) {
    _authService = authService;
    _hiveService = hiveService;
  }
  late HiveService _hiveService;
  late AuthService _authService;

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(const SignInState.loading());
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

      emit(const SignInState.loaded());
    } on Failure catch (e) {
      emit(SignInState.error(e.message));
    } catch (e) {
      emit(const SignInState.error('An unknown error occurred'));
    }
  }
}
