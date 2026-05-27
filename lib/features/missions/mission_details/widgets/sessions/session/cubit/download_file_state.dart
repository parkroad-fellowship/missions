part of 'download_file_cubit.dart';

@freezed
class DownloadFileState with _$DownloadFileState {
  const factory DownloadFileState.initial() = _Initial;
  const factory DownloadFileState.loading() = _Loading;
  const factory DownloadFileState.loaded() = _Loaded;
  const factory DownloadFileState.error(String message) = _Error;
}
