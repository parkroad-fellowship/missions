import 'package:app/models/remote/common/failure.dart';
import 'package:app/services/api/_base_api_service.dart';
import 'package:app/services/local_storage/isar/_base_local_db_service.dart';
import 'package:app/utils/crud/resource_state.dart';
import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';

/// Cubit dedicated to a single-resource read model.
///
/// Unlike [ResourceCubit], this cubit never owns list state. It is intended
/// for detail routes that load one record by id.
class SingleResourceCubit<TRemote, TLocal extends Object?>
    extends Cubit<ResourceState<TRemote>> {
  SingleResourceCubit({
    required BaseAPIService<TRemote> service,
    this.dbService,
  }) : _service = service,
       super(const ResourceState.initial());

  final BaseAPIService<TRemote> _service;
  final BaseLocalDBService<TRemote, TLocal>? dbService;
  final _logger = Logger();

  List<String> get defaultIncludes => [];

  TRemote? get currentItem {
    return state.maybeWhen(
      itemLoading: (_, item) => item,
      itemLoaded: (item, _) => item,
      itemError: (_, _, item) => item,
      orElse: () => null,
    );
  }

  Future<void> refreshIsarStreams() async {
    await dbService?.refreshStream();
  }

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

  Future<TRemote?> loadOne({
    required String id,
    required bool Function(TRemote item) matchById,
    List<String>? includes,
    bool refresh = false,
  }) async {
    final existing = currentItem;

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
      await dbService?.persistEntity(item);
      await refreshIsarStreams();

      _emitIfOpen(ResourceState.itemLoaded(item: item));
      return item;
    } on Failure catch (e) {
      final cached = await loadCachedItem(id);
      if (cached != null) {
        _emitIfOpen(ResourceState.itemLoaded(item: cached));
        return cached;
      }

      _emitIfOpen(ResourceState.itemError(message: e.message, item: existing));
    } catch (e, s) {
      final cached = await loadCachedItem(id);
      if (cached != null) {
        _emitIfOpen(ResourceState.itemLoaded(item: cached));
        return cached;
      }

      _logger.e('Error loading single resource', error: e, stackTrace: s);
      _emitIfOpen(
        ResourceState.itemError(message: e.toString(), item: existing),
      );
    }

    return existing;
  }

  void reset() => _emitIfOpen(const ResourceState.initial());

  void _emitIfOpen(ResourceState<TRemote> nextState) {
    if (isClosed) return;
    emit(nextState);
  }
}
