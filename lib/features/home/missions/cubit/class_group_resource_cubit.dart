import 'package:app/models/remote/member/prf_class_group.dart';
import 'package:app/services/api/class_group_service.dart';
import 'package:app/services/local_storage/isar/_base_local_db_service.dart';
import 'package:app/utils/crud/resource_cubit.dart';

class ClassGroupResourceCubit extends ResourceCubit<PRFClassGroup> {
  ClassGroupResourceCubit({
    required ClassGroupService classGroupService,
    BaseLocalDBService<PRFClassGroup, dynamic>? dbService,
  }) : super(service: classGroupService, dbService: dbService);
}
