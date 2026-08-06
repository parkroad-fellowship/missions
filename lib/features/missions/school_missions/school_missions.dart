import 'package:app/di/di_container.dart';
import 'package:app/features/missions/cubit/school_details_resource_cubit.dart';
import 'package:app/features/missions/school_missions/_handset.dart';
import 'package:app/features/missions/school_missions/_tablet.dart';
import 'package:app/services/api/school_service.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

@RoutePage()
class SchoolPastMissionsPage extends StatelessWidget {
  const SchoolPastMissionsPage({
    @PathParam('schoolUlid') required this.schoolUlid,
    super.key,
  });

  final String schoolUlid;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SchoolDetailsResourceCubit>(
      create: (_) => SchoolDetailsResourceCubit(
        schoolService: getIt<SchoolService>(),
        hiveService: getIt<HiveService>(),
      )..loadSchool(schoolUlid: schoolUlid),
      child: PRFAdaptive(
        builder: (context, _) => SchoolMissionsHandset(schoolUlid: schoolUlid),
        handset: (context) => SchoolMissionsHandset(schoolUlid: schoolUlid),
        tablet: (context) => SchoolMissionsTablet(schoolUlid: schoolUlid),
      ),
    );
  }
}
