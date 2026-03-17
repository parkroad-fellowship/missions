import 'package:app/models/remote/content/prf_faq.dart';
import 'package:app/services/api/mission_faq_service.dart';
import 'package:app/services/local_storage/isar/_base_local_db_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class FaqResourceCubit extends ResourceCubit<PRFFaq> {
  FaqResourceCubit({
    required MissionFaqService missionFaqService,
    BaseLocalDBService<PRFFaq, dynamic>? dbService,
  }) : super(service: missionFaqService, dbService: dbService);

  @override
  List<String> get defaultIncludes => ['missionFaqCategory'];

  @override
  int? get defaultLimit => 500;
}
