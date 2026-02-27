import 'package:app/di/di_container.dart';
import 'package:app/services/_index.dart';

mixin TimezoneMixin {
  String get timezone => getIt<HiveService>().auth.timezone;
}
