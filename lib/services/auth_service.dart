import 'dart:convert';
import 'dart:developer';

import 'package:app/models/remote/auth.dart';
import 'package:app/utils/_index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthService {
  Future<String> signIn({required SignInDTO signInDTO});
  Future<SocialAuthDTO?> signInWithGoogle();
  Future<String> socialLogin({required SocialAuthDTO socialAuthDTO});
  Future<PRFUser> registerStudent();
  Future<PRFUser> getUser();
}

class AuthServiceImpl implements AuthService {
  final _networkUtil = NetworkUtil();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);

  @override
  Future<String> signIn({required SignInDTO signInDTO}) async {
    try {
      final response = await _networkUtil.postReq(
        '/auth/login',
        body: json.encode(signInDTO.toJson()),
      );

      return response['token'] as String;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PRFUser> getUser() async {
    try {
      final response = await _networkUtil.getReq(
        '/auth/me',
        queryParameters: <String, dynamic>{
          'include':
              'roles.permissions,member.groupMembers.group,student,'
              'member.memberships.spiritualYear',
        },
      );

      return PRFUser.fromJson(response['data'] as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PRFUser> registerStudent() async {
    try {
      final response = await _networkUtil.postReq('/auth/register-student');

      return PRFUser.fromJson(response['data'] as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

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
  Future<String> socialLogin({required SocialAuthDTO socialAuthDTO}) async {
    try {
      final response = await _networkUtil.postReq(
        '/auth/social-login',
        body: json.encode(socialAuthDTO.toJson()),
      );

      return response['token'] as String;
    } catch (e) {
      rethrow;
    }
  }
}
