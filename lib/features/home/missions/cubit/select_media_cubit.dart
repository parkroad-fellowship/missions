import 'package:app/enums/prf_media_model.dart';
import 'package:app/models/remote/prf_media_dto.dart';
import 'package:app/services/_index.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

part 'select_media_state.dart';
part 'select_media_cubit.freezed.dart';

class SelectMediaCubit extends Cubit<SelectMediaState> {
  SelectMediaCubit({
    required MediaService mediaService,
    required LocalDBService localDBService,
  }) : super(const SelectMediaState.initial()) {
    _mediaService = mediaService;
    _localDBService = localDBService;
  }

  late MediaService _mediaService;
  late LocalDBService _localDBService;

  Future<void> selectMedia({
    required BuildContext context,
    required String modelUlid,
    required PRFMediaModel model,
    required RequestType mediaType,
    List<PRFMediaDTO> previousMedia = const [],
  }) async {
    final media = await _mediaService.getAssets(
      context,
      modelUlid: modelUlid,
      model: model,
      mediaType: mediaType,
    );

    await _localDBService.persistMediaUploads(mediaDTOs: media);

    emit(SelectMediaState.loaded(media: [...previousMedia, ...media]));
  }

  Future<void> selectAudioFiles({
    required String modelUlid,
    required PRFMediaModel model,
    List<PRFMediaDTO> previousMedia = const [],
  }) async {
    try {
      final media = await _mediaService.getAudioFiles(
        modelUlid: modelUlid,
        model: model,
      );
      emit(SelectMediaState.loaded(media: [...previousMedia, ...media]));
    } catch (e) {
      // emit(SelectMediaState.error(e.toString()));
    }
  }

  void clearMedia() {
    emit(const SelectMediaState.loaded(media: []));
  }
}
