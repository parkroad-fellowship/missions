import 'package:app/features/student_home/faqs/cubit/get_faqs_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FAQPageHandset extends StatefulWidget {
  const FAQPageHandset({super.key});

  @override
  State<FAQPageHandset> createState() => _FAQPageHandsetState();
}

class _FAQPageHandsetState extends State<FAQPageHandset> {
  @override
  void initState() {
    context.read<GetFaqsCubit>().getFaqs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.faq,
          style: CustomTextTheme.customTextTheme().displayLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const SizedBox.shrink(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: BlocBuilder<GetFaqsCubit, GetFaqsState>(
          builder: (context, state) {
            return state.maybeWhen(
              orElse: () => const Center(child: CircularProgressIndicator()),
              error: (message) => Center(child: Text(message)),
              loaded: (faqs) {
                if (faqs.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () => context.read<GetFaqsCubit>().getFaqs(),
                    child: Column(
                      children: [
                        const Spacer(),
                        const Icon(
                          Icons.directions_walk,
                        ),
                        Center(
                          child: Text(
                            l10n.noFaqs,
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                l10n.pleaseWait,
                                style: CustomTextTheme.customTextTheme()
                                    .displayLarge!
                                    .copyWith(
                                      color:
                                          AppTheme.appTheme().kPrimaryColorV2,
                                      fontSize: 14,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () => context.read<GetFaqsCubit>().getFaqs(),
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: faqs.length,
                    itemBuilder: (context, index) {
                      final faq = faqs[index];
                      return ExpansionTile(
                        initiallyExpanded: true,
                        trailing: Icon(
                          Icons.keyboard_arrow_right,
                          color: AppTheme.appTheme().kDullGreyColor,
                          size: 24,
                        ),
                        title: Text(
                          faq.question.toUpperCase(),
                          style: CustomTextTheme.customTextTheme()
                              .headlineSmall!
                              .copyWith(
                                color:
                                    AppTheme.appTheme().kAccent2BackgroundColor,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        children: [
                          ListTile(
                            dense: true,
                            minLeadingWidth: 10.5,
                            contentPadding: const EdgeInsets.only(left: 20),
                            visualDensity: VisualDensity.compact,
                            // onTap: () => context.router.push(
                            //   MissionsDetailsRoute(mission: mission),
                            // ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  faq.answer,
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
            );
          },
        ),
      ),
    );
  }
}
