import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_weather_forecast.freezed.dart';
part 'prf_weather_forecast.g.dart';

@freezed
class PRFWeatherForecast with _$PRFWeatherForecast {
  factory PRFWeatherForecast(
    String ulid,
    @JsonKey(name: 'forecast_date') String forecastDate,
    @JsonKey(name: 'weather_code_description') String weatherCodeDescription,
    @JsonKey(name: 'dressing_recommendations') String dressingRecommendations,
    @JsonKey(name: 'activity_recommendations') String activityRecommendations,
    PRFTemperature temperature,
    PRFVisibility visibility,
    @JsonKey(name: 'precipitation_probability')
    PRFPrecipitationProbability precipitationProbability,
    PRFHumidity humidity,
  ) = _PRFWeatherForecast;

  factory PRFWeatherForecast.fromJson(Map<String, dynamic> json) =>
      _$PRFWeatherForecastFromJson(json);
}

@freezed
class PRFTemperature with _$PRFTemperature {
  factory PRFTemperature(
    @JsonKey(name: 'apparent_avg') String apparentAvg,
    @JsonKey(name: 'apparent_max') String apparentMax,
    @JsonKey(name: 'apparent_min') String apparentMin,
    String avg,
    String max,
    String min,
  ) = _PRFTemperature;

  factory PRFTemperature.fromJson(Map<String, dynamic> json) =>
      _$PRFTemperatureFromJson(json);
}

@freezed
class PRFVisibility with _$PRFVisibility {
  factory PRFVisibility(
    String avg,
    String max,
    String min,
  ) = _PRFVisibility;

  factory PRFVisibility.fromJson(Map<String, dynamic> json) =>
      _$PRFVisibilityFromJson(json);
}

@freezed
class PRFPrecipitationProbability with _$PRFPrecipitationProbability {
  factory PRFPrecipitationProbability(
    String avg,
    String max,
    String min,
  ) = _PRFPrecipitationProbability;

  factory PRFPrecipitationProbability.fromJson(Map<String, dynamic> json) =>
      _$PRFPrecipitationProbabilityFromJson(json);
}

@freezed
class PRFHumidity with _$PRFHumidity {
  factory PRFHumidity(
    String avg,
    String max,
    String min,
  ) = _PRFHumidity;

  factory PRFHumidity.fromJson(Map<String, dynamic> json) =>
      _$PRFHumidityFromJson(json);
}
