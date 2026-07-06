// import 'package:app/features/home/student_enquiries/cubit/enquiry_resource_cubit.dart';
// import 'package:app/features/home/student_enquiries/widgets/student_enquiry_filter_header.dart';
// import 'package:app/features/home/student_enquiries/widgets/student_enquiry_preview_card.dart';
// import 'package:app/l10n/l10n.dart';
// import 'package:app/models/remote/enquiry/prf_student_enquiry.dart';
// import 'package:app/utils/crud/resource_state.dart';
// import 'package:app/utils/mixins/timezone_mixin.dart';
// import 'package:app/utils/router/router.dart';
// import 'package:app/utils/router/router.gr.dart';
// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:prf_design/prf_design.dart';

// class StudentEnquiriesPageHandset extends StatefulWidget {
//   const StudentEnquiriesPageHandset({super.key});

//   @override
//   State<StudentEnquiriesPageHandset> createState() =>
//       _StudentEnquiriesPageHandsetState();
// }

// class _StudentEnquiriesPageHandsetState
//     extends State<StudentEnquiriesPageHandset>
//     with TimezoneMixin {
//   bool _selectedReplyStatus = false;

//   @override
//   void initState() {
//     context.read<EnquiryResourceCubit>().loadAll();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final l10n = context.l10n;
//     final theme = Theme.of(context);

//     return Scaffold(
//       backgroundColor: theme.colorScheme.surface,
//       body: Column(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   theme.colorScheme.primary,
//                   theme.colorScheme.primary.withValues(alpha: 0.84),
//                 ],
//               ),
//             ),
//             child: PRFBrandedNavBar(
//               title: l10n.studentQuestions,
//               onBack: () => context.router.popUntilRouteWithPath(
//                 PRFSuperAppRouter.landingRoute,
//               ),
//             ),
//           ),
//           Expanded(
//             child: RefreshIndicator(
//               onRefresh: () => context.read<EnquiryResourceCubit>().loadAll(),
//               child:
//                   BlocBuilder<
//                     EnquiryResourceCubit,
//                     ResourceState<PRFStudentEnquiry>
//                   >(
//                     builder: (context, state) {
//                       final allEnquiries = state.maybeWhen(
//                         listLoaded: (items, _, _) => items,
//                         orElse: () => <PRFStudentEnquiry>[],
//                       );

//                       final unreadCount = allEnquiries
//                           .where((e) => !e.hasReplies)
//                           .length;
//                       final repliedCount = allEnquiries
//                           .where((e) => e.hasReplies)
//                           .length;

//                       return CustomScrollView(
//                         physics: const AlwaysScrollableScrollPhysics(
//                           parent: BouncingScrollPhysics(),
//                         ),
//                         slivers: [
//                           SliverToBoxAdapter(
//                             child: StudentEnquiryFilterHeader(
//                               unreadCount: unreadCount,
//                               repliedCount: repliedCount,
//                               onStatusSelected: (status) {
//                                 setState(() {
//                                   _selectedReplyStatus = status;
//                                 });
//                               },
//                             ),
//                           ),
//                           state.maybeWhen(
//                             listLoading: (_) => const SliverToBoxAdapter(
//                               child: Padding(
//                                 padding: EdgeInsets.symmetric(
//                                   horizontal: PRFSpacingTokens.lg,
//                                 ),
//                                 child: PRFLinearProgressIndicator(),
//                               ),
//                             ),
//                             error: (message, _) => SliverFillRemaining(
//                               hasScrollBody: false,
//                               child: Align(
//                                 alignment: Alignment.topCenter,
//                                 child: PRFEmptyView(
//                                   label: l10n.noQuestions,
//                                   description: message,
//                                 ),
//                               ),
//                             ),
//                             listLoaded: (loadedEnquiries, _, _) {
//                               final enquiries = loadedEnquiries
//                                   .where(
//                                     (e) => e.hasReplies == _selectedReplyStatus,
//                                   )
//                                   .toList();

//                               if (enquiries.isEmpty) {
//                                 return SliverFillRemaining(
//                                   hasScrollBody: false,
//                                   child: Align(
//                                     alignment: Alignment.topCenter,
//                                     child: PRFEmptyView(
//                                       label: l10n.noQuestions,
//                                       description: l10n.pleaseWait,
//                                     ),
//                                   ),
//                                 );
//                               }

//                               return SliverList.separated(
//                                 itemCount: enquiries.length,
//                                 separatorBuilder: (context, index) =>
//                                     const SizedBox(height: PRFSpacingTokens.md),
//                                 itemBuilder: (context, index) {
//                                   final enquiry = enquiries[index];
//                                   return StudentEnquiryPreviewCard(
//                                     enquiry: enquiry,
//                                     timezone: timezone,
//                                     onTap: () => context.router.push(
//                                       StudentEnquiryRepliesRoute(
//                                         enquiryUlid: enquiry.ulid,
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               );
//                             },
//                             orElse: () => const SliverToBoxAdapter(
//                               child: SizedBox.shrink(),
//                             ),
//                           ),
//                           const SliverToBoxAdapter(
//                             child: SizedBox(height: PRFSpacingTokens.xl),
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
