import 'package:app/features/home/giving/cubit/payment_resource_cubit.dart';
import 'package:app/features/home/giving/cubit/payment_type_resource_cubit.dart';
import 'package:app/services/api/payment_service.dart';
import 'package:app/services/api/payment_type_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

/// Payments module for registering payment/giving-related services and cubits.
///
/// Includes:
/// - Payment services
/// - Payment type services
class PaymentsModule {
  static void register(GetIt getIt) {
    getIt
      ..registerSingleton<PaymentService>(PaymentService())
      ..registerSingleton<PaymentTypeService>(PaymentTypeService());
  }

  static List<BlocProvider> registerCubits(GetIt getIt) {
    return [
      BlocProvider<PaymentResourceCubit>(
        create: (context) => PaymentResourceCubit(
          paymentService: getIt(),
          hiveService: getIt(),
        ),
      ),
      BlocProvider<PaymentTypeResourceCubit>(
        create: (context) => PaymentTypeResourceCubit(
          paymentTypeService: getIt(),
        ),
      ),
    ];
  }
}
