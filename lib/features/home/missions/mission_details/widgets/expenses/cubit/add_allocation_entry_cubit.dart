import 'package:app/enums/mission/prf_entry_type.dart';
import 'package:app/enums/payment/prf_charge_type.dart';
import 'package:app/models/remote/common/failure.dart';
import 'package:app/models/remote/expense/prf_allocation_entry_dto.dart';
import 'package:app/models/remote/media/prf_media_dto.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';

part 'add_allocation_entry_cubit.freezed.dart';
part 'add_allocation_entry_state.dart';

class AddAllocationEntryCubit extends Cubit<AddAllocationEntryState> {
  AddAllocationEntryCubit({
    required AllocationEntryService allocationEntryService,
    required HiveService hiveService,
    required MediaService mediaService,
  }) : super(const AddAllocationEntryState.initial()) {
    _allocationEntryService = allocationEntryService;
    _hiveService = hiveService;
    _mediaService = mediaService;
  }

  late AllocationEntryService _allocationEntryService;
  late HiveService _hiveService;
  late MediaService _mediaService;

  Future<void> addAllocationEntry({
    required String accountingEventUlid,
    required String expenseCategoryUlid,
    required PRFEntryType entryType,
    required PRFChargeType chargeType,
    required int charge,
    required int unitCost,
    required int quantity,
    required String narration,
    required String confirmationMessage,
    required List<PRFMediaDTO> receiptDTOs,
  }) async {
    emit(const AddAllocationEntryState.loading());

    try {
      final member = _hiveService.retrieveMember()!;
      final allocationEntry = await _allocationEntryService.create(
        data: PRFAllocationEntryDTO(
          accountingEventUlid: accountingEventUlid,
          expenseCategoryUlid: expenseCategoryUlid,
          memberUlid: member.ulid,
          entryType: entryType,
          chargeType: chargeType,
          charge: charge,
          unitCost: unitCost,
          quantity: quantity,
          narration: narration,
          confirmationMessage: confirmationMessage,
        ).toJson(),
      );

      Logger().d(receiptDTOs);
      for (final receiptDTO in receiptDTOs) {
        await _mediaService.uploadFile(
          imageDTO: receiptDTO.copyWith(
            modelUlid: allocationEntry.ulid,
          ),
        );
      }

      emit(const AddAllocationEntryState.loaded());
    } on Failure catch (f) {
      emit(AddAllocationEntryState.error(f.message));
    } catch (e) {
      emit(AddAllocationEntryState.error(e.toString()));
    }
  }

  void resetState() {
    emit(const AddAllocationEntryState.initial());
  }
}
