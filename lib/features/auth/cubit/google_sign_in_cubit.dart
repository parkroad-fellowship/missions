import 'dart:developer';

import 'package:app/models/remote/common/auth.dart';
import 'package:app/services/errors/_error_reporting_service.dart';
import 'package:app/services/firebase/firebase_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'google_sign_in_cubit.freezed.dart';
part 'google_sign_in_state.dart';

class GoogleSignInCubit extends Cubit<GoogleSignInState> {
  GoogleSignInCubit({
    required PRFFirebaseService firebaseService,
    required ErrorReportingService errorReportingService,
  }) : super(const GoogleSignInState.initial()) {
    _firebaseService = firebaseService;
    _errorReportingService = errorReportingService;
  }

  late PRFFirebaseService _firebaseService;
  late ErrorReportingService _errorReportingService;

  Future<void> signInwithGoogle() async {
    emit(const GoogleSignInState.loading());
    try {
      final result = await _firebaseService.signInWithGoogle();

      emit(GoogleSignInState.loaded(socialAuthDTO: result));
    } catch (e) {
      await _errorReportingService.recordError(e, StackTrace.current);
      log(e.toString(), error: e);
      emit(const GoogleSignInState.error('Google Sign in failed'));
    }
  }
}
