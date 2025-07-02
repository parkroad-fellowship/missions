import 'dart:async';
import 'dart:io';

import 'package:app/models/remote/failure.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class NetworkUtil {
  factory NetworkUtil() => _networkUtil;

  NetworkUtil._internal();

  static final NetworkUtil _networkUtil = NetworkUtil._internal();

  final _logger = Logger();

  Dio _getHttpClient({required String apiVersion}) {
    final dio = Dio(
      BaseOptions(
        baseUrl:
            '${PRFSuperAppConfig.instance!.values.baseUrl}/api/$apiVersion',
        contentType: 'application/json',
        headers: <String, dynamic>{
          'Accept': 'application/json',
          'X-App-Version': Misc.getFullAppVersion(),
        },
        connectTimeout: const Duration(seconds: 60 * 1000),
        receiveTimeout: const Duration(seconds: 60 * 1000),
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          options.headers['Authorization'] =
              'Bearer ${getIt<HiveService>().retrieveToken() ?? ''}';
          return handler.next(options);
        },
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(requestHeader: true, requestBody: true),
      );
    }

    (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () =>
        HttpClient()..badCertificateCallback = (_, _, _) => true;
    return dio;
  }

  Future<Map<String, dynamic>> getReq(
    String url, {
    String apiVersion = 'v1',
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response =
          await _getHttpClient(
            apiVersion: apiVersion,
          ).get<dynamic>(
            url,
            queryParameters: queryParameters,
          );

      final responseBody = response.data as Map<String, dynamic>;

      if (responseBody.isEmpty) {
        throw Failure(message: 'An error occurred, please try again later');
      }

      return responseBody;
    } on SocketException catch (_) {
      throw Failure(message: 'No internet connection');
    } on TimeoutException catch (_) {
      throw Failure(message: 'Session timeout');
    } on DioException catch (err) {
      _logger
        ..d('Error: $err')
        ..i('${err.response?.statusCode}')
        ..i('Error: ${err.response?.data}');

      if (err.response?.statusCode == 401) {
        throw Failure(message: 'Session timeout');
      }

      if (err.response?.statusCode == 404) {
        throw Failure(
          message: 'Not found',
          statusCode: err.response?.statusCode,
        );
      }

      if (err.response?.statusCode == 500) {
        throw Failure(
          // ignore: avoid_dynamic_calls
          message: err.response?.data['message'] as String,
          statusCode: err.response?.statusCode,
        );
      }

      if (DioExceptionType.unknown == err.type) {
        _logger
          ..d('Error: $err')
          ..i('${err.response?.statusCode}')
          ..i('Error: ${err.response?.data}');
        throw Exception('Server error');
      } else if (DioExceptionType.connectionTimeout == err.type) {
        throw const SocketException('No internet connection');
      } else if (DioExceptionType.connectionError == err.type) {
        throw const SocketException('No Internet Connection');
      }
      throw Exception('Server error');
    }
  }

  Future<Map<String, dynamic>> postReq(
    String url, {
    String? body,
    String apiVersion = 'v1',
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response =
          await _getHttpClient(
            apiVersion: apiVersion,
          ).post<dynamic>(
            url,
            data: body,
            queryParameters: queryParameters,
          );

      final responseBody = response.data as Map<String, dynamic>;

      Logger().i(responseBody);

      if (responseBody.isEmpty) {
        throw Failure(message: 'An error occured, please try again later');
      }

      return responseBody;
    } on SocketException catch (_) {
      throw Failure(message: 'No internet connection');
    } on TimeoutException catch (_) {
      throw Failure(message: 'Session timeout');
    } on DioException catch (err) {
      _logger
        ..d('Error: $err')
        ..i('${err.response?.statusCode}')
        ..i('Error: ${err.response?.data}');

      if (err.response?.statusCode == 401) {
        throw Failure(
          message: 'Session timeout',
          statusCode: err.response?.statusCode,
        );
      }

      if (err.response?.statusCode == 404) {
        throw Failure(
          message: 'Not found',
          statusCode: err.response?.statusCode,
        );
      }

      if (err.response?.statusCode == 422) {
        throw Failure(
          // ignore: avoid_dynamic_calls
          message: err.response?.data['message'] as String,
          statusCode: err.response?.statusCode,
        );
      }

      if (err.response?.statusCode == 500) {
        throw Failure(
          // ignore: avoid_dynamic_calls
          message: err.response?.data['message'] as String,
          statusCode: err.response?.statusCode,
        );
      }

      if (DioExceptionType.unknown == err.type) {
        _logger
          ..d('Error: $err')
          ..i('${err.response?.statusCode}')
          ..i('Error: ${err.response?.data}');
        throw Exception('Server error');
      } else if (DioExceptionType.connectionTimeout == err.type) {
        throw const SocketException('No internet connection');
      } else if (DioExceptionType.connectionError == err.type) {
        throw const SocketException('No Internet Connection');
      }
      throw Exception('Server error');
    }
  }

  Future<Map<String, dynamic>> putReq(
    String url, {
    String? body,
    String apiVersion = 'v1',
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response =
          await _getHttpClient(
            apiVersion: apiVersion,
          ).put<dynamic>(
            url,
            data: body,
            queryParameters: queryParameters,
          );

      final responseBody = response.data as Map<String, dynamic>;

      Logger().i(responseBody);

      if (responseBody.isEmpty) {
        throw Failure(message: 'An error occured, please try again later');
      }

      return responseBody;
    } on SocketException catch (_) {
      throw Failure(message: 'No internet connection');
    } on TimeoutException catch (_) {
      throw Failure(message: 'Session timeout');
    } on DioException catch (err) {
      _logger
        ..d('Error: $err')
        ..i('${err.response?.statusCode}')
        ..i('Error: ${err.response?.data}');

      if (err.response?.statusCode == 401) {
        throw Failure(
          message: 'Session timeout',
          statusCode: err.response?.statusCode,
        );
      }

      if (err.response?.statusCode == 404) {
        throw Failure(
          message: 'Not found',
          statusCode: err.response?.statusCode,
        );
      }

      if (err.response?.statusCode == 422) {
        throw Failure(
          // ignore: avoid_dynamic_calls
          message: err.response?.data['message'] as String,
          statusCode: err.response?.statusCode,
        );
      }

      if (err.response?.statusCode == 500) {
        throw Failure(
          // ignore: avoid_dynamic_calls
          message: err.response?.data['message'] as String,
          statusCode: err.response?.statusCode,
        );
      }

      if (DioExceptionType.unknown == err.type) {
        _logger
          ..d('Error: $err')
          ..i('${err.response?.statusCode}')
          ..i('Error: ${err.response?.data}');
        throw Exception('Server error');
      } else if (DioExceptionType.connectionTimeout == err.type) {
        throw const SocketException('No internet connection');
      } else if (DioExceptionType.connectionError == err.type) {
        throw const SocketException('No Internet Connection');
      }
      throw Exception('Server error');
    }
  }

  Future<void> deleteReq(
    String url, {
    String apiVersion = 'v1',
  }) async {
    try {
      await _getHttpClient(apiVersion: apiVersion).delete<dynamic>(url);
    } on SocketException catch (_) {
      throw Failure(message: 'No internet connection');
    } on TimeoutException catch (_) {
      throw Failure(message: 'Session timeout');
    } on DioException catch (err) {
      _logger
        ..d('Error: $err')
        ..i('${err.response?.statusCode}')
        ..i('Error: ${err.response?.data}');

      if (err.response?.statusCode == 401) {
        throw Failure(
          message: 'Session timeout',
          statusCode: err.response?.statusCode,
        );
      }

      if (err.response?.statusCode == 404) {
        throw Failure(
          message: 'Not found',
          statusCode: err.response?.statusCode,
        );
      }

      if (err.response?.statusCode == 422) {
        throw Failure(
          // ignore: avoid_dynamic_calls
          message: err.response?.data['message'] as String,
          statusCode: err.response?.statusCode,
        );
      }

      if (err.response?.statusCode == 500) {
        throw Failure(
          // ignore: avoid_dynamic_calls
          message: err.response?.data['message'] as String,
          statusCode: err.response?.statusCode,
        );
      }

      if (DioExceptionType.unknown == err.type) {
        _logger
          ..d('Error: $err')
          ..i('${err.response?.statusCode}')
          ..i('Error: ${err.response?.data}');
        throw Exception('Server error');
      } else if (DioExceptionType.connectionTimeout == err.type) {
        throw const SocketException('No internet connection');
      } else if (DioExceptionType.connectionError == err.type) {
        throw const SocketException('No Internet Connection');
      }
      throw Exception('Server error');
    }
  }

  Future<Map<String, dynamic>> postWithUpload(
    String url, {
    required String filePath,
    required String field,
    String apiVersion = 'v1',
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response =
          await _getHttpClient(
            apiVersion: apiVersion,
          ).post<dynamic>(
            url,
            data: FormData.fromMap(<String, dynamic>{
              field: await MultipartFile.fromFile(filePath),
              ...?body,
            }),
            queryParameters: queryParameters,
          );

      final responseBody = response.data as Map<String, dynamic>;

      Logger().i(responseBody);

      if (responseBody.isEmpty) {
        throw Failure(message: 'An error occured, please try again later');
      }

      return responseBody;
    } on SocketException catch (_) {
      throw Failure(message: 'No internet connection');
    } on TimeoutException catch (_) {
      throw Failure(message: 'Session timeout');
    } on DioException catch (err) {
      _logger
        ..d('Error: $err')
        ..i('${err.response?.statusCode}')
        ..i('Error: ${err.response?.data}');

      if (err.response?.statusCode == 401) {
        throw Failure(
          message: 'Session timeout',
          statusCode: err.response?.statusCode,
        );
      }

      if (err.response?.statusCode == 404) {
        throw Failure(
          message: 'Not found',
          statusCode: err.response?.statusCode,
        );
      }

      if (err.response?.statusCode == 422) {
        throw Failure(
          // ignore: avoid_dynamic_calls
          message: err.response?.data['message'] as String,
          statusCode: err.response?.statusCode,
        );
      }

      if (err.response?.statusCode == 500) {
        throw Failure(
          // ignore: avoid_dynamic_calls
          message: err.response?.data['message'] as String,
          statusCode: err.response?.statusCode,
        );
      }

      if (DioExceptionType.unknown == err.type) {
        _logger
          ..d('Error: $err')
          ..i('${err.response?.statusCode}')
          ..i('Error: ${err.response?.data}');
        throw Exception('Server error');
      } else if (DioExceptionType.connectionTimeout == err.type) {
        throw const SocketException('No internet connection');
      } else if (DioExceptionType.connectionError == err.type) {
        throw const SocketException('No Internet Connection');
      }
      throw Exception('Server error');
    }
  }
}
