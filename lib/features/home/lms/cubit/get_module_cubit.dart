import 'package:app/models/remote/failure.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_module_state.dart';
part 'get_module_cubit.freezed.dart';

class GetModuleCubit extends Cubit<GetModuleState> {
  GetModuleCubit({
    required IsarService isarService,
  }) : super(const GetModuleState.initial()) {
    _isarService = isarService;
  }

  late IsarService _isarService;

  Future<void> getModule({
    required String courseModuleUlid,
    bool refresh = false,
  }) async {
    try {
      emit(const GetModuleState.loading());

      await _isarService.courseModules.refreshItemStream(courseModuleUlid);

      emit(const GetModuleState.loaded());
    } on Failure catch (e) {
      emit(GetModuleState.error(e.message));
    } catch (e) {
      emit(GetModuleState.error(e.toString()));
    }
  }
}
