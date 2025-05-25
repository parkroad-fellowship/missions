import 'package:app/features/auth/cubit/google_sign_in_cubit.dart';
import 'package:app/features/auth/cubit/sign_in_cubit.dart';
import 'package:app/features/auth/cubit/social_login_cubit.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/services/_index.dart';
import 'package:app/utils/_index.dart';
import 'package:app/widgets/_index.dart';

import 'package:auto_route/auto_route.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaimon/gaimon.dart';

class SignInTablet extends StatefulWidget {
  const SignInTablet({super.key});

  @override
  State<SignInTablet> createState() => _SignInTabletState();
}

class _SignInTabletState extends State<SignInTablet> {
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
    Misc.initDimensions(context);
    final canShowAuth = getIt<AuthService>().canShowAuth();

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
          body: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.sizeOf(context).width * 0.5,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.sizeOf(context).height,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Center(
                          child: ExtendedImage.asset(
                            'assets/images/app-logo.png',
                            height: 200,
                            width: 232,
                          ),
                        ),
                        if (canShowAuth || kDebugMode) ...[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              l10n.signIn,
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                          ),
                          const SizedBox(height: 20),

                          PRFEmailInput(
                            hintText: l10n.enterEmail,
                            emailController: _emailController,
                            enabled: !_isLoading,
                          ),
                          const SizedBox(height: 20),
                          ValueListenableBuilder<bool>(
                            valueListenable: _hidePasswordNotifier,
                            builder: (context, hidePassword, child) {
                              return PRFPasswordInput(
                                hintText: l10n.enterPassword,
                                hidePasswordNotifier: _hidePasswordNotifier,
                                passwordController: _passwordController,
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
                                    () => PRFPrimaryButton(
                                      onPressed: () {
                                        if (_emailController.text.isEmpty) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(l10n.enterEmail),
                                            ),
                                          );
                                          Gaimon.warning();
                                          return;
                                        }

                                        if (_passwordController.text.isEmpty) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(l10n.enterPassword),
                                            ),
                                          );
                                          Gaimon.warning();
                                          return;
                                        }

                                        context.read<SigninCubit>().signIn(
                                          email: _emailController.text.trim(),
                                          password:
                                              _passwordController.text.trim(),
                                        );
                                      },
                                      title:
                                          _isLoading
                                              ? l10n.signingIn
                                              : l10n.signIn,
                                      disabled: _isLoading,
                                      isLoading: _isLoading ? true : null,
                                    ),
                              );
                            },
                          ),
                          const SizedBox(height: 64),

                          const Divider(),
                          const SizedBox(height: 64),
                        ],
                        BlocBuilder<GoogleSignInCubit, GoogleSignInState>(
                          builder: (context, signInWithGoogleState) {
                            return BlocBuilder<
                              SocialLoginCubit,
                              SocialLoginState
                            >(
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
                                      loading: () => (true, 'Please wait ...'),
                                      orElse:
                                          () => socialSignUpState.maybeWhen(
                                            loading:
                                                () => (true, 'Please wait ...'),
                                            orElse:
                                                // ignore: lines_longer_than_80_chars
                                                () => socialSignInState.maybeWhen(
                                                  loading:
                                                      () => (
                                                        true,
                                                        'Please wait ...',
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
                        const SizedBox(height: 54),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            l10n.version(Misc.getAppVersion()),
                            style: Theme.of(context).textTheme.labelLarge,
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
        ),
      ),
    );
  }
}
