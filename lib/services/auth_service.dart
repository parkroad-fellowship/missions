import 'dart:convert';

import 'package:app/models/remote/auth.dart';
import 'package:app/utils/_index.dart';

abstract class AuthService {
  Future<String> signIn({required SignInDTO signInDTO});
  Future<PRFUser> getUser();
}

class AuthServiceImpl implements AuthService {
  final _networkUtil = NetworkUtil();

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
          'include': 'roles.permissions,member',
        },
      );

      return PRFUser.fromJson(response['data'] as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }
}
