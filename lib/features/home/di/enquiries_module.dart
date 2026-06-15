import 'package:app/features/home/faqs/cubit/faq_category_resource_cubit.dart';
import 'package:app/features/home/faqs/cubit/faq_resource_cubit.dart';
import 'package:app/features/home/student_enquiries/cubit/enquiry_reply_resource_cubit.dart';
import 'package:app/features/home/student_enquiries/cubit/enquiry_resource_cubit.dart';
import 'package:app/services/api/mission_faq_category_service.dart';
import 'package:app/services/api/mission_faq_service.dart';
import 'package:app/services/api/student_enquiry_reply_service.dart';
import 'package:app/services/api/student_enquiry_service.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

/// Feature-owned registrations for FAQs and student enquiries.
class EnquiriesModule {
  static void register(GetIt getIt) {
    getIt
      ..registerSingleton<MissionFaqService>(MissionFaqService())
      ..registerSingleton<MissionFaqCategoryService>(
        MissionFaqCategoryService(),
      )
      ..registerSingleton<StudentEnquiryService>(StudentEnquiryService())
      ..registerSingleton<StudentEnquiryReplyService>(
        StudentEnquiryReplyService(),
      );
  }

  static List<BlocProvider> registerCubits(GetIt getIt) {
    return [
      BlocProvider<FaqResourceCubit>(
        create: (context) => FaqResourceCubit(
          missionFaqService: getIt(),
          hiveService: getIt<HiveService>(),
        ),
      ),
      BlocProvider<FaqCategoryResourceCubit>(
        create: (context) => FaqCategoryResourceCubit(
          missionFaqCategoryService: getIt(),
          hiveService: getIt<HiveService>(),
        ),
      ),
      BlocProvider<EnquiryResourceCubit>(
        create: (context) => EnquiryResourceCubit(
          studentEnquiryService: getIt(),
          hiveService: getIt<HiveService>(),
        ),
      ),
      BlocProvider<EnquiryReplyResourceCubit>(
        create: (context) => EnquiryReplyResourceCubit(
          studentEnquiryReplyService: getIt(),
          hiveService: getIt<HiveService>(),
        ),
      ),
    ];
  }
}
