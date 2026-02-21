import 'package:app/models/remote/common/failure.dart';
import 'package:app/services/api/soul_service.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_soul_cubit.freezed.dart';
part 'delete_soul_state.dart';

class DeleteSoulCubit extends Cubit<DeleteSoulState> {
  DeleteSoulCubit({
    required SoulService soulService,
    required IsarService isarService,
  }) : super(const DeleteSoulState.initial()) {
    _soulService = soulService;
    _isarService = isarService;
  }

  late SoulService _soulService;
  late IsarService _isarService;

  Future<void> deleteSoul({
    required String soulUlid,
  }) async {
    emit(const DeleteSoulState.loading());
    try {
      await _soulService.delete(ulid: soulUlid);
      await _isarService.souls.deleteByKey(soulUlid);
      emit(const DeleteSoulState.loaded());
    } on Failure catch (e) {
      emit(DeleteSoulState.error(e.message));
    } catch (e) {
      emit(DeleteSoulState.error(e.toString()));
    }
  }
}
