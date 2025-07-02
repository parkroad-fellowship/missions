import 'dart:convert';

import 'package:app/utils/network.dart';

abstract class BaseService {
  final _networkUtil = NetworkUtil();

  // Abstract property that subclasses must define
  String get endpoint;

  // Abstract property for the type of data this service handles
  Type get type;

  // Abstract factory method for creating instances from JSON
  T createFromJson<T>(Map<String, dynamic> json);

  // Abstract factory method for creating list from response
  List<T> createListFromResponse<T>(Map<String, dynamic> response);

  // Method that uses the endpoint and type from the subclass
  Future<List<T>> list<T>({
    Map<String, dynamic>? filters,
    String? includes,
    int? limit,
    String? orderBy,
    String? orderDirection,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};

      // Add includes if provided
      if (includes != null) {
        queryParameters['include'] = includes;
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
      return createListFromResponse<T>(res);
    } catch (e) {
      rethrow;
    }
  }

  // Method for fetching a single item
  Future<T> get<T>({
    required String id,
    String? includes,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};

      // Add includes if provided
      if (includes != null) {
        queryParameters['include'] = includes;
      }

      final res = await _networkUtil.getReq(
        '$endpoint/$id',
        queryParameters: queryParameters,
      );

      // Use the subclass factory method to parse the response
      return createFromJson<T>(res['data'] as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  // Method for creating a new item
  Future<T> create<T>({
    required Map<String, dynamic> data,
    String? includes,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      // Add includes if provided
      if (includes != null) {
        queryParameters['include'] = includes;
      }
      final res = await _networkUtil.postReq(
        endpoint,
        body: json.encode(data),
        queryParameters: queryParameters,
      );
      // Use the subclass factory method to parse the response
      return createFromJson<T>(res['data'] as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  // Method for updating an existing item
  Future<T> update<T>({
    required String id,
    required Map<String, dynamic> data,
    String? includes,
  }) async {
    try {
      final queryParameters = <String, dynamic>{};
      // Add includes if provided
      if (includes != null) {
        queryParameters['include'] = includes;
      }
      final res = await _networkUtil.putReq(
        '$endpoint/$id',
        body: json.encode(data),
        queryParameters: queryParameters,
      );
      // Use the subclass factory method to parse the response
      return createFromJson<T>(res['data'] as Map<String, dynamic>);
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
}
