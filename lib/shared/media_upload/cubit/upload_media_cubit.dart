import 'package:app/models/remote/common/failure.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:app/services/media/media_service.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';

part 'upload_media_cubit.freezed.dart';
part 'upload_media_state.dart';

class UploadMediaCubit extends Cubit<UploadMediaState> {
  UploadMediaCubit({
    required MediaService mediaService,
    required IsarService isarService,
    required HiveService hiveService,
  }) : super(const UploadMediaState.initial()) {
    _mediaService = mediaService;
    _isarService = isarService;
    _hiveService = hiveService;
  }

  late MediaService _mediaService;
  late IsarService _isarService;
  late HiveService _hiveService;

  Future<void> uploadMedia() async {
    emit(const UploadMediaState.loading());
    try {
      final imageDTOs = await _isarService.mediaUploads.getAllFuture();
      Logger().d(imageDTOs);
      for (final imageDTO in imageDTOs) {
        await _mediaService.uploadFile(
          imageDTO: imageDTO,
          memberUlid: _hiveService.retrieveMember()!.ulid,
        );
        await _isarService.mediaUploads.deleteByKeys(
          imageDTO.modelUlid,
          imageDTO.path,
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
