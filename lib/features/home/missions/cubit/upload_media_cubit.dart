import 'package:app/models/remote/failure.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';

part 'upload_media_state.dart';
part 'upload_media_cubit.freezed.dart';

class UploadMediaCubit extends Cubit<UploadMediaState> {
  UploadMediaCubit({
    required MediaService mediaService,
    required LocalDBService localDBService,
  }) : super(const UploadMediaState.initial()) {
    _mediaService = mediaService;
    _localDBService = localDBService;
  }

  late MediaService _mediaService;
  late LocalDBService _localDBService;

  Future<void> uploadMedia() async {
    emit(const UploadMediaState.loading());
    try {
      final imageDTOs = _localDBService.retrieveMediaUploads();
      Logger().d(imageDTOs);
      for (final imageDTO in imageDTOs) {
        await _mediaService.uploadFile(imageDTO: imageDTO);
        _localDBService.deleteMediaUpload(
          modelUlid: imageDTO.modelUlid,
          path: imageDTO.path,
        );
      }
      emit(const UploadMediaState.loaded());
    } on Failure catch (e) {
      emit(UploadMediaState.error(e.message));
    } catch (e) {
      emit(UploadMediaState.error(e.toString()));
    }
  }
}
