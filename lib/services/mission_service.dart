import 'dart:convert';

import 'package:app/enums/prf_media_model.dart';
import 'package:app/enums/prf_mission_status.dart';
import 'package:app/enums/prf_mission_subscription_status.dart';
import 'package:app/models/remote/prf_announcement.dart';
import 'package:app/models/remote/prf_expense.dart';
import 'package:app/models/remote/prf_expense_category.dart';
import 'package:app/models/remote/prf_expense_dto.dart';
import 'package:app/models/remote/prf_media.dart';
import 'package:app/models/remote/prf_mission.dart';
import 'package:app/models/remote/prf_mission_expense.dart';
import 'package:app/models/remote/prf_mission_session.dart';
import 'package:app/models/remote/prf_mission_session_dto.dart';
import 'package:app/models/remote/prf_mission_subscription.dart';
import 'package:app/models/remote/prf_mission_subscription_dto.dart';
import 'package:app/models/remote/prf_mission_subscription_update_dto.dart';
import 'package:app/models/remote/prf_prayer_prompt.dart';
import 'package:app/models/remote/prf_prayer_response.dart';
import 'package:app/utils/_index.dart';

abstract class MissionService {
  Future<List<PRFMedia>> getMissionMedia({
    required String missionUlid,
    required PRFMediaModel model,
  });
  
}

class MissionServiceImpl implements MissionService {
  final _networkUtil = NetworkUtil();

  @override
  Future<List<PRFMedia>> getMissionMedia({
    required String missionUlid,
    required PRFMediaModel model,
  }) async {
    try {
      final res = await _networkUtil.getReq(
        '/missions/$missionUlid/media',
        queryParameters: {'collection': model.collection},
      );

      return PRFMediaResponse.fromJson(res).data;
    } catch (e) {
      rethrow;
    }
  }
}
