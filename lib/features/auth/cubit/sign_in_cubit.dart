import 'package:app/models/remote/auth.dart';
import 'package:app/models/remote/failure.dart';
import 'package:app/models/remote/socket_config.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_in_state.dart';
part 'sign_in_cubit.freezed.dart';

class SigninCubit extends Cubit<SignInState> {
  SigninCubit({
    required AuthService authService,
    required HiveService hiveService,
    required SocketService socketService,
    required AnalyticsService analyticsService,
  }) : super(const SignInState.initial()) {
    _authService = authService;
    _hiveService = hiveService;
    _socketService = socketService;
    _analyticsService = analyticsService;
  }
  late HiveService _hiveService;
  late AuthService _authService;
  late SocketService _socketService;
  late AnalyticsService _analyticsService;

  Future<void> signIn({required String email, required String password}) async {
    emit(const SignInState.loading());
    try {
      final token = await _authService.signIn(
        signInDTO: SignInDTO(email: email, password: password),
      );

      _hiveService.auth.persistToken(token);

      final user = await _authService.getUser();

      _hiveService.auth.persistProfile(user);

      await _socketService.init(
        socketConfig: SocketConfig(
          privateChannels: _socketService.defaultConfig().privateChannels,
          presenceChannels: _socketService.defaultConfig().presenceChannels,
        ),
      );

      await _analyticsService.identifyUser(user: user);

      emit(const SignInState.loaded());
    } on Failure catch (e) {
      emit(SignInState.error(e.message));
    } catch (e) {
      emit(const SignInState.error('An unknown error occurred'));
    }
  }
}
