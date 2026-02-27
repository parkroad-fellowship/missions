import 'package:app/features/home/faqs/cubit/get_faq_categories_cubit.dart';
import 'package:app/features/home/faqs/cubit/get_faqs_cubit.dart';
import 'package:app/features/home/student_enquiries/cubit/create_student_enquiry_reply_cubit.dart';
import 'package:app/features/home/student_enquiries/cubit/get_enquiries_cubit.dart';
import 'package:app/features/home/student_enquiries/cubit/get_student_enquiry_cubit.dart';
import 'package:app/features/home/student_enquiries/cubit/get_student_enquiry_replies_cubit.dart';
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
      BlocProvider<GetFaqsCubit>(
        create: (context) => GetFaqsCubit(
          missionFaqService: getIt(),
          isarService: getIt(),
        ),
      ),
      BlocProvider<GetFaqCategoriesCubit>(
        create: (context) => GetFaqCategoriesCubit(
          missionFaqCategoryService: getIt(),
          isarService: getIt(),
        ),
      ),
      BlocProvider<GetEnquiriesCubit>(
        create: (context) => GetEnquiriesCubit(
          studentEnquiryService: getIt(),
          isarService: getIt(),
        ),
      ),
      BlocProvider<GetStudentEnquiryCubit>(
        create: (context) => GetStudentEnquiryCubit(
          studentEnquiryService: getIt(),
          isarService: getIt(),
        ),
      ),
      BlocProvider<CreateEnquiryReplyCubit>(
        create: (context) => CreateEnquiryReplyCubit(
          studentEnquiryService: getIt(),
          hiveService: getIt(),
          isarService: getIt(),
        ),
      ),
      BlocProvider<GetEnquiryRepliesCubit>(
        create: (context) => GetEnquiryRepliesCubit(
          studentEnquiryService: getIt(),
          isarService: getIt(),
        ),
      ),
    ];
  }
}
