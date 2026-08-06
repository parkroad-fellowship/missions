import 'package:app/features/auth/cubit/google_sign_in_cubit.dart';
import 'package:app/features/auth/cubit/social_login_cubit.dart';
import 'package:app/l10n/arb/app_localizations.dart';
import 'package:app/utils/helpers/app_version_helper.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class SignInFormState {
  SignInFormState();

  late final VoidCallback _rebuild;

  final emailController = TextEditingController(
    text: kDebugMode ? 'member.bradtke@example.org' : '',
  );
  final passwordController = TextEditingController(
    text: kDebugMode ? 'asZDcVt7Q' : '',
  );
  final hidePasswordNotifier = ValueNotifier<bool>(true);

  bool isLoading = false;

  // ignore: use_setters_to_change_properties
  void attach(VoidCallback rebuild) {
    _rebuild = rebuild;
  }

  // ignore: avoid_positional_boolean_parameters
  void setLoading(bool val) {
    isLoading = val;
    _rebuild();
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    hidePasswordNotifier.dispose();
  }
}

Widget buildLogo(ThemeData theme) {
  return Center(
    child: Container(
      padding: const EdgeInsets.all(PRFSpacingTokens.lg),
      decoration: BoxDecoration(
        color: PRFColors.white,
        borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
        boxShadow: [
          BoxShadow(
            color: PRFColors.black.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ExtendedImage.asset(
        'assets/images/app-logo.png',
        height: 60,
        width: 69,
      ),
    ),
  );
}

Widget buildWelcomeHeaders(ThemeData theme, AppLocalizations l10n) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        l10n.signIn,
        style: theme.textTheme.headlineLarge?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w700,
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: PRFSpacingTokens.sm),
      Text(
        l10n.welcomeBack,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
        textAlign: TextAlign.center,
      ),
    ],
  );
}

Widget buildOrDivider(ThemeData theme) {
  return Row(
    children: [
      Expanded(
        child: Divider(
          color: theme.colorScheme.outline,
          thickness: 1,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: PRFSpacingTokens.lg,
        ),
        child: Text(
          'OR',
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      Expanded(
        child: Divider(
          color: theme.colorScheme.outline,
          thickness: 1,
        ),
      ),
    ],
  );
}

Widget buildVersionPill(ThemeData theme, AppLocalizations l10n) {
  return Center(
    child: Container(
      padding: const EdgeInsets.symmetric(
        horizontal: PRFSpacingTokens.lg,
        vertical: PRFSpacingTokens.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
      ),
      child: Text(
        l10n.version(
          AppVersionHelper.getAppVersion(),
        ),
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    ),
  );
}

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoogleSignInCubit, GoogleSignInState>(
      builder: (context, signInWithGoogleState) {
        return BlocBuilder<SocialLoginCubit, SocialLoginState>(
          builder: (context, socialSignUpState) {
            return BlocBuilder<SocialLoginCubit, SocialLoginState>(
              builder: (context, socialSignInState) {
                final (
                  isLoading,
                  title,
                ) = signInWithGoogleState.maybeWhen(
                  loading: () => (true, 'Please wait ...'),
                  orElse: () => socialSignUpState.maybeWhen(
                    loading: () => (
                      true,
                      'Please wait ...',
                    ),
                    orElse: () => socialSignInState.maybeWhen(
                      loading: () => (
                        true,
                        'Please wait ...',
                      ),
                      orElse: () => (
                        false,
                        'Continue with Google',
                      ),
                    ),
                  ),
                );

                return PRFButton(
                  variant: PRFButtonVariant.google,
                  onPressed: () =>
                      context.read<GoogleSignInCubit>().signInwithGoogle(),
                  title: title,
                  disabled: isLoading,
                  isLoading: isLoading,
                );
              },
            );
          },
        );
      },
    );
  }
}
