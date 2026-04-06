import 'package:app/enums/member/prf_institution_type.dart';
import 'package:app/enums/member/prf_responsible_desk.dart';
import 'package:app/enums/mission/prf_mission_role.dart';
import 'package:app/enums/mission/prf_mission_status.dart';
import 'package:app/enums/mission/prf_mission_subscription_status.dart';
import 'package:app/enums/mission/prf_soul_decision_type.dart';
import 'package:app/models/remote/common/auth.dart';
import 'package:app/models/remote/course/prf_school.dart';
import 'package:app/models/remote/course/prf_school_term.dart';
import 'package:app/models/remote/course/prf_spiritual_year.dart';
import 'package:app/models/remote/expense/prf_accounting_event.dart';
import 'package:app/models/remote/expense/prf_expense_category.dart';
import 'package:app/models/remote/expense/prf_refund.dart';
import 'package:app/models/remote/media/prf_media.dart';
import 'package:app/models/remote/media/prf_weather_forecast.dart';
import 'package:app/models/remote/member/prf_class_group.dart';
import 'package:app/models/remote/member/prf_contact.dart';
import 'package:app/models/remote/member/prf_contact_type.dart';
import 'package:app/models/remote/member/prf_group.dart';
import 'package:app/models/remote/member/prf_group_member.dart';
import 'package:app/models/remote/member/prf_member.dart';
import 'package:app/models/remote/member/prf_membership.dart';
import 'package:app/models/remote/member/prf_student.dart';
import 'package:app/models/remote/metadata/prf_church.dart';
import 'package:app/models/remote/metadata/prf_marital_status.dart';
import 'package:app/models/remote/metadata/prf_profession.dart';
import 'package:app/models/remote/mission/prf_mission.dart';
import 'package:app/models/remote/mission/prf_mission_subscription.dart';
import 'package:app/models/remote/mission/prf_mission_type.dart';
import 'package:app/models/remote/payment/prf_payment_type.dart';
import 'package:app/models/remote/prayer/prf_soul.dart';
import 'package:hive_ce/hive.dart';

@GenerateAdapters(
  [
    AdapterSpec<PRFUser>(),
    AdapterSpec<PRFInstitutionType>(),
    AdapterSpec<PRFResponsibleDesk>(),
    AdapterSpec<PRFMissionRole>(),
    AdapterSpec<PRFMissionStatus>(),
    AdapterSpec<PRFMissionSubscriptionStatus>(),
    AdapterSpec<PRFSoulDecisionType>(),
    AdapterSpec<PRFRole>(),
    AdapterSpec<PRFPermission>(),
    AdapterSpec<PRFStudent>(),
    AdapterSpec<PRFMember>(),
    AdapterSpec<PRFGroupMember>(),
    AdapterSpec<PRFGroup>(),
    AdapterSpec<PRFMembership>(),
    AdapterSpec<PRFSpiritualYear>(),
    AdapterSpec<PRFMaritalStatus>(),
    AdapterSpec<PRFProfession>(),
    AdapterSpec<PRFChurch>(),
    AdapterSpec<PRFMedia>(),
    AdapterSpec<PRFClassGroupResponse>(),
    AdapterSpec<PRFClassGroup>(),
    AdapterSpec<PRFSoulResponse>(),
    AdapterSpec<PRFSoul>(),
    AdapterSpec<PRFMission>(),
    AdapterSpec<PRFMissionSubscription>(),
    AdapterSpec<PRFMissionType>(),
    AdapterSpec<PRFSchool>(),
    AdapterSpec<PRFSchoolTerm>(),
    AdapterSpec<PRFContact>(),
    AdapterSpec<PRFContactType>(),
    AdapterSpec<PRFWeatherForecast>(),
    AdapterSpec<PRFTemperature>(),
    AdapterSpec<PRFVisibility>(),
    AdapterSpec<PRFPrecipitationProbability>(),
    AdapterSpec<PRFHumidity>(),
    AdapterSpec<PRFAccountingEvent>(),
    AdapterSpec<PRFRefund>(),
    AdapterSpec<PRFExpenseCategoryResponse>(),
    AdapterSpec<PRFExpenseCategory>(),
    AdapterSpec<PRFPaymentTypeResponse>(),
    AdapterSpec<PRFPaymentType>(),
  ],
  reservedTypeIds: {4},
)
part 'hive_adapters.g.dart';
