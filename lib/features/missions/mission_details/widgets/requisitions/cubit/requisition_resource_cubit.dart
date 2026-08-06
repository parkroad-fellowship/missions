import 'package:app/enums/expense/prf_approval_status.dart';
import 'package:app/models/remote/expense/prf_requisition.dart';
import 'package:app/services/api/requisition_service.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class RequisitionResourceCubit extends ResourceCubit<PRFRequisition> {
  RequisitionResourceCubit({
    required RequisitionService requisitionService,
    required HiveService hiveService,
  }) : super(service: requisitionService, dbService: hiveService.requisitions);

  @override
  List<String> get defaultIncludes => [
    'requisitionItems.expenseCategory',
    'accountingEvent',
  ];

  Future<void> loadForAccountingEvent({
    required String accountingEventUlid,
  }) async {
    await loadAll(
      filters: {
        'accounting_event_ulid': accountingEventUlid,
        'approval_status': PRFApprovalStatus.approved.apiKey,
      },
    );
  }

  @override
  Future<List<PRFRequisition>> loadCachedList({
    Map<String, dynamic>? filters,
  }) {
    return dbService.filterBy(
      (requisition) => [
        if (filters?['accounting_event_ulid'] != null)
          requisition.accountingEvent?.ulid ==
              filters!['accounting_event_ulid'],
      ],
    );
  }
}
