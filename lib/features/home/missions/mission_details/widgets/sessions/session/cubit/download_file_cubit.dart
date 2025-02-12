import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'download_file_state.dart';
part 'download_file_cubit.freezed.dart';

class DownloadFileCubit extends Cubit<DownloadFileState> {
  DownloadFileCubit({required MediaService mediaService})
      : super(DownloadFileState.initial()) {
    _mediaService = mediaService;
  }

  late MediaService _mediaService;

  Future<void> downloadFile(String downloadUrl) async {
    try {
      emit(DownloadFileState.loading());
      await _mediaService.downloadFile(downloadUrl);
      emit(DownloadFileState.loaded());
    } catch (e) {
      emit(DownloadFileState.error(e.toString()));
    }
  }
}
