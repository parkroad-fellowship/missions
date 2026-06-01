import 'dart:async';

import 'package:app/models/remote/common/failure.dart';
import 'package:app/services/api/_base_api_service.dart';
import 'package:app/services/local_storage/hive/db/_base_hive_db_service.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';

/// A single cubit that handles list, create, update, and delete
/// for any resource backed by a [BaseAPIService<T>].
///
/// Subclasses only need to:
///   1. Pass the service via super constructor.
///   2. Optionally override [defaultIncludes], [defaultFilters], etc.
///   3. Add resource-specific convenience methods.
class ResourceCubit<TRemote> extends Cubit<ResourceState<TRemote>> {
  ResourceCubit({
    required BaseAPIService<TRemote> service,
    required this.dbService,
  }) : _service = service,
       super(const ResourceState.initial());

  final BaseAPIService<TRemote> _service;
  final BaseHiveDbService<TRemote> dbService;
  final _logger = Logger();

  /// Stores the last filters used by [loadAll] to ensure
  /// subsequent fetches use the correct parent key after mutations.
  Map<String, dynamic>? _lastFilters;

  /// Exposes [_lastFilters] to subclasses that need to pass the last-used
  /// filter context (e.g. parent ULID) from within
  /// custom mutation methods.
  Map<String, dynamic>? get lastFilters => _lastFilters;

  /// Subscription to the Hive DB stream for reactive updates.
  /// When external sources (e.g., API calls, socket events) write to Hive,
  /// this triggers a re-fetch so the cubit state stays current organically.
  StreamSubscription<List<TRemote>>? _dbStreamSubscription;

  /// Subscribe to the Hive DB service's stream.
  /// The stream automatically triggers a locally filtered fetch via [loadCachedList].
  void subscribeToDbUpdates() {
    _dbStreamSubscription?.cancel();
    _dbStreamSubscription = dbService.stream.listen((_) async {
      if (!isClosed) {
        final hiveItems = await loadCachedList(filters: _lastFilters);
        _emitIfOpen(
          ResourceState.listLoaded(
            items: hiveItems,
            // Preserve current page metadata if it exists
            page: state.maybeWhen(
              listLoaded: (_, page, _) => page,
              orElse: () => 1,
            ),
            hasMore: state.maybeWhen(
              listLoaded: (_, _, hasMore) => hasMore,
              orElse: () => false,
            ),
          ),
        );
      }
    });
  }

  @override
  Future<void> close() {
    _dbStreamSubscription?.cancel();
    return super.close();
  }

  /// Override these in subclasses for resource-specific defaults.
  List<String> get defaultIncludes => [];
  Map<String, dynamic> get defaultFilters => {};
  int get defaultLimit => 15;
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

  /// Returns the initial cached list used by [loadAll] for the cache-first
  /// local seed. Defaults to [dbService.list()] (all items).
  ///
  /// Override in subclasses that have parent-filtered Hive data to return only
  /// the items relevant to the current parent context (e.g. by mission ULID).
  Future<List<TRemote>> loadCachedList({
    Map<String, dynamic>? filters,
  }) {
    throw UnimplementedError();
  }

  /// Fetch the full list of resources from the API.
  /// Persists into Hive, triggering an organic UI update via [_dbStreamSubscription].
  Future<void> loadAll({
    Map<String, dynamic>? filters,
    List<String>? includes,
    int? limit,
    int? page,
    String? sortBy,
    bool forceRefresh = false,
  }) async {
    final mergedFilters = {...defaultFilters, ...?filters};
    _lastFilters = mergedFilters;
    final resolvedLimit = limit ?? defaultLimit;
    final startPage = page ?? 1;

    // Ensure we are subscribed to organically push DB changes to the UI
    if (_dbStreamSubscription == null) {
      subscribeToDbUpdates();
    }

    // Immediately seed the UI with cached data for the newly requested filters
    // so switching contexts (like viewing a different mission) feels instant.
    try {
      final cached = await loadCachedList(filters: mergedFilters);
      _emitIfOpen(ResourceState.listLoading(items: cached));

      // If we already have a full page of cache and we weren't explicitly asked to refresh,
      // we can optionally skip the API call to save bandwidth and prevent "overwriting all items".
      if (!forceRefresh && cached.length >= resolvedLimit) {
        _emitIfOpen(
          ResourceState.listLoaded(
            items: cached,
            page: startPage,
            hasMore: cached.length == resolvedLimit,
          ),
        );
        return;
      }
    } catch (_) {}

    try {
      final batch = await _service.list(
        filters: mergedFilters,
        includes: includes ?? defaultIncludes,
        limit: resolvedLimit,
        page: startPage,
        sortBy: sortBy ?? defaultSortBy,
      );

      // Track pagination on the state to assist UI without overriding the stream emit.
      // We manually emit listLoaded with old cache and new pagination values,
      // which will then rapidly be augmented by the organic DB trigger.
      _emitIfOpen(
        ResourceState.listLoaded(
          items: currentItems,
          page: startPage,
          hasMore: batch.length == resolvedLimit,
        ),
      );

      await dbService.persistEntities(batch);
    } on Failure catch (e) {
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

      // Track pagination on the state to assist UI without overriding the stream emit.
      // We manually emit listLoaded with old cache and new pagination values,
      // which will then rapidly be augmented by the organic DB trigger.
      _emitIfOpen(
        ResourceState.listLoaded(
          items: currentItems,
          page: page,
          hasMore: newItems.isNotEmpty,
        ),
      );

      await dbService.persistEntities(newItems);
    } on Failure catch (e) {
      _emitIfOpen(ResourceState.error(message: e.message, items: currentItems));
    } catch (e, s) {
      _logger.e('Error loading more resources', error: e, stackTrace: s);
      _emitIfOpen(
        ResourceState.error(message: e.toString(), items: currentItems),
      );
    }
  }

  /// Create a new resource.
  ///
  /// Persists the API response to Hive, leaving [_dbStreamSubscription] to
  /// stream the authoritative list state back to the UI.
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
      await dbService.persistEntity(item);
    } on Failure catch (e) {
      _emitIfOpen(ResourceState.error(message: e.message, items: currentItems));
    } catch (e, s) {
      _logger.e('Error creating resource', error: e, stackTrace: s);
      _emitIfOpen(
        ResourceState.error(message: e.toString(), items: currentItems),
      );
    }
  }

  /// Update an existing resource.
  ///
  /// Persists the API response to Hive, leaving [_dbStreamSubscription] to
  /// stream the authoritative list state back to the UI.
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
      await dbService.persistEntity(item);
    } on Failure catch (e) {
      _emitIfOpen(ResourceState.error(message: e.message, items: currentItems));
    } catch (e, s) {
      _logger.e('Error updating resource', error: e, stackTrace: s);
      _emitIfOpen(
        ResourceState.error(message: e.toString(), items: currentItems),
      );
    }
  }

  /// Delete a resource.
  ///
  /// Removes the record from Hive, leaving [_dbStreamSubscription] to
  /// stream the authoritative list state back to the UI.
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
      await dbService.deleteByKey(ulid);
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
