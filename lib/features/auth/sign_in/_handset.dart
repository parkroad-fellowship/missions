import 'package:app/di/di_container.dart';
import 'package:app/features/auth/cubit/google_sign_in_cubit.dart';
import 'package:app/features/auth/cubit/sign_in_cubit.dart';
import 'package:app/features/auth/cubit/social_login_cubit.dart';
import 'package:app/features/auth/sign_in/_shared.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/services/firebase/firebase_service.dart';
import 'package:app/shared/validators.dart';
import 'package:app/utils/router/router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaimon/gaimon.dart';
import 'package:prf_design/prf_design.dart';

class SignInHandset extends StatefulWidget {
  const SignInHandset({super.key});

  @override
  State<SignInHandset> createState() => _SignInHandsetState();
}

class _SignInHandsetState extends State<SignInHandset> {
  final _form = SignInFormState();

  @override
  void initState() {
    super.initState();
    _form.attach(() => setState(() {}));
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return BlocListener<GoogleSignInCubit, GoogleSignInState>(
      listener: (context, state) {
        state.maybeWhen(
          orElse: () {},
          loaded: (socialLoginDTO) => context.read<SocialLoginCubit>().login(
            socialAuthDTO: socialLoginDTO,
          ),
          error: (message) {
            PRFSnackbar.error(context, message);
          },
        );
      },
      child: BlocListener<SocialLoginCubit, SocialLoginState>(
        listener: (context, state) {
          state.maybeWhen(
            orElse: () {},
            loaded: () =>
                context.router.pushPath(PRFSuperAppRouter.decisionRoute),
            error: (message) {
              PRFSnackbar.error(context, message);
            },
          );
        },
        child: Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.all(PRFSpacingTokens.xl),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Spacer(),

                            // Logo
                            buildLogo(theme),

                            const SizedBox(height: 48),

                            // Welcome Text
                            buildWelcomeHeaders(theme, l10n),

                            const SizedBox(height: 48),

                            FutureBuilder(
                              future: getIt<PRFFirebaseService>().canShowAuth(),
                              builder: (context, snapshot) {
                                final canShowAuth = snapshot.data ?? false;
                                return Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    if (canShowAuth || kDebugMode) ...[
                                      // Email Input
                                      PRFTextField(
                                        type: PRFTextFieldType.email,
                                        hintText: l10n.enterEmail,
                                        controller: _form.emailController,
                                        enabled: !_form.isLoading,
                                      ),

                                      const SizedBox(
                                        height: PRFSpacingTokens.lg,
                                      ),

                                      // Password Input
                                      PRFTextField(
                                        type: PRFTextFieldType.password,
                                        hintText: l10n.enterPassword,
                                        obscureNotifier:
                                            _form.hidePasswordNotifier,
                                        controller: _form.passwordController,
                                        enabled: !_form.isLoading,
                                      ),

                                      const SizedBox(
                                        height: PRFSpacingTokens.xxl,
                                      ),

                                      // Sign In Button
                                      BlocConsumer<SigninCubit, SignInState>(
                                        listener: (context, state) {
                                          state.maybeWhen(
                                            loading: () =>
                                                _form.setLoading(true),
                                            loaded: () {
                                              _form.setLoading(false);
                                              context.router.pushPath(
                                                PRFSuperAppRouter.landingRoute,
                                              );
                                            },
                                            error: (message) {
                                              _form.setLoading(false);
                                              PRFSnackbar.error(
                                                context,
                                                message,
                                              );
                                            },
                                            orElse: () {},
                                          );
                                        },
                                        builder: (context, state) {
                                          return PRFButton(
                                            onPressed: () {
                                              final emailResult =
                                                  PRFRequired(
                                                    l10n.enterEmail,
                                                  ).validateResult(
                                                    _form.emailController.text,
                                                  );
                                              if (!emailResult.valid) {
                                                PRFSnackbar.warning(
                                                  context,
                                                  emailResult.error!,
                                                );
                                                Gaimon.warning();
                                                return;
                                              }

                                              final passwordResult =
                                                  PRFRequired(
                                                    l10n.enterPassword,
                                                  ).validateResult(
                                                    _form
                                                        .passwordController
                                                        .text,
                                                  );
                                              if (!passwordResult.valid) {
                                                PRFSnackbar.warning(
                                                  context,
                                                  passwordResult.error!,
                                                );
                                                Gaimon.warning();
                                                return;
                                              }

                                              context
                                                  .read<SigninCubit>()
                                                  .signIn(
                                                    email: _form
                                                        .emailController
                                                        .text
                                                        .trim(),
                                                    password: _form
                                                        .passwordController
                                                        .text
                                                        .trim(),
                                                  );
                                            },
                                            title: _form.isLoading
                                                ? l10n.signingIn
                                                : l10n.signIn,
                                            disabled: _form.isLoading,
                                            isLoading: _form.isLoading,
                                          );
                                        },
                                      ),

                                      const SizedBox(
                                        height: PRFSpacingTokens.xxl,
                                      ),

                                      // Divider
                                      buildOrDivider(theme, l10n),

                                      const SizedBox(
                                        height: PRFSpacingTokens.xxl,
                                      ),
                                    ],

                                    // Google Sign In Button
                                    const GoogleSignInButton(),
                                  ],
                                );
                              },
                            ),

                            const Spacer(),

                            // Version
                            buildVersionPill(theme, l10n),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
