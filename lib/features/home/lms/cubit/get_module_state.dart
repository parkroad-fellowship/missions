part of 'get_module_cubit.dart';

@freezed
class GetModuleState with _$GetModuleState {
  const factory GetModuleState.initial() = _Initial;
  const factory GetModuleState.loading() = _Loading;
  const factory GetModuleState.loaded() = _Loaded;
  const factory GetModuleState.error(String message) = _Error;
}
