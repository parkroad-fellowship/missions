import 'package:app/features/auth/cubit/google_sign_in_cubit.dart';
import 'package:app/features/auth/cubit/sign_in_cubit.dart';
import 'package:app/features/auth/cubit/social_login_cubit.dart';
import 'package:app/features/home/account/cubit/change_profile_picture_cubit.dart';
import 'package:app/features/home/account/cubit/sign_out_cubit.dart';
import 'package:app/services/api/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

/// Auth module for registering authentication-related services and cubits.
///
/// Includes:
/// - Auth service
/// - Sign in/out cubits
/// - Social login cubits
/// - Profile management cubits
class AuthModule {
  static void register(GetIt getIt) {
    getIt.registerSingleton<AuthService>(AuthService());
  }

  static List<BlocProvider> registerCubits(GetIt getIt) {
    return [
      BlocProvider<SigninCubit>(
        create: (context) => SigninCubit(
          authService: getIt(),
          hiveService: getIt(),
          socketService: getIt(),
          analyticsService: getIt(),
          firebaseMessagingService: getIt(),
        ),
      ),
      BlocProvider<GoogleSignInCubit>(
        create: (context) => GoogleSignInCubit(firebaseService: getIt()),
      ),
      BlocProvider<SocialLoginCubit>(
        create: (context) => SocialLoginCubit(
          authService: getIt(),
          hiveService: getIt(),
        ),
      ),
      BlocProvider<SignOutCubit>(
        create: (context) => SignOutCubit(
          hiveService: getIt(),
          isarService: getIt(),
        ),
      ),
      BlocProvider<ChangeProfilePictureCubit>(
        create: (context) => ChangeProfilePictureCubit(
          mediaService: getIt(),
          hiveService: getIt(),
        ),
      ),
    ];
  }
}
