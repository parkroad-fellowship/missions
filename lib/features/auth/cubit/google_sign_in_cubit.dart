import 'dart:developer';

import 'package:app/models/remote/auth.dart';
import 'package:app/services/firebase_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'google_sign_in_cubit.freezed.dart';
part 'google_sign_in_state.dart';

class GoogleSignInCubit extends Cubit<GoogleSignInState> {
  GoogleSignInCubit({required FirebaseService firebaseService})
    : super(const GoogleSignInState.initial()) {
    _firebaseService = firebaseService;
  }

  late FirebaseService _firebaseService;

  Future<void> signInwithGoogle() async {
    emit(const GoogleSignInState.loading());
    try {
      final result = await _firebaseService.signInWithGoogle();

      emit(GoogleSignInState.loaded(socialAuthDTO: result));
    } catch (e) {
      log(e.toString(), error: e);
      emit(const GoogleSignInState.error('Google Sign in failed'));
    }
  }
}
