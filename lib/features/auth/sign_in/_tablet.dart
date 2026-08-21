import 'dart:math' as math;

import 'package:app/di/di_container.dart';
import 'package:app/features/auth/cubit/google_sign_in_cubit.dart';
import 'package:app/features/auth/cubit/sign_in_cubit.dart';
import 'package:app/features/auth/cubit/social_login_cubit.dart';
import 'package:app/features/auth/sign_in/_shared.dart';
import 'package:app/l10n/arb/app_localizations.dart';
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
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  late final Future<bool> _canShowAuth;

  String? _emailError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
    _canShowAuth = getIt<PRFFirebaseService>().canShowAuth();
    _form.attach(() => setState(() {}));
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _form.dispose();
    super.dispose();
  }

  void _submit() {
    final l10n = context.l10n;
    final emailError = PRFCompose([
      PRFRequired(l10n.enterEmail),
      PRFEmail(l10n.enterValidEmail),
    ]).validate(_form.emailController.text);
    final passwordError = PRFRequired(
      l10n.enterPassword,
    ).validate(_form.passwordController.text);

    setState(() {
      _emailError = emailError;
      _passwordError = passwordError;
    });

    if (emailError != null || passwordError != null) {
      Gaimon.warning();
      return;
    }

    context.read<SigninCubit>().signIn(
      email: _form.emailController.text.trim(),
      password: _form.passwordController.text.trim(),
    );
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
                final showBrandPanel = constraints.maxWidth >= 960;

                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1100),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: showBrandPanel ? 3 : 1,
                          child: _buildFormColumn(constraints.maxHeight),
                        ),
                        if (showBrandPanel) ...[
                          VerticalDivider(
                            width: 1,
                            thickness: 1,
                            color: theme.colorScheme.outline.withValues(
                              alpha: 0.12,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: _buildBrandPanel(l10n, theme),
                          ),
                        ],
                      ],
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

  Widget _buildFormColumn(double bodyHeight) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    const verticalPadding = PRFSpacingTokens.xxl * 2;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: PRFSpacingTokens.xxl,
            vertical: PRFSpacingTokens.xxl,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: math.max<double>(0, bodyHeight - verticalPadding),
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),

                  buildLogo(theme),
                  const SizedBox(height: PRFSpacingTokens.xxl),
                  buildWelcomeHeaders(theme, l10n),
                  const SizedBox(height: PRFSpacingTokens.xxxl),

                  // Primary action: Google sign-in.
                  const GoogleSignInButton(),
                  const SizedBox(height: PRFSpacingTokens.xxl),

                  // Secondary action: email & password (Play Store review
                  // builds). Resolves once from initState.
                  FutureBuilder<bool>(
                    future: _canShowAuth,
                    builder: (context, snapshot) {
                      final canShowAuth = snapshot.data ?? false;
                      if (!canShowAuth && !kDebugMode) {
                        return const SizedBox.shrink();
                      }
                      return _buildEmailSignIn(theme, l10n);
                    },
                  ),

                  const Spacer(),
                  buildVersionPill(theme, l10n),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailSignIn(ThemeData theme, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildOrDivider(theme, l10n),
        const SizedBox(height: PRFSpacingTokens.xxl),
        AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PRFTextField(
                type: PRFTextFieldType.email,
                hintText: l10n.enterEmail,
                labelText: l10n.email,
                controller: _form.emailController,
                enabled: !_form.isLoading,
                errorText: _emailError,
                focusNode: _emailFocusNode,
                autofillHints: const [AutofillHints.email],
                onSubmitted: (_) => _passwordFocusNode.requestFocus(),
                onChanged: (_) {
                  if (_emailError != null) {
                    setState(() => _emailError = null);
                  }
                },
              ),
              const SizedBox(height: PRFSpacingTokens.lg),
              PRFTextField(
                type: PRFTextFieldType.password,
                hintText: l10n.enterPassword,
                labelText: l10n.password,
                obscureNotifier: _form.hidePasswordNotifier,
                controller: _form.passwordController,
                enabled: !_form.isLoading,
                errorText: _passwordError,
                focusNode: _passwordFocusNode,
                autofillHints: const [AutofillHints.password],
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
                onChanged: (_) {
                  if (_passwordError != null) {
                    setState(() => _passwordError = null);
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: PRFSpacingTokens.xxl),
        BlocConsumer<SigninCubit, SignInState>(
          listener: (context, state) {
            state.maybeWhen(
              loading: () => _form.setLoading(true),
              loaded: () {
                _form.setLoading(false);
                context.router.pushPath(PRFSuperAppRouter.landingRoute);
              },
              error: (message) {
                _form.setLoading(false);
                PRFSnackbar.error(context, message);
              },
              orElse: () {},
            );
          },
          builder: (context, state) {
            return PRFButton(
              onPressed: _submit,
              title: _form.isLoading ? l10n.signingIn : l10n.signIn,
              disabled: _form.isLoading,
              isLoading: _form.isLoading,
            );
          },
        ),
      ],
    );
  }

  Widget _buildBrandPanel(AppLocalizations l10n, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(PRFSpacingTokens.lg),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: PRFColors.navyBlue,
          borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
          child: Stack(
            children: [
              const Positioned.fill(
                child: ExcludeSemantics(
                  child: CustomPaint(painter: PRFRootMotifPainter()),
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: PRFSpacingTokens.xxxl,
                    vertical: PRFSpacingTokens.xxl,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.signInPanelBody,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: PRFColors.navy100,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
