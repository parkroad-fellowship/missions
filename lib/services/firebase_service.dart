import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:app/firebase_options.dart';
import 'package:app/models/remote/auth.dart';
import 'package:app/models/remote/remote_config.dart';
import 'package:app/utils/misc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

abstract class FirebaseService {
  Future<SocialAuthDTO> signInWithGoogle();
  Future<void> initRemoteConfig();
  RemoteConfig getReviewConfig();
  Future<bool> canShowAuth();
}

class FirebaseServiceImpl implements FirebaseService {
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  @override
  Future<SocialAuthDTO> signInWithGoogle() async {
    try {
      // Clear any existing session
      await _auth.signOut();
      await _googleSignIn.signOut();

      await _googleSignIn.initialize(
        clientId: Platform.isAndroid
            ? DefaultFirebaseOptions.currentPlatform.androidClientId
            : null,
      );

      final googleSignInAccount = await _googleSignIn.authenticate(
        scopeHint: ['profile', 'email'],
      );

      final googleSignInAuthentication = googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
      );

      final authResult = await _auth.signInWithCredential(credential);

      final user = authResult.user;

      if (user != null) {
        assert(!user.isAnonymous, 'User must not be anonymous');

        return Future.value(
          SocialAuthDTO(
            provider: 'google',
            accessToken: googleSignInAuthentication.idToken ?? '',
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
    final config = remoteConfig.getValue('prf_missions_in_review_v2');

    return RemoteConfig.fromJson(
      json.decode(config.asString()) as Map<String, dynamic>,
    );
  }

  @override
  Future<bool> canShowAuth() async {
    final reviewConfig = getReviewConfig();
    Logger().i(reviewConfig);

    final currentVersion = Misc.getFullAppVersion();
    final currentPlatform = await _getCurrentPlatform();

    // Check if current platform and version is in review
    return reviewConfig.reviewConfigs.any(
      (config) =>
          config.isInReview &&
          config.appVersion == currentVersion &&
          (config.appStore == currentPlatform),
    );
  }

  Future<String> _getCurrentPlatform() async {
    if (Platform.isIOS) {
      return 'ios';
    } else if (Platform.isAndroid) {
      // Check if this is a Huawei device without Google Play Services
      return await _isHuaweiDevice() ? 'huawei' : 'android';
    }
    return 'unknown';
  }

  Future<bool> _isHuaweiDevice() async {
    try {
      if (Platform.isAndroid) {
        return _checkHuaweiManufacturer();
      }
      return false;
    } catch (e) {
      Logger().e('Error checking Huawei device: $e');
      return false;
    }
  }

  Future<bool> _checkHuaweiManufacturer() async {
    try {
      // This is a synchronous check that should work in most cases
      // You can also make this async if needed
      final androidInfo = _deviceInfo.androidInfo;

      // Check common Huawei identifiers
      return await androidInfo
          .then((info) {
            final manufacturer = info.manufacturer.toLowerCase();
            final brand = info.brand.toLowerCase();

            return manufacturer.contains('huawei') ||
                manufacturer.contains('honor') ||
                brand.contains('huawei') ||
                brand.contains('honor');
          })
          .catchError((Object e) {
            Logger().e('Error getting Android info: $e');
            return false;
          });
    } catch (e) {
      return false;
    }
  }
}
