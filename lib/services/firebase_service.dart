import 'dart:convert';
import 'dart:developer';

import 'package:app/models/remote/auth.dart';
import 'package:app/models/remote/remote_config.dart';
import 'package:app/utils/misc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

abstract class FirebaseService {
  Future<SocialAuthDTO> signInWithGoogle();
  Future<void> initRemoteConfig();
  RemoteConfig getReviewConfig();
  bool canShowAuth();
}

class FirebaseServiceImpl implements FirebaseService {
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);

  @override
  Future<SocialAuthDTO> signInWithGoogle() async {
    try {
      // Clear any existing session
      await _auth.signOut();
      await _googleSignIn.signOut();

      final googleSignInAccount = await _googleSignIn.signIn();
      final googleSignInAuthentication =
          await googleSignInAccount?.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication?.idToken,
        accessToken: googleSignInAuthentication?.accessToken,
      );

      final authResult = await _auth.signInWithCredential(credential);

      final user = authResult.user;

      if (user != null) {
        assert(!user.isAnonymous, 'User must not be anonymous');

        return Future.value(
          SocialAuthDTO(
            provider: 'google',
            accessToken: googleSignInAuthentication?.accessToken ?? '',
          ),
        );
      } else {
        return throw Exception('An error occured');
      }
    } catch (e) {
      log(e.toString(), error: e);
      rethrow;
    }
  }

  @override
  Future<void> initRemoteConfig() async {
    await remoteConfig.fetchAndActivate();
  }

  @override
  RemoteConfig getReviewConfig() {
    final config = remoteConfig.getValue('prf_missions_in_review');

    return RemoteConfig.fromJson(
      json.decode(config.asString()) as Map<String, dynamic>,
    );
  }

  @override
  bool canShowAuth() {
    final reviewConfig = getReviewConfig();
    Logger().i(reviewConfig);
    return reviewConfig.isInReview &&
        reviewConfig.appVersion == Misc.getFullAppVersion();
  }
}
