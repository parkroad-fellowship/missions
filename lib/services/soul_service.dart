import 'package:app/models/remote/prf_soul.dart';
import 'package:app/services/_base_api_service.dart';

class SoulService extends BaseAPIService<PRFSoul> {
  @override
  String get endpoint => '/souls';

  @override
  PRFSoul createFromJson(Map<String, dynamic> json) {
    return PRFSoul.fromJson(json);
  }

  @override
  List<PRFSoul> createListFromResponse(Map<String, dynamic> response) {
    return PRFSoulResponse.fromJson(response).data;
  }
}