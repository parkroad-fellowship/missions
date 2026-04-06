import 'dart:async';

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
class ResourceCubit<TRemote, TLocal extends Object?>
    extends Cubit<ResourceState<TRemote>> {
  ResourceCubit({
    required BaseAPIService<TRemote> service,
    this.dbService,
  }) : _service = service,
       super(const ResourceState.initial());

  final BaseAPIService<TRemote> _service;
  final BaseLocalDBService<TRemote, TLocal>? dbService;
  final _logger = Logger();

  /// Stores the last filters used by [loadAll] so that [refreshIsarStreams]
  /// can be called with the correct parent key after mutations.
  Map<String, dynamic>? _lastFilters;

  /// Subscription to the Isar DB stream for reactive updates.
  /// When external sources (e.g., socket service) write to Isar and refresh
  /// the stream, this triggers a re-fetch so the cubit state stays current.
  StreamSubscription<dynamic>? _isarStreamSubscription;

  /// Subscribe to the Isar DB service's stream. When the stream emits
  /// (from socket events or any other Isar write), the cubit re-fetches
  /// data via [loadAll] using the last-used filters.
  ///
  /// Call this in the subclass constructor for cubits that need
  /// real-time updates from socket-driven Isar changes.
  void subscribeToIsarUpdates() {
    _isarStreamSubscription = dbService?.stream.listen((_) {
      if (!isClosed) {
        loadAll(filters: _lastFilters);
      }
    });
  }

  @override
  Future<void> close() {
    _isarStreamSubscription?.cancel();
    return super.close();
  }

  /// Override these in subclasses for resource-specific defaults.
  List<String> get defaultIncludes => [];
  Map<String, dynamic> get defaultFilters => {};
  int? get defaultLimit => null;
  String? get defaultSortBy => null;

  /// Extracts the current list from whatever state we are in.
  List<TRemote> get currentItems {
    return state.maybeWhen(
      itemLoading: (items, _) => items,
      listLoading: (items) => items,
      listLoaded: (items, _, _) => items,
      itemLoaded: (_, items) => items,
      mutating: (items, _) => items,
      mutated: (items, _, _) => items,
      error: (_, items) => items,
      itemError: (_, items, _) => items,
      orElse: () => [],
    );
  }

  TRemote? get currentItem {
    return state.maybeWhen(
      itemLoading: (_, item) => item,
      itemLoaded: (item, _) => item,
      mutated: (_, _, item) => item,
      itemError: (_, _, item) => item,
      orElse: () => null,
    );
  }

  TRemote? _firstWhereOrNull(
    List<TRemote> source,
    bool Function(TRemote item) predicate,
  ) {
    for (final item in source) {
      if (predicate(item)) {
        return item;
      }
    }
    return null;
  }

  List<TRemote> _upsertCurrentItems(
    TRemote item,
    bool Function(TRemote existing) matchById,
  ) {
    final items = [...currentItems];
    final index = items.indexWhere(matchById);
    if (index >= 0) {
      items[index] = item;
      return items;
    }
    return [item, ...items];
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

  /// Override in subclasses when local cache types differ from remote models.
  ///
  /// Return a hydrated remote entity for [id] from local storage when possible.
  Future<TRemote?> loadCachedItem(String id) async {
    if (dbService == null) return null;
    try {
      final item = await dbService!.get(id);
      return item != null ? dbService!.localToRemote(item) : null;
    } catch (e, s) {
      _logger.e('Error loading cached item', error: e, stackTrace: s);
      return null;
    }
  }

  /// Fetch the full list of resources.
  /// On API failure with Isar available, falls back to cached data.
  Future<void> loadAll({
    Map<String, dynamic>? filters,
    List<String>? includes,
    int? limit,
    int? page,
    String? sortBy,
  }) async {
    final mergedFilters = {...defaultFilters, ...?filters};
    _lastFilters = mergedFilters;

    _emitIfOpen(ResourceState.listLoading(items: currentItems));
    try {
      final items = await _service.list(
        filters: mergedFilters,
        includes: includes ?? defaultIncludes,
        limit: limit ?? defaultLimit,
        page: page,
        sortBy: sortBy ?? defaultSortBy,
      );

      await dbService?.persistEntities(items);
      await refreshIsarStreams(filters: mergedFilters);

      _emitIfOpen(ResourceState.listLoaded(items: items, page: page ?? 1));
    } on Failure catch (e) {
      // Offline fallback: try Isar cache
      if (dbService != null) {
        try {
          final cached = await dbService!.list();
          if (cached.isNotEmpty) {
            _logger.w('API failed, using ${cached.length} cached items');
            _emitIfOpen(
              ResourceState.listLoaded(
                items: dbService!.localToRemoteList(cached),
              ),
            );
            return;
          }
        } catch (_) {
          // Isar fallback also failed, emit original error
        }
      }
      _emitIfOpen(ResourceState.error(message: e.message, items: currentItems));
    } catch (e, s) {
      _logger.e('Error loading resources', error: e, stackTrace: s);
      _emitIfOpen(
        ResourceState.error(message: e.toString(), items: currentItems),
      );
    }
  }

  /// Append the next page of results to the current list.
  Future<void> loadMore({
    required int page,
    Map<String, dynamic>? filters,
    List<String>? includes,
    int? limit,
    String? sortBy,
  }) async {
    final mergedFilters = {...defaultFilters, ...?filters};
    try {
      final newItems = await _service.list(
        filters: mergedFilters,
        includes: includes ?? defaultIncludes,
        limit: limit ?? defaultLimit,
        page: page,
        sortBy: sortBy ?? defaultSortBy,
      );

      await dbService?.persistEntities(newItems);
      await refreshIsarStreams(filters: mergedFilters);

      _emitIfOpen(
        ResourceState.listLoaded(
          items: [...currentItems, ...newItems],
          page: page,
          hasMore: newItems.isNotEmpty,
        ),
      );
    } on Failure catch (e) {
      _emitIfOpen(ResourceState.error(message: e.message, items: currentItems));
    } catch (e, s) {
      _logger.e('Error loading more resources', error: e, stackTrace: s);
      _emitIfOpen(
        ResourceState.error(message: e.toString(), items: currentItems),
      );
    }
  }

  /// Fetch a single resource for detail screens while preserving CRUD list state.
  Future<TRemote?> loadOne({
    required String id,
    required bool Function(TRemote item) matchById,
    List<String>? includes,
    bool refresh = false,
  }) async {
    final existing = _firstWhereOrNull(currentItems, matchById);

    if (existing != null && !refresh) {
      _emitIfOpen(
        ResourceState.itemLoaded(item: existing, items: currentItems),
      );
      return existing;
    }

    if (!refresh) {
      final cached = await loadCachedItem(id);
      if (cached != null) {
        _emitIfOpen(
          ResourceState.itemLoaded(
            item: cached,
            items: _upsertCurrentItems(cached, matchById),
          ),
        );
        return cached;
      }
    }

    _emitIfOpen(ResourceState.itemLoading(items: currentItems, item: existing));

    try {
      final item = await _service.get(
        ulid: id,
        includes: includes ?? defaultIncludes,
      );

      await dbService?.persistEntity(item);
      await refreshIsarStreams(filters: _lastFilters);

      _emitIfOpen(
        ResourceState.itemLoaded(
          item: item,
          items: _upsertCurrentItems(item, matchById),
        ),
      );
      return item;
    } on Failure catch (e) {
      final cached = await loadCachedItem(id);
      if (cached != null) {
        _emitIfOpen(
          ResourceState.itemLoaded(
            item: cached,
            items: _upsertCurrentItems(cached, matchById),
          ),
        );
        return cached;
      }

      _emitIfOpen(
        ResourceState.itemError(
          message: e.message,
          items: currentItems,
          item: existing,
        ),
      );
    } catch (e, s) {
      final cached = await loadCachedItem(id);
      if (cached != null) {
        _emitIfOpen(
          ResourceState.itemLoaded(
            item: cached,
            items: _upsertCurrentItems(cached, matchById),
          ),
        );
        return cached;
      }

      _logger.e('Error loading single resource', error: e, stackTrace: s);
      _emitIfOpen(
        ResourceState.itemError(
          message: e.toString(),
          items: currentItems,
          item: existing,
        ),
      );
    }

    return existing;
  }

  /// Create a new resource and prepend it to the in-memory list.
  Future<void> create({
    required Map<String, dynamic> data,
    List<String>? includes,
  }) async {
    _emitIfOpen(
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
      _emitIfOpen(
        ResourceState.mutated(
          items: updated,
          operation: ResourceOperation.create,
          item: item,
        ),
      );
    } on Failure catch (e) {
      _emitIfOpen(ResourceState.error(message: e.message, items: currentItems));
    } catch (e, s) {
      _logger.e('Error creating resource', error: e, stackTrace: s);
      _emitIfOpen(
        ResourceState.error(message: e.toString(), items: currentItems),
      );
    }
  }

  /// Update an existing resource and replace it in the in-memory list.
  Future<void> update({
    required String id,
    required Map<String, dynamic> data,
    required bool Function(TRemote item) matchById,
    List<String>? includes,
  }) async {
    _emitIfOpen(
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
      _emitIfOpen(
        ResourceState.mutated(
          items: updated,
          operation: ResourceOperation.update,
          item: item,
        ),
      );
    } on Failure catch (e) {
      _emitIfOpen(ResourceState.error(message: e.message, items: currentItems));
    } catch (e, s) {
      _logger.e('Error updating resource', error: e, stackTrace: s);
      _emitIfOpen(
        ResourceState.error(message: e.toString(), items: currentItems),
      );
    }
  }

  /// Delete a resource and remove it from the in-memory list.
  Future<void> delete({
    required String ulid,
    required bool Function(TRemote item) matchById,
  }) async {
    _emitIfOpen(
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
      _emitIfOpen(
        ResourceState.mutated(
          items: updated,
          operation: ResourceOperation.delete,
        ),
      );
    } on Failure catch (e) {
      _emitIfOpen(ResourceState.error(message: e.message, items: currentItems));
    } catch (e, s) {
      _logger.e('Error deleting resource', error: e, stackTrace: s);
      _emitIfOpen(
        ResourceState.error(message: e.toString(), items: currentItems),
      );
    }
  }

  /// Reset to initial state.
  void reset() => _emitIfOpen(const ResourceState.initial());

  void _emitIfOpen(ResourceState<TRemote> nextState) {
    if (isClosed) return;
    emit(nextState);
  }
}
