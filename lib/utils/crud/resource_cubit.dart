import 'package:app/models/remote/common/failure.dart';
import 'package:app/services/api/_base_api_service.dart';
import 'package:app/services/local_storage/isar/_base_local_db_service.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';

class ResourceCubit<T> extends Cubit<ResourceState<T>> {
  ResourceCubit({
    required BaseAPIService<T> service,
    BaseLocalDBService<T, dynamic>? dbService,
  })  : _service = service,
        _dbService = dbService,
        super(const ResourceState.initial());

  final BaseAPIService<T> _service;
  final BaseLocalDBService<T, dynamic>? _dbService;
  final _logger = Logger();

  /// Fetch all items from the API, optionally caching to Isar.
  Future<void> loadAll({
    Map<String, dynamic>? filters,
    List<String>? includes,
    int? limit,
    int? page,
    String? orderBy,
    String? orderDirection,
  }) async {
    emit(const ResourceState.listLoading());
    try {
      final items = await _service.list(
        filters: filters,
        includes: includes,
        limit: limit,
        page: page,
        orderBy: orderBy,
        orderDirection: orderDirection,
      );

      if (_dbService != null) {
        await _dbService.persistEntities(items);
      }

      emit(ResourceState.listLoaded(
        items: items,
        page: page ?? 1,
      ));
    } on Failure catch (e) {
      _logger.e('ResourceCubit.loadAll failed: ${e.message}');
      emit(ResourceState.error(message: e.message));
    } catch (e) {
      _logger.e('ResourceCubit.loadAll failed: $e');
      emit(ResourceState.error(message: e.toString()));
    }
  }

  /// Create a new item via the API, optionally persisting to Isar.
  Future<void> create({
    required Map<String, dynamic> data,
    List<String>? includes,
  }) async {
    final currentItems = state.maybeMap(
      listLoaded: (s) => s.items,
      mutated: (s) => s.items,
      orElse: () => <T>[],
    );

    emit(ResourceState.mutating(
      items: currentItems,
      operation: ResourceOperation.create,
    ));

    try {
      final item = await _service.create(data: data, includes: includes);
      await _dbService?.persistEntity(item);

      final updatedItems = [...currentItems, item];
      emit(ResourceState.mutated(
        items: updatedItems,
        operation: ResourceOperation.create,
        item: item,
      ));
    } on Failure catch (e) {
      _logger.e('ResourceCubit.create failed: ${e.message}');
      emit(ResourceState.error(message: e.message, items: currentItems));
    } catch (e) {
      _logger.e('ResourceCubit.create failed: $e');
      emit(ResourceState.error(message: e.toString(), items: currentItems));
    }
  }

  /// Update an existing item via the API, optionally persisting to Isar.
  Future<void> update({
    required String id,
    required Map<String, dynamic> data,
    List<String>? includes,
  }) async {
    final currentItems = state.maybeMap(
      listLoaded: (s) => s.items,
      mutated: (s) => s.items,
      orElse: () => <T>[],
    );

    emit(ResourceState.mutating(
      items: currentItems,
      operation: ResourceOperation.update,
    ));

    try {
      final item = await _service.update(
        id: id,
        data: data,
        includes: includes,
      );
      await _dbService?.persistEntity(item);

      emit(ResourceState.mutated(
        items: currentItems,
        operation: ResourceOperation.update,
        item: item,
      ));
    } on Failure catch (e) {
      _logger.e('ResourceCubit.update failed: ${e.message}');
      emit(ResourceState.error(message: e.message, items: currentItems));
    } catch (e) {
      _logger.e('ResourceCubit.update failed: $e');
      emit(ResourceState.error(message: e.toString(), items: currentItems));
    }
  }

  /// Delete an item via the API, optionally removing from Isar.
  Future<void> delete({required String ulid}) async {
    final currentItems = state.maybeMap(
      listLoaded: (s) => s.items,
      mutated: (s) => s.items,
      orElse: () => <T>[],
    );

    emit(ResourceState.mutating(
      items: currentItems,
      operation: ResourceOperation.delete,
    ));

    try {
      await _service.delete(ulid: ulid);
      await _dbService?.deleteByKey(ulid);

      emit(ResourceState.mutated(
        items: currentItems,
        operation: ResourceOperation.delete,
      ));
    } on Failure catch (e) {
      _logger.e('ResourceCubit.delete failed: ${e.message}');
      emit(ResourceState.error(message: e.message, items: currentItems));
    } catch (e) {
      _logger.e('ResourceCubit.delete failed: $e');
      emit(ResourceState.error(message: e.toString(), items: currentItems));
    }
  }
}
