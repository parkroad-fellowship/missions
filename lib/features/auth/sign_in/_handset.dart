import 'package:app/features/auth/cubit/google_sign_in_cubit.dart';
import 'package:app/features/auth/cubit/sign_in_cubit.dart';
import 'package:app/features/auth/cubit/social_login_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/utils/_index.dart';
import 'package:app/widgets/_index.dart';
import 'package:app/widgets/secondary_button.dart';
import 'package:auto_route/auto_route.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInHandset extends StatefulWidget {
  const SignInHandset({super.key});

  @override
  State<SignInHandset> createState() => _SignInHandsetState();
}

class _SignInHandsetState extends State<SignInHandset> {
  final _emailController = TextEditingController(
    text: kDebugMode ? 'approvals@parkroadfellowship.org' : '',
  );
  final _passwordController = TextEditingController(
    text: kDebugMode ? 'password' : '',
  );
  final _hidePasswordNotifier = ValueNotifier<bool>(true);

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<GoogleSignInCubit, GoogleSignInState>(
      listener: (context, state) {
        state.maybeWhen(
          orElse: () {},
          loaded:
              (socialLoginDTO) => context.read<SocialLoginCubit>().login(
                socialAuthDTO: socialLoginDTO,
              ),
          error: (message) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message)));
          },
        );
      },
      child: BlocListener<SocialLoginCubit, SocialLoginState>(
        listener: (context, state) {
          state.maybeWhen(
            orElse: () {},
            loaded:
                () => context.router.pushNamed(PRFSuperAppRouter.decisionRoute),
            error: (message) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(message)));
            },
          );
        },
        child: Scaffold(
          body: Padding(
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
                      alignment: Alignment.centerLeft,
                      child: Text(
                        l10n.signIn,
                        style: PRFText.theme().displayLarge,
                      ),
                    ),
                    const SizedBox(height: 20),
                    InputFormField(
                      hintText: l10n.studentEmail,
                      controller: _emailController,
                      enabled: !_isLoading,
                    ),
                    const SizedBox(height: 20),
                    ValueListenableBuilder<bool>(
                      valueListenable: _hidePasswordNotifier,
                      builder: (context, hidePassword, child) {
                        return InputFormField(
                          hintText: l10n.enterPassword,
                          controller: _passwordController,
                          showSuffix: true,
                          hidePassword: hidePassword,
                          toggleHidePassword: () {
                            _hidePasswordNotifier.value = !hidePassword;
                          },
                          enabled: !_isLoading,
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    BlocConsumer<SigninCubit, SignInState>(
                      listener: (context, state) {
                        state.maybeWhen(
                          loading:
                              () => setState(() {
                                _isLoading = !_isLoading;
                              }),
                          loaded:
                              () => context.router.pushNamed(
                                PRFSuperAppRouter.landingRoute,
                              ),
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
                                onPressed: () {
                                  context.read<SigninCubit>().signIn(
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text.trim(),
                                  );
                                },
                                title:
                                    _isLoading ? l10n.signingIn : l10n.signIn,
                                disabled: _isLoading,
                                isLoading: _isLoading ? true : null,
                              ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    SecondaryButton(
                      onPressed:
                          () => context.router.pushNamed(
                            PRFSuperAppRouter.registerStudentRoute,
                          ),
                      title: l10n.registerStudent,
                      disabled: false,
                    ),
                    const Divider(),
                    const SizedBox(height: 40),
                    BlocBuilder<GoogleSignInCubit, GoogleSignInState>(
                      builder: (context, signInWithGoogleState) {
                        return BlocBuilder<SocialLoginCubit, SocialLoginState>(
                          builder: (context, socialSignUpState) {
                            return BlocBuilder<
                              SocialLoginCubit,
                              SocialLoginState
                            >(
                              builder: (context, socialSignInState) {
                                final (
                                  isLoading,
                                  title,
                                ) = signInWithGoogleState.maybeWhen(
                                  loading:
                                      () => (true, 'Continue with Google...'),
                                  orElse:
                                      () => socialSignUpState.maybeWhen(
                                        loading:
                                            () => (
                                              true,
                                              'Continue with Google...',
                                            ),
                                        orElse:
                                            () => socialSignInState.maybeWhen(
                                              loading:
                                                  () => (
                                                    true,
                                                    'Continue with Google...',
                                                  ),
                                              orElse:
                                                  () => (
                                                    false,
                                                    'Continue with Google',
                                                  ),
                                            ),
                                      ),
                                );

                                return GoogleAuthButton(
                                  onPressed: () {
                                    if (!isLoading) {
                                      context
                                          .read<GoogleSignInCubit>()
                                          .signInwithGoogle();
                                    }
                                  },
                                  title: title,
                                  disabled: isLoading,
                                  isLoading: isLoading,
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        l10n.version(Misc.getAppVersion()),
                        style: PRFText.theme().displaySmall!.copyWith(
                          fontSize: 12,
                          color: const Color(0xFF727272),
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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
