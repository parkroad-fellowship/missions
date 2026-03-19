import 'package:app/models/remote/common/failure.dart';
import 'package:app/models/remote/expense/prf_allocation_entry.dart';
import 'package:app/models/remote/expense/prf_allocation_entry_dto.dart';
import 'package:app/models/remote/expense/prf_refund_dto.dart';
import 'package:app/models/remote/media/prf_media_dto.dart';
import 'package:app/services/api/allocation_entry_service.dart';
import 'package:app/services/api/refund_service.dart';
import 'package:app/services/local_storage/_index.dart';
import 'package:app/services/media_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';
import 'package:app/utils/crud/resource_state.dart';

class AllocationEntryResourceCubit extends ResourceCubit<PRFAllocationEntry> {
  AllocationEntryResourceCubit({
    required AllocationEntryService allocationEntryService,
    required MediaService mediaService,
    required HiveService hiveService,
    RefundService? refundService,
    super.dbService,
  }) : _allocationEntryService = allocationEntryService,
       _mediaService = mediaService,
       _hiveService = hiveService,
       _refundService = refundService,
       super(service: allocationEntryService);

  final AllocationEntryService _allocationEntryService;
  final MediaService _mediaService;
  final HiveService _hiveService;
  final RefundService? _refundService;

  @override
  List<String> get defaultIncludes => [
    'expenseCategory',
    'member',
    'accountingEvent',
    'accountingEvent.refunds',
    'accountingEvent.latestRefund',
    'receipts',
  ];

  /// Create an allocation entry with optional receipt uploads.
  Future<void> addEntry({
    required PRFAllocationEntryDTO data,
    List<PRFMediaDTO> receiptDTOs = const [],
  }) async {
    emit(
      ResourceState.mutating(
        items: currentItems,
        operation: ResourceOperation.create,
      ),
    );

    try {
      final dto = data.copyWith(
        memberUlid: _hiveService.retrieveMember()!.ulid,
      );
      final entry = await _allocationEntryService.create(data: dto.toJson());

      for (final receiptDTO in receiptDTOs) {
        await _mediaService.uploadFile(
          imageDTO: receiptDTO.copyWith(modelUlid: entry.ulid),
        );
      }

      final updated = [entry, ...currentItems];
      emit(
        ResourceState.mutated(
          items: updated,
          operation: ResourceOperation.create,
          item: entry,
        ),
      );
    } on Failure catch (e) {
      emit(ResourceState.error(message: e.message, items: currentItems));
    } catch (e) {
      emit(ResourceState.error(message: e.toString(), items: currentItems));
    }
  }

  /// Update an allocation entry with optional receipt uploads.
  Future<void> editEntry({
    required String ulid,
    required PRFAllocationEntryDTO data,
    List<PRFMediaDTO> receiptDTOs = const [],
  }) async {
    emit(
      ResourceState.mutating(
        items: currentItems,
        operation: ResourceOperation.update,
      ),
    );

    try {
      final dto = data.copyWith(
        memberUlid: _hiveService.retrieveMember()!.ulid,
      );
      final entry = await _allocationEntryService.update(
        id: ulid,
        data: dto.toJson(),
      );

      for (final receiptDTO in receiptDTOs) {
        await _mediaService.uploadFile(
          imageDTO: receiptDTO.copyWith(modelUlid: entry.ulid),
        );
      }

      final updated = currentItems.map((e) {
        return e.ulid == ulid ? entry : e;
      }).toList();
      emit(
        ResourceState.mutated(
          items: updated,
          operation: ResourceOperation.update,
          item: entry,
        ),
      );
    } on Failure catch (e) {
      emit(ResourceState.error(message: e.message, items: currentItems));
    } catch (e) {
      emit(ResourceState.error(message: e.toString(), items: currentItems));
    }
  }

  /// Delete an allocation entry.
  Future<void> deleteEntry(String ulid) async {
    await delete(ulid: ulid, matchById: (e) => e.ulid == ulid);
  }

  /// Add a token entry (uses custom endpoint).
  Future<void> addTokenEntry({
    required PRFAllocationTokenEntryDTO data,
  }) async {
    emit(
      ResourceState.mutating(
        items: currentItems,
        operation: ResourceOperation.create,
      ),
    );

    try {
      final entry = await _allocationEntryService.addToken(data: data);
      final updated = [entry, ...currentItems];
      emit(
        ResourceState.mutated(
          items: updated,
          operation: ResourceOperation.create,
          item: entry,
        ),
      );
    } on Failure catch (e) {
      emit(ResourceState.error(message: e.message, items: currentItems));
    } catch (e) {
      emit(ResourceState.error(message: e.toString(), items: currentItems));
    }
  }

  /// Add a mission refund (uses RefundService).
  Future<void> addRefund({required PRFRefundDTO data}) async {
    emit(
      ResourceState.mutating(
        items: currentItems,
        operation: ResourceOperation.create,
      ),
    );

    try {
      if (_refundService == null) {
        throw Exception('RefundService not provided');
      }
      await _refundService.create(data: data.toJson());
      emit(
        ResourceState.mutated(
          items: currentItems,
          operation: ResourceOperation.create,
        ),
      );
    } on Failure catch (e) {
      emit(ResourceState.error(message: e.message, items: currentItems));
    } catch (e) {
      emit(ResourceState.error(message: e.toString(), items: currentItems));
    }
  }
}
