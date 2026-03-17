import 'package:app/models/remote/common/failure.dart';
import 'package:app/services/api/_base_api_service.dart';
import 'package:app/services/local_storage/isar/_base_local_db_service.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';

/// A single cubit that handles list, create, update, and delete
/// for any resource backed by a [BaseAPIService<T>].
///
/// Subclasses only need to:
///   1. Pass the service via super constructor.
///   2. Optionally override [defaultIncludes], [defaultFilters], etc.
///   3. Optionally override [refreshIsarStreams] for parent-filtered streams.
///   4. Add resource-specific convenience methods.
class ResourceCubit<T> extends Cubit<ResourceState<T>> {
  ResourceCubit({
    required BaseAPIService<T> service,
    this.dbService,
  })  : _service = service,
        super(const ResourceState.initial());

  final BaseAPIService<T> _service;
  final BaseLocalDBService<T, dynamic>? dbService;
  final _logger = Logger();

  /// Stores the last filters used by [loadAll] so that [refreshIsarStreams]
  /// can be called with the correct parent key after mutations.
  Map<String, dynamic>? _lastFilters;

  /// Override these in subclasses for resource-specific defaults.
  List<String> get defaultIncludes => [];
  Map<String, dynamic> get defaultFilters => {};
  int? get defaultLimit => null;
  String? get defaultOrderBy => null;
  String? get defaultOrderDirection => null;

  /// Extracts the current list from whatever state we are in.
  List<T> get currentItems {
    return state.maybeWhen(
      listLoaded: (items, _, _) => items,
      mutating: (items, _) => items,
      mutated: (items, _, _) => items,
      error: (_, items) => items,
      orElse: () => [],
    );
  }

  /// Override in subclasses to refresh Isar streams after data persistence.
  /// Called after persistEntities/persistEntity/deleteByKey.
  ///
  /// The base implementation calls [dbService.refreshStream()].
  /// Subclasses with parent-filtered streams should also call
  /// [refreshParentStream(parentKey)] on their typed DB service.
  Future<void> refreshIsarStreams({
    Map<String, dynamic>? filters,
  }) async {
    await dbService?.refreshStream();
  }

  /// Fetch the full list of resources.
  /// On API failure with Isar available, falls back to cached data.
  Future<void> loadAll({
    Map<String, dynamic>? filters,
    List<String>? includes,
    int? limit,
    int? page,
    String? orderBy,
    String? orderDirection,
  }) async {
    final mergedFilters = {...defaultFilters, ...?filters};
    _lastFilters = mergedFilters;

    emit(const ResourceState.listLoading());
    try {
      final items = await _service.list(
        filters: mergedFilters,
        includes: includes ?? defaultIncludes,
        limit: limit ?? defaultLimit,
        page: page,
        orderBy: orderBy ?? defaultOrderBy,
        orderDirection: orderDirection ?? defaultOrderDirection,
      );

      await dbService?.persistEntities(items);
      await refreshIsarStreams(filters: mergedFilters);

      emit(ResourceState.listLoaded(items: items, page: page ?? 1));
    } on Failure catch (e) {
      // Offline fallback: try Isar cache
      if (dbService != null) {
        try {
          final cached = await dbService!.list();
          if (cached.isNotEmpty) {
            _logger.w('API failed, using ${cached.length} cached items');
          }
        } catch (_) {
          // Isar fallback also failed, emit original error
        }
      }
      emit(ResourceState.error(message: e.message, items: currentItems));
    } catch (e, s) {
      _logger.e('Error loading resources', error: e, stackTrace: s);
      emit(ResourceState.error(message: e.toString(), items: currentItems));
    }
  }

