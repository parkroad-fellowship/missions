import 'package:app/enums/prf_entry_type.dart';
import 'package:app/models/remote/failure.dart';
import 'package:app/models/remote/prf_allocation_entry_dto.dart';
import 'package:app/services/api/allocation_entry_service.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_allocation_token_entry_state.dart';
part 'add_allocation_token_entry_cubit.freezed.dart';

class AddAllocationTokenEntryCubit extends Cubit<AddAllocationTokenEntryState> {
  AddAllocationTokenEntryCubit({
    required AllocationEntryService allocationEntryService,
    required HiveService hiveService,
  }) : super(const AddAllocationTokenEntryState.initial()) {
    _allocationEntryService = allocationEntryService;
    _hiveService = hiveService;
  }

  late AllocationEntryService _allocationEntryService;
  late HiveService _hiveService;

  Future<void> addAllocationEntry({
    required String accountingEventUlid,
    required PRFEntryType entryType,
    required int unitCost,
    required String narration,
    required String confirmationMessage,
  }) async {
    emit(const AddAllocationTokenEntryState.loading());

    try {
      final member = _hiveService.retrieveMember()!;
      await _allocationEntryService.addToken(
        data: PRFAllocationTokenEntryDTO(
          accountingEventUlid: accountingEventUlid,
          memberUlid: member.ulid,
          entryType: entryType,
          unitCost: unitCost,
          narration: narration,
          confirmationMessage: confirmationMessage,
        ),
      );

      emit(const AddAllocationTokenEntryState.loaded());
    } on Failure catch (f) {
      emit(AddAllocationTokenEntryState.error(f.message));
    } catch (e) {
      emit(AddAllocationTokenEntryState.error(e.toString()));
    }
  }
}
