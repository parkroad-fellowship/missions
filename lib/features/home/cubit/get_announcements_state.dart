part of 'get_announcements_cubit.dart';

@freezed
class GetAnnouncementsState with _$GetAnnouncementsState {
  const factory GetAnnouncementsState.initial() = _Initial;
  const factory GetAnnouncementsState.loading() = _Loading;
  const factory GetAnnouncementsState.loaded({
    required bool isEmpty,
  }) = _Loaded;
  const factory GetAnnouncementsState.error(String message) = _Error;
}
