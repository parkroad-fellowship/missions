import 'package:app/features/home/faqs/cubit/faq_category_resource_cubit.dart';
import 'package:app/features/home/faqs/cubit/faq_resource_cubit.dart';
import 'package:app/features/home/student_enquiries/cubit/enquiry_reply_resource_cubit.dart';
import 'package:app/features/home/student_enquiries/cubit/enquiry_resource_cubit.dart';
import 'package:app/services/_index.dart';
import 'package:app/services/api/mission_faq_category_service.dart';
import 'package:app/services/api/mission_faq_service.dart';
import 'package:app/services/api/student_enquiry_reply_service.dart';
import 'package:app/services/api/student_enquiry_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

/// Enquiries module for registering FAQ and enquiry-related services & cubits.
///
/// Includes:
/// - FAQ services
/// - Student enquiry services
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
          dbService: getIt<IsarService>().faqs,
        ),
      ),
      BlocProvider<FaqCategoryResourceCubit>(
        create: (context) => FaqCategoryResourceCubit(
          missionFaqCategoryService: getIt(),
          dbService: getIt<IsarService>().faqCategories,
        ),
      ),
      BlocProvider<EnquiryResourceCubit>(
        create: (context) => EnquiryResourceCubit(
          studentEnquiryService: getIt(),
          dbService: getIt<IsarService>().studentEnquiries,
        ),
      ),
      BlocProvider<EnquiryReplyResourceCubit>(
        create: (context) => EnquiryReplyResourceCubit(
          studentEnquiryReplyService: getIt(),
          hiveService: getIt(),
          dbService: getIt<IsarService>().studentEnquiryReplies,
        ),
      ),
    ];
  }
}
