import 'dart:convert';

import 'package:app/utils/network.dart';

abstract class BaseAPIService<T> {
  final _networkUtil = NetworkUtil();

  // Abstract property that subclasses must define
  String get endpoint;

  // Abstract factory method for creating instances from JSON
  T createFromJson(Map<String, dynamic> json);

  // Abstract factory method for creating list from response
  List<T> createListFromResponse(Map<String, dynamic> response);

  // Method that uses the endpoint and type from the subclass
  Future<List<T>> list({
    Map<String, dynamic>? filters,
    List<String>? includes,
    int? limit,
    String? orderBy,
    String? orderDirection,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};

      // Add includes if provided
      if (includes != null) {
        queryParameters['include'] = includes.join(',');
      }

      // Add filters if provided
      if (filters != null) {
        filters.forEach((key, value) {
          if (value != null) {
            queryParameters['filter[$key]'] = value;
          }
        });
      }

      // Add limit if provided
      if (limit != null) {
        queryParameters['limit'] = limit;
      }

      // Add ordering if provided
      if (orderBy != null) {
        queryParameters['order_by'] = orderBy;
      }
      if (orderDirection != null) {
        queryParameters['order_direction'] = orderDirection;
      }

      final res = await _networkUtil.getReq(
        endpoint,
        queryParameters: queryParameters,
      );

      // Use the subclass factory method to parse the response
      return createListFromResponse(res);
    } catch (e) {
      rethrow;
    }
  }

  // Method for fetching a single item
  Future<T> get({
    required String id,
    List<String>? includes,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};

      // Add includes if provided
      if (includes != null) {
        queryParameters['include'] = includes.join(',');
      }

      final res = await _networkUtil.getReq(
        '$endpoint/$id',
        queryParameters: queryParameters,
      );

      // Use the subclass factory method to parse the response
      return createFromJson(res['data'] as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  // Method for creating a new item
  Future<T> create({
    required Map<String, dynamic> data,
    List<String>? includes,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      // Add includes if provided
      if (includes != null) {
        queryParameters['include'] = includes.join(',');
      }
      final res = await _networkUtil.postReq(
        endpoint,
        body: json.encode(data),
        queryParameters: queryParameters,
      );
      // Use the subclass factory method to parse the response
      return createFromJson(res['data'] as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  // Method for updating an existing item
  Future<T> update({
    required String id,
    required Map<String, dynamic> data,
    List<String>? includes,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      // Add includes if provided
      if (includes != null) {
        queryParameters['include'] = includes.join(',');
      }
      final res = await _networkUtil.putReq(
        '$endpoint/$id',
        body: json.encode(data),
        queryParameters: queryParameters,
      );
      // Use the subclass factory method to parse the response
      return createFromJson(res['data'] as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  // Method for deleting an item
  Future<void> delete({
    required String id,
  }) async {
    try {
      await _networkUtil.deleteReq(
        '$endpoint/$id',
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<R>> listChildren<R>({
    required String parentId,
    required String childPath,
    required List<R> Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final res = await _networkUtil.getReq(
        '$endpoint/$parentId/$childPath',
        queryParameters: queryParameters,
      );

      return fromJson(res);
    } catch (e) {
      rethrow;
    }
  }

  Future<R> getChild<R>({
    required String parentId,
    required String childPath,
    required R Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final res = await _networkUtil.getReq(
        '$endpoint/$parentId/$childPath',
        queryParameters: queryParameters,
      );

      return fromJson(res);
    } catch (e) {
      rethrow;
    }
  }

  Future<R> createChild<R>({
    required String parentId,
    required String childPath,
    required Map<String, dynamic> data,
    required R Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final res = await _networkUtil.postReq(
        '$endpoint/$parentId/$childPath',
        body: json.encode(data),
        queryParameters: queryParameters,
      );

      return fromJson(res);
    } catch (e) {
      rethrow;
    }
  }

  Future<R> updateChild<R>({
    required String parentId,
    required String childPath,
    required String childId,
    required Map<String, dynamic> data,
    required R Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final res = await _networkUtil.putReq(
        '$endpoint/$parentId/$childPath/$childId',
        body: json.encode(data),
        queryParameters: queryParameters,
      );

      return fromJson(res);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteChild({
    required String parentId,
    required String childPath,
    required String childId,
  }) async {
    try {
      await _networkUtil.deleteReq(
        '$endpoint/$parentId/$childPath/$childId',
      );
    } catch (e) {
      rethrow;
    }
  }
}
