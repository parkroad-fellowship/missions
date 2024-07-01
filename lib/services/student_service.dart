import 'package:app/models/remote/prf_faq.dart';
import 'package:app/utils/_index.dart';

abstract class StudentService {
  Future<List<PRFFaq>> getFaqs();
}

class StudentServiceImpl implements StudentService {
  final _networkUtil = NetworkUtil();
  @override
  Future<List<PRFFaq>> getFaqs() async {
    try {
      final res = await _networkUtil.getReq(
        '/mission-faqs',
      );

      return PRFFaqResponse.fromJson(res).data;
    } catch (e) {
      rethrow;
    }
  }
}
