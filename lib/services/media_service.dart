import 'package:app/enums/prf_media_model.dart';
import 'package:app/models/remote/prf_image_dto.dart';
import 'package:app/models/remote/prf_media.dart';
import 'package:app/utils/color_pallete.dart';
import 'package:app/utils/network.dart';
import 'package:flutter/widgets.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

abstract class MediaService {
  Future<PRFMedia> uploadFile({
    required PRFImageDTO imageDTO,
  });
  Future<List<PRFImageDTO>> getAssetImages(
    BuildContext context, {
      required String modelUlid,
      required PRFMediaModel model,
    int count = 9,
  });
}

class MediaServiceImpl implements MediaService {
  final _networkUtil = NetworkUtil();

  @override
  Future<PRFMedia> uploadFile({
    required PRFImageDTO imageDTO,
  }) async {
    final url = StringBuffer('/');
    switch (imageDTO.model) {
      case PRFMediaModel.missionPhotos:
      case PRFMediaModel.missionFitChecks:
        url.write('missions/${imageDTO.modelUlid}/media');
    }

    try {
      final res = await _networkUtil.postWithUpload(
        url.toString(),
        field: 'media_file',
        filePath: imageDTO.path,
        body: <String, dynamic>{
          'collection': imageDTO.model.collection,
        },
      );

      return PRFMedia.fromJson(res['data'] as Map<String, dynamic>);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<List<PRFImageDTO>> getAssetImages(
    BuildContext context, {
      required String modelUlid,
      required PRFMediaModel model,
    int count = 9,
  }) async {
    try {
      final assets = await AssetPicker.pickAssets(
        context,
        pickerConfig: AssetPickerConfig(
          themeColor: AppTheme.appTheme().kPrimaryColorV2,
          textDelegate: const EnglishAssetPickerTextDelegate(),
          requestType: RequestType.image,
          maxAssets: count,
        ),
      );

      final uploadAssets = <PRFImageDTO>[];

      if (assets != null) {
        for (final asset in assets) {
          final filePath = (await asset.file)!.path;
          uploadAssets.add(
            PRFImageDTO(
              path: filePath,
              model: model,
              modelUlid: modelUlid,
            ),
          );
        }
      }

      return uploadAssets;
    } catch (_) {
      rethrow;
    }
  }
}
