import 'package:app/enums/expense/prf_approval_status.dart';
import 'package:app/models/remote/expense/prf_requisition.dart';
import 'package:app/services/api/requisition_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class RequisitionResourceCubit extends ResourceCubit<PRFRequisition, Null> {
  RequisitionResourceCubit({
    required RequisitionService requisitionService,
  }) : super(service: requisitionService);

  @override
  List<String> get defaultIncludes => ['requisitionItems.expenseCategory'];

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
}
