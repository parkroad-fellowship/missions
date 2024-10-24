import 'package:app/features/auth/cubit/sign_in_cubit.dart';
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
    text: kDebugMode ? 'swift.antonina@parkroadfellowship.org' : '',
  );
  final _passwordController = TextEditingController(
    text: kDebugMode ? 'password' : '',
  );
  final _hidePasswordNotifier = ValueNotifier<bool>(true);

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
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
                  child: Text(
                    l10n.signIn,
                    style: CustomTextTheme.customTextTheme().displayLarge,
                  ),
                ),
                const SizedBox(height: 20),
                InputFormField(
                  hintText: l10n.enterEmail,
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
                      loading: () => setState(() {
                        _isLoading = !_isLoading;
                      }),
                      loaded: () => context.router.pushNamed(
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
                      orElse: () => PrimaryButton(
                        onPressed: () {
                          context.read<SigninCubit>().signIn(
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                              );
                        },
                        title: _isLoading ? l10n.signingIn : l10n.signIn,
                        disabled: _isLoading,
                        isLoading: _isLoading ? true : null,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),
                SecondaryButton(
                  onPressed: () => context.router
                      .pushNamed(PRFSuperAppRouter.registerStudentRoute),
                  title: l10n.registerStudent,
                  disabled: false,
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
