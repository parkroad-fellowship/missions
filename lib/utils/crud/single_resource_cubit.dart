import 'dart:async';

import 'package:app/models/remote/common/failure.dart';
import 'package:app/services/api/_base_api_service.dart';
import 'package:app/services/local_storage/hive/db/_base_hive_db_service.dart';
import 'package:app/utils/crud/resource_cubit.dart' show ResourceCubit;
import 'package:app/utils/crud/resource_state.dart';
import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';

/// Cubit dedicated to a single-resource read model.
///
/// Hive DB is the source of truth: after every remote write the entity is
/// persisted first and the item emitted to the UI comes from the Hive read,
/// not the raw API response.
///
/// Only item-scoped states are used: [ResourceState.itemLoading],
/// [ResourceState.itemLoaded], [ResourceState.itemError], and
/// [ResourceState.initial]. List fields in those states are always empty.
/// Parent list state is never read or mutated by this cubit - list cubits
/// and [ResourceCubit] subclasses remain the sole owners of list state.
class SingleResourceCubit<TRemote> extends Cubit<ResourceState<TRemote>> {
  SingleResourceCubit({
    required BaseAPIService<TRemote> service,
    required this.dbService,
  }) : _service = service,
       super(const ResourceState.initial());

  final BaseAPIService<TRemote> _service;
  final BaseHiveDbService<TRemote> dbService;
  final _logger = Logger();

  StreamSubscription<TRemote?>? _dbItemSubscription;
  String? _subscribedItemId;

  /// Subscribe to the Hive DB service's item stream for reactive updates.
  void subscribeToDbUpdates(String id) {
    _dbItemSubscription?.cancel();
    _subscribedItemId = id;

    _dbItemSubscription = dbService.watchItem(id).listen((item) {
      if (isClosed) return;

      if (item == null) {
        _emitIfOpen(const ResourceState.initial());
        return;
      }

      _emitIfOpen(
        ResourceState.itemLoaded(item: dbService.localToRemote(item)),
      );
    });
  }

  @override
  Future<void> close() {
    _dbItemSubscription?.cancel();
    return super.close();
  }

  List<String> get defaultIncludes => [];

  TRemote? get currentItem {
    return state.maybeWhen(
      itemLoading: (_, item) => item,
      itemLoaded: (item, _) => item,
      itemError: (_, _, item) => item,
      orElse: () => null,
    );
  }

  Future<TRemote?> loadCachedItem(String id) async {
    try {
      final item = await dbService.get(id);
      return item != null ? dbService.localToRemote(item) : null;
    } catch (e, s) {
      _logger.e('Error loading cached item', error: e, stackTrace: s);
      return null;
    }
  }

  Future<TRemote?> loadOne({
    required String id,
    required bool Function(TRemote item) matchById,
    List<String>? includes,
    bool refresh = false,
  }) async {
    final existing = currentItem;

    if (_dbItemSubscription == null || _subscribedItemId != id) {
      subscribeToDbUpdates(id);
    }

    if (existing != null && matchById(existing) && !refresh) {
      _emitIfOpen(ResourceState.itemLoaded(item: existing));
      return existing;
    }

    if (!refresh) {
      final cached = await loadCachedItem(id);
      if (cached != null) {
        _emitIfOpen(ResourceState.itemLoaded(item: cached));
        return cached;
      }
    }

    _emitIfOpen(ResourceState.itemLoading(item: existing));

    try {
      final item = await _service.get(
        ulid: id,
        includes: includes ?? defaultIncludes,
      );
      await dbService.persistEntity(item);

      final persisted = await loadCachedItem(id);
      final finalItem = persisted ?? item;
      _emitIfOpen(ResourceState.itemLoaded(item: finalItem));
      return finalItem;
    } on Failure catch (e) {
      final cached = await loadCachedItem(id);
      if (cached != null) {
        _emitIfOpen(ResourceState.itemLoaded(item: cached));
        return cached;
      }

      _emitIfOpen(
        ResourceState.itemError(
          message: e.message,
          item: existing,
        ),
      );
    } catch (e, s) {
      final cached = await loadCachedItem(id);
      if (cached != null) {
        _emitIfOpen(ResourceState.itemLoaded(item: cached));
        return cached;
      }

      _logger.e('Error loading single resource', error: e, stackTrace: s);
      _emitIfOpen(
        ResourceState.itemError(
          message: e.toString(),
          item: existing,
        ),
      );
    }

    return existing;
  }

  /// Create a new resource.
  Future<void> create({
    required Map<String, dynamic> data,
    List<String>? includes,
  }) async {
    final existing = currentItem;
    _emitIfOpen(ResourceState.itemLoading(item: existing));
    try {
      final item = await _service.create(
        data: data,
        includes: includes ?? defaultIncludes,
      );
      await dbService.persistEntity(item);
      _emitIfOpen(ResourceState.itemLoaded(item: item));
    } on Failure catch (e) {
      _emitIfOpen(ResourceState.itemError(message: e.message, item: existing));
    } catch (e, s) {
      _logger.e('Error creating single resource', error: e, stackTrace: s);
      _emitIfOpen(
        ResourceState.itemError(message: e.toString(), item: existing),
      );
    }
  }

  /// Update an existing resource.
  Future<void> update({
    required String id,
    required Map<String, dynamic> data,
    List<String>? includes,
  }) async {
    final existing = currentItem;
    _emitIfOpen(ResourceState.itemLoading(item: existing));
    try {
      final item = await _service.update(
        id: id,
        data: data,
        includes: includes ?? defaultIncludes,
      );
      await dbService.persistEntity(item);
      _emitIfOpen(ResourceState.itemLoaded(item: item));
    } on Failure catch (e) {
      _emitIfOpen(ResourceState.itemError(message: e.message, item: existing));
    } catch (e, s) {
      _logger.e('Error updating single resource', error: e, stackTrace: s);
      _emitIfOpen(
        ResourceState.itemError(message: e.toString(), item: existing),
      );
    }
  }

  /// Delete a resource.
  Future<void> delete({required String ulid}) async {
    final existing = currentItem;
    _emitIfOpen(ResourceState.itemLoading(item: existing));
    try {
      await _service.delete(ulid: ulid);
      await dbService.deleteByKey(ulid);
      _emitIfOpen(const ResourceState.initial());
    } on Failure catch (e) {
      _emitIfOpen(ResourceState.itemError(message: e.message, item: existing));
    } catch (e, s) {
      _logger.e('Error deleting single resource', error: e, stackTrace: s);
      _emitIfOpen(
        ResourceState.itemError(message: e.toString(), item: existing),
      );
    }
  }

  void reset() => _emitIfOpen(const ResourceState.initial());

  void _emitIfOpen(ResourceState<TRemote> nextState) {
    if (isClosed) return;
    emit(nextState);
  }
}
