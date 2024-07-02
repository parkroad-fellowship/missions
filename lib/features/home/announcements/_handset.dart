import 'package:app/features/home/cubit/get_announcements_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/local/prf_announcement.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnnouncementsPageHandset extends StatefulWidget {
  const AnnouncementsPageHandset({super.key});

  @override
  State<AnnouncementsPageHandset> createState() =>
      _AnnouncementsPageHandsetState();
}

class _AnnouncementsPageHandsetState extends State<AnnouncementsPageHandset> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.announcements,
          style: CustomTextTheme.customTextTheme()
              .displayLarge
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              BlocBuilder<GetAnnouncementsCubit, GetAnnouncementsState>(
                builder: (context, state) => state.maybeWhen(
                  orElse: () => const Center(child: LinearProgressIndicator()),
                  error: (message) => Center(child: Text(message)),
                  loaded: (isEmpty) => isEmpty
                      ? Column(
                          children: [
                            const Icon(
                              Icons.timer,
                            ),
                            Center(
                              child: Text(
                                l10n.noAnnouncements,
                                style: CustomTextTheme.customTextTheme()
                                    .headlineMedium!
                                    .copyWith(
                                      color: AppTheme.appTheme().kDullGreyColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.05,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    l10n.pleaseWaitForOS,
                                    maxLines: 2,
                                    style: CustomTextTheme.customTextTheme()
                                        .displayLarge!
                                        .copyWith(
                                          color: AppTheme.appTheme()
                                              .kPrimaryColorV2,
                                          fontSize: 12,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
              ),
              StreamBuilder<List<PRFLocalAnnouncement>>(
                stream: getIt<LocalDBService>().getAnnouncements(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final announcements = snapshot.data;

                  if (announcements != null && announcements.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return RefreshIndicator(
                    onRefresh: () => context
                        .read<GetAnnouncementsCubit>()
                        .getAnnouncements(),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: announcements!.length,
                      itemBuilder: (context, index) {
                        final announcement = announcements[index];
                        return ExpansionTile(
                          initiallyExpanded: true,
                          title: Text(
                            announcement.title.toUpperCase(),
                            style: CustomTextTheme.customTextTheme()
                                .headlineSmall!
                                .copyWith(
                                  color: AppTheme.appTheme()
                                      .kAccent2BackgroundColor,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          children: [
                            ListTile(
                              dense: true,
                              minLeadingWidth: 10.5,
                              contentPadding: const EdgeInsets.only(left: 20),
                              visualDensity: VisualDensity.compact,
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    announcement.content,
                                    style: CustomTextTheme.customTextTheme()
                                        .bodySmall!
                                        .copyWith(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                  ),
                                  Text(
                                    l10n.publishedAt(
                                      Misc.formatDateTime(
                                        announcement.publishedAt,
                                      ),
                                    ),
                                    style: CustomTextTheme.customTextTheme()
                                        .bodySmall!
                                        .copyWith(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
