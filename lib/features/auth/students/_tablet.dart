import 'package:app/features/auth/cubit/register_student_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/auth.dart';
import 'package:app/utils/_index.dart';
import 'package:app/widgets/_index.dart';
import 'package:app/widgets/secondary_button.dart';
import 'package:auto_route/auto_route.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentIntroPageTablet extends StatefulWidget {
  const StudentIntroPageTablet({super.key});

  @override
  State<StudentIntroPageTablet> createState() => _StudentIntroPageTabletState();
}

class _StudentIntroPageTabletState extends State<StudentIntroPageTablet> {
  bool _isLoading = false;
  PRFUser? credentials;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.5,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height * 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    Center(
                      child: ExtendedImage.asset(
                        'assets/images/app-logo.png',
                        height: 200,
                        width: 232,
                      ),
                    ),
                    Align(
                      child: Text(
                        l10n.registerNewStudent,
                        style: PRFText.theme().displayMedium,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Align(
                      child: Text(
                        l10n.studentIntro,
                        style: PRFText.theme().bodySmall,
                      ),
                    ),
                    const SizedBox(height: 16),
                    BlocConsumer<RegisterStudentCubit, RegisterStudentState>(
                      listener: (context, state) {
                        state.maybeWhen(
                          loading:
                              () => setState(() {
                                _isLoading = !_isLoading;
                              }),
                          loaded: (user) {
                            credentials = user;

                            setState(() {
                              _isLoading = !_isLoading;
                            });

                            context.router.pushNamed(
                              PRFSuperAppRouter.decisionRoute,
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.registered),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          error: (message) {
                            setState(() {
                              _isLoading = !_isLoading;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(message),
                                backgroundColor: Colors.red,
                              ),
                            );
                          },
                          orElse: () {},
                        );
                      },
                      builder: (context, state) {
                        return state.maybeWhen(
                          orElse:
                              () => PrimaryButton(
                                onPressed:
                                    () =>
                                        context
                                            .read<RegisterStudentCubit>()
                                            .registerStudent(),
                                title:
                                    _isLoading
                                        ? l10n.registering
                                        : l10n.iAmReady,
                                disabled: _isLoading,
                                isLoading: _isLoading ? true : null,
                              ),
                        );
                      },
                    ),
                    SizedBox(height: 24),
                    SecondaryButton(
                      onPressed: () => context.router.popForced(),
                      title: l10n.cancel,
                      disabled: false,
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
