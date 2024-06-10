part of 'get_class_groups_cubit.dart';

@freezed
class GetClassGroupsState with _$GetClassGroupsState {
  const factory GetClassGroupsState.initial() = _Initial;
  const factory GetClassGroupsState.loading() = _Loading;
  const factory GetClassGroupsState.loaded({
    required List<PRFClassGroup> classGroups,
  }) = _Loaded;
  const factory GetClassGroupsState.error(String message) = _Error;
}
