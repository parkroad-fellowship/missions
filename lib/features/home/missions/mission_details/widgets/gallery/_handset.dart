import 'package:app/features/home/missions/cubit/get_mission_questions_cubit.dart';
import 'package:app/features/home/missions/cubit/upload_media_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/prf_mission_question.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GalleryViewHandset extends StatefulWidget {
  const GalleryViewHandset({
    required this.missionUlid,
    super.key,
  });

  final String missionUlid;

  @override
  State<GalleryViewHandset> createState() => _GalleryViewHandsetState();
}

class _GalleryViewHandsetState extends State<GalleryViewHandset> {
  String get missionUlid => widget.missionUlid;

  @override
  void initState() {
    context
        .read<GetMissionQuestionsCubit>()
        .getMissionQuestions(missionUlid: missionUlid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return RefreshIndicator(
      onRefresh: () async {
        //  TODO: Fetch images
      },
      child: CustomScrollView(
        slivers: [
          // Progress indicator for images uploading in the background
          BlocConsumer<UploadMediaCubit, UploadMediaState>(
            listener: (context, state) {
              state.mapOrNull(
                loaded: (_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.doneUploading),
                    ),
                  );
                },
                error: (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(error.message),
                    ),
                  );
                },
              );
            },
            builder: (context, state) {
              return SliverToBoxAdapter(
                child: state.maybeWhen(
                  loading: () => const LinearProgressIndicator(),
                  orElse: () => const SizedBox.shrink(),
                ),
              );
            },
          ),
          // Gallery
          SliverToBoxAdapter(child: Text('Gallery')),
          // BlocBuilder<GetMissionQuestionsCubit, GetMissionQuestionsState>(
          //   builder: (context, state) {
          //     return state.map(
          //       loading: (_) => const SliverToBoxAdapter(
          //         child: Center(
          //           child: CircularProgressIndicator(),
          //         ),
          //       ),
          //       loaded: (questions) {
          //         return SliverPadding(
          //           padding: EdgeInsets.symmetric(
          //             horizontal: 16.w,
          //             vertical: 16.h,
          //           ),
          //           sliver: SliverGrid(
          //             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //               crossAxisCount: 3,
          //               crossAxisSpacing: 16.w,
          //               mainAxisSpacing: 16.h,
          //             ),
          //             delegate: SliverChildBuilderDelegate(
          //               (context, index) {
          //                 final question = questions[index];
          //                 return Animate(
          //                   duration: Duration(milliseconds: 500),
          //                   animate: true,
          //                   endOffset: Offset(0, 0),
          //                   startOffset: Offset(0, 0.5),
          //                   child: Image.network(
          //                     question.mediaUrl,
          //                     fit: BoxFit.cover,
          //                   ),
          //                 );
          //               },
          //               childCount: questions.length,
          //             ),
          //           ),
          //         );
          //       },
          //       error: (error) => SliverToBoxAdapter(
          //         child: Center(
          //           child: Text(error.message),
          //         ),
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}
