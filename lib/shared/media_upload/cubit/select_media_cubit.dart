import 'package:app/enums/prf_media_model.dart';
import 'package:app/enums/prf_media_type.dart';
import 'package:app/models/remote/common/failure.dart';
import 'package:app/models/remote/media/prf_media_dto.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:app/services/media/media_service.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'select_media_cubit.freezed.dart';
part 'select_media_state.dart';

class SelectMediaCubit extends Cubit<SelectMediaState> {
  SelectMediaCubit({
    required MediaService mediaService,
    required IsarService isarService,
  }) : super(const SelectMediaState.initial()) {
    _mediaService = mediaService;
    _isarService = isarService;
  }

  late MediaService _mediaService;
  late IsarService _isarService;

  Future<void> selectMedia({
    required BuildContext context,
    required String modelUlid,
    required PRFMediaModel model,
    required PRFMediaType mediaType,
    List<PRFMediaDTO> previousMedia = const [],
  }) async {
    try {
      emit(const SelectMediaState.loading());

      final media = await _mediaService.getAssets(
        context,
        modelUlid: modelUlid,
        model: model,
        mediaType: mediaType,
      );

      final items = [...previousMedia, ...media];

      await _isarService.mediaUploads.persistEntities(media);

      if (items.isEmpty) {
        emit(const SelectMediaState.empty());
      } else {
        emit(SelectMediaState.loaded(media: items));
      }
    } on Failure catch (f) {
      emit(SelectMediaState.error(f.message));
    } catch (e) {
      emit(SelectMediaState.error(e.toString()));
    }
  }

  Future<void> selectMediaWithSource({
    required BuildContext context,
    required String modelUlid,
    required PRFMediaModel model,
    required PRFMediaType mediaType,
    List<PRFMediaDTO> previousMedia = const [],
  }) async {
    try {
      emit(const SelectMediaState.loading());

      final media = await _mediaService.pickMediaWithSource(
        context,
        modelUlid: modelUlid,
        model: model,
        mediaType: mediaType,
      );

      final items = [...previousMedia, ...media];

      await _isarService.mediaUploads.persistEntities(media);

      if (items.isEmpty) {
        emit(const SelectMediaState.empty());
      } else {
        emit(SelectMediaState.loaded(media: items));
      }
    } on Failure catch (f) {
      emit(SelectMediaState.error(f.message));
    } catch (e) {
      emit(SelectMediaState.error(e.toString()));
    }
  }

  Future<void> captureFromCamera({
    required BuildContext context,
    required String modelUlid,
    required PRFMediaModel model,
    required PRFMediaType mediaType,
    List<PRFMediaDTO> previousMedia = const [],
  }) async {
    try {
      emit(const SelectMediaState.loading());

      final media = await _mediaService.captureFromCamera(
        context,
        modelUlid: modelUlid,
        model: model,
        mediaType: mediaType,
      );

      if (media != null) {
        await _isarService.mediaUploads.persistEntity(media);

        final items = [...previousMedia, media];
        emit(SelectMediaState.loaded(media: items));
      } else {
        // User cancelled or no media captured
        emit(SelectMediaState.loaded(media: previousMedia));
      }
    } on Failure catch (f) {
      emit(SelectMediaState.error(f.message));
    } catch (e) {
      emit(SelectMediaState.error(e.toString()));
    }
  }

  Future<void> selectDocuments({
    required String modelUlid,
    required PRFMediaModel model,
    List<PRFMediaDTO> previousMedia = const [],
  }) async {
    try {
      emit(const SelectMediaState.loading());

      final media = await _mediaService.getDocuments(
        modelUlid: modelUlid,
        model: model,
      );

      await _isarService.mediaUploads.persistEntities(media);

      final items = [...previousMedia, ...media];

      if (items.isEmpty) {
        emit(const SelectMediaState.empty());
      } else {
        emit(SelectMediaState.loaded(media: items));
      }
    } on Failure catch (f) {
      emit(SelectMediaState.error(f.message));
    } catch (e) {
      emit(SelectMediaState.error(e.toString()));
    }
  }

  void clearMedia() {
    emit(const SelectMediaState.loaded(media: []));
  }
}
