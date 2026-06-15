import 'package:app/services/media/media_service.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'download_file_cubit.freezed.dart';
part 'download_file_state.dart';

class DownloadFileCubit extends Cubit<DownloadFileState> {
  DownloadFileCubit({required MediaService mediaService})
    : super(const DownloadFileState.initial()) {
    _mediaService = mediaService;
  }

  late MediaService _mediaService;

  Future<void> downloadFile(String downloadUrl) async {
    try {
      emit(const DownloadFileState.loading());
      await _mediaService.downloadFile(downloadUrl);
      emit(const DownloadFileState.loaded());
    } catch (e) {
      emit(DownloadFileState.error(e.toString()));
    }
  }
}
