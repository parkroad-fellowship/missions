import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_config.freezed.dart';
part 'remote_config.g.dart';

@freezed
abstract class RemoteConfig with _$RemoteConfig {
  factory RemoteConfig({
    @JsonKey(name: 'version') required String appVersion,
    @JsonKey(name: 'status') required bool isInReview,
  }) = _RemoteConfig;

  factory RemoteConfig.fromJson(Map<String, dynamic> json) =>
      _$RemoteConfigFromJson(json);
}
