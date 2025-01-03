import 'dart:developer';

import 'package:app/models/remote/auth.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'google_sign_in_cubit.freezed.dart';
part 'google_sign_in_state.dart';

class GoogleSignInCubit extends Cubit<GoogleSignInState> {
  GoogleSignInCubit({
    required AuthService authService,
  }) : super(const GoogleSignInState.initial()) {
    _authService = authService;
  }

  late AuthService _authService;

  Future<void> signInwithGoogle() async {
    emit(const GoogleSignInState.loading());
    try {
      final result = await _authService.signInWithGoogle();

      if (result != null) {
        emit(GoogleSignInState.loaded(socialAuthDTO: result));
      }
    } catch (e) {
      log(e.toString(), error: e);
      emit(const GoogleSignInState.error('Google Sign in failed'));
    }
  }
}
