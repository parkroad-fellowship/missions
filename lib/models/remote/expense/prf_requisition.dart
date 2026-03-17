import 'package:app/enums/expense/prf_approval_status.dart';
import 'package:app/models/remote/expense/prf_accounting_event.dart';
import 'package:app/models/remote/expense/prf_requisition_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'prf_requisition.freezed.dart';
part 'prf_requisition.g.dart';

@freezed
abstract class PRFRequisition with _$PRFRequisition {
  factory PRFRequisition(
    String ulid,
    @JsonKey(name: 'requisition_date') DateTime requisitionDate,
    @JsonEnum()
    @JsonKey(name: 'approval_status')
    PRFApprovalStatus approvalStatus,
    @JsonKey(name: 'total_amount') int totalAmount,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt, {
    @JsonKey(name: 'requisition_items')
    @Default([])
    List<PRFRequisitionItem> requisitionItems,
    @JsonKey(name: 'approval_notes') String? approvalNotes,
    String? remarks,
    @JsonKey(name: 'accounting_event') PRFAccountingEvent? accountingEvent,
  }) = _PRFRequisition;

  factory PRFRequisition.fromJson(Map<String, dynamic> json) =>
      _$PRFRequisitionFromJson(json);
}

@freezed
abstract class PRFRequisitionResponse with _$PRFRequisitionResponse {
  factory PRFRequisitionResponse(List<PRFRequisition> data) =
      _PRFRequisitionResponse;

  factory PRFRequisitionResponse.fromJson(Map<String, dynamic> json) =>
      _$PRFRequisitionResponseFromJson(json);
}
