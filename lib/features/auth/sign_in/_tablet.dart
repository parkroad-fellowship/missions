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

class SignInTablet extends StatefulWidget {
  const SignInTablet({super.key});

  @override
  State<SignInTablet> createState() => _SignInTabletState();
}

class _SignInTabletState extends State<SignInTablet> {
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
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Left Column - SignIn form (flex: 3)
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 420),
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(
                              horizontal: PRFSpacingTokens.xl,
                              vertical: PRFSpacingTokens.xxl,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Logo (smaller for side-by-side)
                                buildLogo(theme),

                                const SizedBox(height: PRFSpacingTokens.xxl),

                                // Welcome Text
                                buildWelcomeHeaders(theme, l10n),

                                const SizedBox(height: PRFSpacingTokens.xxxl),

                                FutureBuilder(
                                  future: getIt<PRFFirebaseService>()
                                      .canShowAuth(),
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
                                            controller:
                                                _form.passwordController,
                                            enabled: !_form.isLoading,
                                          ),

                                          const SizedBox(
                                            height: PRFSpacingTokens.xxl,
                                          ),

                                          // Sign In Button
                                          BlocConsumer<
                                            SigninCubit,
                                            SignInState
                                          >(
                                            listener: (context, state) {
                                              state.maybeWhen(
                                                loading: () =>
                                                    _form.setLoading(true),
                                                loaded: () {
                                                  _form.setLoading(false);
                                                  context.router.pushPath(
                                                    PRFSuperAppRouter
                                                        .landingRoute,
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
                                                        _form
                                                            .emailController
                                                            .text,
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
                                          buildOrDivider(theme),

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

                                const SizedBox(height: PRFSpacingTokens.xxxl),

                                // Version
                                buildVersionPill(theme, l10n),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Vertical Divider
                    VerticalDivider(
                      width: 1,
                      thickness: 1,
                      color: theme.colorScheme.outline.withValues(alpha: 0.12),
                    ),

                    // Right Column - Beautiful Brand Welcome Panel (flex: 2)
                    Expanded(
                      flex: 2,
                      child: Container(
                        margin: const EdgeInsets.all(PRFSpacingTokens.lg),
                        padding: const EdgeInsets.all(PRFSpacingTokens.xl),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(
                            PRFRadiusTokens.lg,
                          ),
                          border: Border.all(
                            color: theme.colorScheme.outline.withValues(
                              alpha: 0.12,
                            ),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),
                            Icon(
                              Icons.spa_rounded,
                              size: 72,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(height: PRFSpacingTokens.lg),
                            Text(
                              'Support Fellowship',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.onSurface,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: PRFSpacingTokens.md),
                            Text(
                              'Join your fellowship members, manage requisitions, suggest grounds and run missions seamlessly with the official PRF Missions tool.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
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
