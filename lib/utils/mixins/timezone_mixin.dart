import 'package:app/services/_index.dart';
import 'package:app/utils/singletons.dart';

mixin TimezoneMixin {
  String get timezone => getIt<HiveService>().timezone;
}
