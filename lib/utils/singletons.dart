import 'package:app/services/_index.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class Singletons {
  static void setup() {
    getIt.registerSingleton<HiveService>(HiveServiceImplementation());
  }

  static List<BlocProvider> registerCubits() {
    return <BlocProvider>[];
  }
}