  /// Append the next page of results to the current list.
  Future<void> loadMore({
    required int page,
    Map<String, dynamic>? filters,
    List<String>? includes,
    int? limit,
    String? orderBy,
    String? orderDirection,
  }) async {
    final mergedFilters = {...defaultFilters, ...?filters};
    try {
      final newItems = await _service.list(
        filters: mergedFilters,
        includes: includes ?? defaultIncludes,
        limit: limit ?? defaultLimit,
        page: page,
        orderBy: orderBy ?? defaultOrderBy,
        orderDirection: orderDirection ?? defaultOrderDirection,
      );

      await dbService?.persistEntities(newItems);
      await refreshIsarStreams(filters: mergedFilters);

      emit(
        ResourceState.listLoaded(
          items: [...currentItems, ...newItems],
          page: page,
          hasMore: newItems.isNotEmpty,
        ),
      );
    } on Failure catch (e) {
      emit(ResourceState.error(message: e.message, items: currentItems));
    } catch (e, s) {
      _logger.e('Error loading more resources', error: e, stackTrace: s);
      emit(ResourceState.error(message: e.toString(), items: currentItems));
    }
  }

  /// Create a new resource and prepend it to the in-memory list.
  Future<void> create({
    required Map<String, dynamic> data,
    List<String>? includes,
  }) async {
    emit(
      ResourceState.mutating(
        items: currentItems,
        operation: ResourceOperation.create,
      ),
    );
    try {
      final item = await _service.create(
        data: data,
        includes: includes ?? defaultIncludes,
      );
      await dbService?.persistEntity(item);
      await refreshIsarStreams(filters: _lastFilters);

      final updated = [item, ...currentItems];
      emit(
        ResourceState.mutated(
          items: updated,
          operation: ResourceOperation.create,
          item: item,
        ),
      );
    } on Failure catch (e) {
      emit(ResourceState.error(message: e.message, items: currentItems));
    } catch (e, s) {
      _logger.e('Error creating resource', error: e, stackTrace: s);
      emit(ResourceState.error(message: e.toString(), items: currentItems));
    }
  }

  /// Update an existing resource and replace it in the in-memory list.
  Future<void> update({
    required String id,
    required Map<String, dynamic> data,
    required bool Function(T item) matchById,
    List<String>? includes,
  }) async {
    emit(
      ResourceState.mutating(
        items: currentItems,
        operation: ResourceOperation.update,
      ),
    );
    try {
      final item = await _service.update(
        id: id,
        data: data,
        includes: includes ?? defaultIncludes,
      );
      await dbService?.persistEntity(item);
      await refreshIsarStreams(filters: _lastFilters);

      final updated = currentItems.map((existing) {
        return matchById(existing) ? item : existing;
      }).toList();
      emit(
        ResourceState.mutated(
          items: updated,
          operation: ResourceOperation.update,
          item: item,
        ),
      );
    } on Failure catch (e) {
      emit(ResourceState.error(message: e.message, items: currentItems));
    } catch (e, s) {
      _logger.e('Error updating resource', error: e, stackTrace: s);
      emit(ResourceState.error(message: e.toString(), items: currentItems));
    }
  }

  /// Delete a resource and remove it from the in-memory list.
  Future<void> delete({
    required String ulid,
    required bool Function(T item) matchById,
  }) async {
    emit(
      ResourceState.mutating(
        items: currentItems,
        operation: ResourceOperation.delete,
      ),
    );
    try {
      await _service.delete(ulid: ulid);
      await dbService?.deleteByKey(ulid);
      await refreshIsarStreams(filters: _lastFilters);

      final updated = currentItems.where((item) => !matchById(item)).toList();
      emit(
        ResourceState.mutated(
          items: updated,
          operation: ResourceOperation.delete,
        ),
      );
    } on Failure catch (e) {
      emit(ResourceState.error(message: e.message, items: currentItems));
    } catch (e, s) {
      _logger.e('Error deleting resource', error: e, stackTrace: s);
      emit(ResourceState.error(message: e.toString(), items: currentItems));
    }
  }

  /// Reset to initial state.
  void reset() => emit(const ResourceState.initial());
}
