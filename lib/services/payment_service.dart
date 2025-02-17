import 'dart:convert';

import 'package:app/models/remote/prf_payment.dart';
import 'package:app/models/remote/prf_payment_dto.dart';
import 'package:app/models/remote/prf_payment_type.dart';
import 'package:app/utils/_index.dart';

abstract class PaymentService {
  Future<List<PRFPayment>> getPayments({
    required String memberUlid,
    required String include,
  });
  Future<List<PRFPaymentType>> getPaymentTypes();
  Future<PRFPayment> addPayment({required PRFPaymentDTO paymentDTO});
}

class PaymentServiceImpl implements PaymentService {
  final _networkUtil = NetworkUtil();

  @override
  Future<PRFPayment> addPayment({required PRFPaymentDTO paymentDTO}) async {
    try {
      final res = await _networkUtil.postReq(
        '/payments',
        body: json.encode(paymentDTO.toJson()),
      );

      return PRFPayment.fromJson(res['data'] as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PRFPayment>> getPayments({
    required String memberUlid,
    required String include,
  }) async {
    try {
      final res = await _networkUtil.getReq(
        '/payments',
        queryParameters: {
          'filter[member_ulid]': memberUlid,
          'include': include,
        },
      );

      return PRFPaymentResponse.fromJson(res).data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PRFPaymentType>> getPaymentTypes() async {
    try {
      final res = await _networkUtil.getReq('/payment-types');

      return PRFPaymentTypeResponse.fromJson(res).data;
    } catch (e) {
      rethrow;
    }
  }
}
