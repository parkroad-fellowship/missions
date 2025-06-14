import 'dart:convert';
import 'dart:io';

import 'package:app/enums/prf_media_model.dart';
import 'package:app/models/remote/failure.dart';
import 'package:app/models/remote/prf_media.dart';
import 'package:app/models/remote/prf_media_dto.dart';
import 'package:app/utils/_index.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:permission_handler/permission_handler.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

abstract class MediaService {
  Future<PRFMedia> uploadFile({required PRFMediaDTO imageDTO});
  Future<List<PRFMediaDTO>> getAssets(
    BuildContext context, {
    required String modelUlid,
    required PRFMediaModel model,
    required RequestType mediaType,
    int count = 9,
  });
  Future<List<PRFMediaDTO>> getAudioFiles({
    required String modelUlid,
    required PRFMediaModel model,
  });

  Future<void> initDownloader();
  Future<void> downloadFile(String downloadURL);
}

class MediaServiceImpl implements MediaService {
  final _networkUtil = NetworkUtil();

  @override
  Future<PRFMedia> uploadFile({required PRFMediaDTO imageDTO}) async {
    final url = StringBuffer('/');
    Logger().d(imageDTO);

    switch (imageDTO.model) {
      case PRFMediaModel.missionPhotos:
      case PRFMediaModel.missionFitChecks:
        url.write('missions');
      case PRFMediaModel.missionSessionAudios:
        url.write('mission-sessions');
      case PRFMediaModel.eventPhotos:
        url.write('events');
      case PRFMediaModel.memberProfilePictures:
        url.write('members');
    }

    url.write('/${imageDTO.modelUlid}/media');

    try {
      // Upload the actual file to Azure to have their servers handle the load
      final azureStorage = AzureStorage.parse(
        PRFSuperAppConfig.instance!.values.azureConnString,
      );

      final filePath = 'prf-media-upload/${Misc.getFileName(imageDTO.path)}';

      await azureStorage.putBlob(
        filePath,
        bodyBytes: File(imageDTO.path).readAsBytesSync(),
      );

      // Upload the reference to our server
      final res = await _networkUtil.postReq(
        url.toString(),
        body: json.encode({
          'media_file_storage_path': filePath,
          'collection': imageDTO.model.collection,
        }),
        apiVersion: 'v2',
      );

      return PRFMedia.fromJson(res['data'] as Map<String, dynamic>);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<List<PRFMediaDTO>> getAssets(
    BuildContext context, {
    required String modelUlid,
    required PRFMediaModel model,
    required RequestType mediaType,
    int count = 9,
  }) async {
    try {
      final assets = await AssetPicker.pickAssets(
        context,
        pickerConfig: AssetPickerConfig(
          themeColor: Theme.of(context).colorScheme.primary,
          textDelegate: const EnglishAssetPickerTextDelegate(),
          requestType: mediaType,
          maxAssets: count,
        ),
      );

      final uploadAssets = <PRFMediaDTO>[];

      if (assets != null) {
        for (final asset in assets) {
          final filePath = (await asset.file)!.path;
          uploadAssets.add(
            PRFMediaDTO(
              path: filePath,
              model: model,
              modelUlid: modelUlid,
              name: Misc.getFileName(filePath),
            ),
          );
        }
      }

      return uploadAssets;
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<List<PRFMediaDTO>> getAudioFiles({
    required String modelUlid,
    required PRFMediaModel model,
  }) async {
    try {
      final result = await FilePicker.platform
          .pickFiles(
            allowMultiple: true,
            type: FileType.custom,
            allowedExtensions: ['mp3', 'aac', 'ogg', 'mp4', 'wav', 'flac'],
          )
          .catchError((dynamic error) {
            if (error is PlatformException &&
                error.code == 'multiple_request') {
              throw Failure(message: 'Another file selection is in progress');
            }
            throw Failure(message: error.toString());
          });

      if (result != null) {
        final filePaths = result.paths;
        final uploadAssets = <PRFMediaDTO>[];
        final appDir = await path_provider.getApplicationDocumentsDirectory();

        try {
          for (final filePath in filePaths) {
            if (filePath != null) {
              final file = File(filePath);
              final fileName = Misc.getFileName(filePath);
              final mediaUploadsDir = '${appDir.path}/media_uploads';
              await Directory(mediaUploadsDir).create(recursive: true);
              final newPath = '$mediaUploadsDir/$fileName';

              await file.copy(newPath);

              uploadAssets.add(
                PRFMediaDTO(
                  path: newPath,
                  model: model,
                  modelUlid: modelUlid,
                  name: fileName,
                ),
              );
            }
          }
          return uploadAssets;
        } catch (e) {
          rethrow;
        }
      }

      return [];
    } catch (e) {
      rethrow;
    } finally {
      await FilePicker.platform.clearTemporaryFiles();
    }
  }

  @override
  Future<void> initDownloader() async {
    await FlutterDownloader.initialize(debug: kDebugMode);
    await FlutterDownloader.registerCallback(callback);
  }

  static void callback(String id, int status, int progress) {
    Logger().d('$id: $status ($progress)');
  }

  @override
  Future<void> downloadFile(String downloadURL) async {
    try {
      await Permission.storage.request();
      late String appDocDir;
      if (Platform.isAndroid) {
        appDocDir = (await path_provider.getExternalStorageDirectory())!.path;
      } else {
        appDocDir =
            (await path_provider.getApplicationDocumentsDirectory())
                .absolute
                .path;
      }

      await FlutterDownloader.enqueue(
        url: downloadURL,
        fileName: Misc.getFileName(downloadURL),
        savedDir: appDocDir,
        saveInPublicStorage: true,
      );
    } on SocketException {
      throw Failure(message: 'Check network connection!');
    } catch (e) {
      Logger().e(e.toString());
      rethrow;
    }
  }
}
