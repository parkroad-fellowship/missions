import 'package:app/models/local/faq/prf_faq.dart';
import 'package:app/models/remote/content/prf_faq.dart';
import 'package:app/services/api/mission_faq_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class FaqResourceCubit extends ResourceCubit<PRFFaq, PRFLocalFaq> {
  FaqResourceCubit({
    required MissionFaqService missionFaqService,
    super.dbService,
  }) : super(service: missionFaqService);

  @override
  List<String> get defaultIncludes => ['missionFaqCategory'];

  @override
  int? get defaultLimit => 500;
}
