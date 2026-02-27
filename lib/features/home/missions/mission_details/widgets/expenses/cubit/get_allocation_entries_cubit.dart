import 'package:app/models/remote/common/failure.dart';
import 'package:app/models/remote/expense/prf_allocation_entry.dart';
import 'package:app/services/api/allocation_entry_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_allocation_entries_state.dart';
part 'get_allocation_entries_cubit.freezed.dart';

class GetAllocationEntriesCubit extends Cubit<GetAllocationEntriesState> {
  GetAllocationEntriesCubit({
    required AllocationEntryService allocationEntryService,
  }) : super(const GetAllocationEntriesState.initial()) {
    _allocationEntryService = allocationEntryService;
  }

  late AllocationEntryService _allocationEntryService;

  Future<void> getAllocationEntries({
    required String accountingEventUlid,
  }) async {
    emit(const GetAllocationEntriesState.loading());
    try {
      final entries = await _allocationEntryService.list(
        includes: [
          'expenseCategory',
          'member',
          'accountingEvent',
          'accountingEvent.refunds',
          'accountingEvent.latestRefund',
          'receipts',
        ],
        filters: {
          'accounting_event_ulid': accountingEventUlid,
        },
      );

      if (entries.isEmpty) {
        emit(const GetAllocationEntriesState.empty());
      } else {
        emit(GetAllocationEntriesState.loaded(entries: entries));
      }
    } on Failure catch (e) {
      emit(GetAllocationEntriesState.error(e.message));
    } catch (e) {
      emit(GetAllocationEntriesState.error(e.toString()));
    }
  }

  Future<void> refreshAllocationEntries({
    required String accountingEventUlid,
  }) async {
    await getAllocationEntries(accountingEventUlid: accountingEventUlid);
  }
}
