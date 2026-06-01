import 'package:app/models/remote/content/prf_faq.dart';
import 'package:app/services/api/mission_faq_service.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class FaqResourceCubit extends ResourceCubit<PRFFaq> {
  FaqResourceCubit({
    required MissionFaqService missionFaqService,
    required HiveService hiveService,
  }) : super(service: missionFaqService, dbService: hiveService.faqs);

  @override
  List<String> get defaultIncludes => ['missionFaqCategory'];

  @override
  Future<List<PRFFaq>> loadCachedList({
    Map<String, dynamic>? filters,
  }) {
    return dbService.list();
  }
}
