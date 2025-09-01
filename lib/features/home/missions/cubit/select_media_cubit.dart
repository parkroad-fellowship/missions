import 'package:app/enums/prf_media_model.dart';
import 'package:app/models/remote/prf_media_dto.dart';
import 'package:app/services/_index.dart';
import 'package:app/services/local_storage/isar/isar_service.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

part 'select_media_state.dart';
part 'select_media_cubit.freezed.dart';

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
    required RequestType mediaType,
    List<PRFMediaDTO> previousMedia = const [],
  }) async {
    final media = await _mediaService.getAssets(
      context,
      modelUlid: modelUlid,
      model: model,
      mediaType: mediaType,
      count: 30,
    );

    await _isarService.mediaUploads.persistEntities(media);

    final items = [...previousMedia, ...media];

    if (items.isEmpty) {
      emit(const SelectMediaState.empty());
    }

    emit(SelectMediaState.loaded(media: items));
  }

  Future<void> selectAudioFiles({
    required String modelUlid,
    required PRFMediaModel model,
    List<PRFMediaDTO> previousMedia = const [],
  }) async {
    final media = await _mediaService.getAudioFiles(
      modelUlid: modelUlid,
      model: model,
    );
    await _isarService.mediaUploads.persistEntities(media);

    final items = [...previousMedia, ...media];

    if (items.isEmpty) {
      emit(const SelectMediaState.empty());
    }

    emit(SelectMediaState.loaded(media: items));
  }

  void clearMedia() {
    emit(const SelectMediaState.loaded(media: []));
  }
}
