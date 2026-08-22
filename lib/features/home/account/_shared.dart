import 'package:app/di/di_container.dart';
import 'package:app/enums/common/prf_theme_mode.dart';
import 'package:app/enums/member/prf_membership_type.dart';
import 'package:app/enums/prf_media_model.dart';
import 'package:app/enums/prf_media_type.dart';
import 'package:app/features/home/account/cubit/change_profile_picture_cubit.dart';
import 'package:app/l10n/arb/app_localizations.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/common/auth.dart';
import 'package:app/services/local_storage/hive/hive_service.dart';
import 'package:app/shared/theme/cubit/theme_cubit.dart';
import 'package:app/utils/constants.dart';
import 'package:app/utils/helpers/app_version_helper.dart';
import 'package:app/utils/helpers/url_helper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaimon/gaimon.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:prf_design/prf_design.dart';

class AccountFormState {
  void attach(VoidCallback rebuild) {}
  void dispose() {}
}

Widget buildInfoField(
  BuildContext context, {
  required String label,
  required String value,
  required IconData icon,
  int maxLines = 1,
}) {
  final theme = Theme.of(context);

  return Container(
    padding: const EdgeInsets.all(PRFSpacingTokens.lg),
    decoration: BoxDecoration(
      color: theme.colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
      border: Border.all(
        color: theme.colorScheme.outline.withValues(alpha: PRFOpacities.muted),
      ),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(PRFSpacingTokens.sm),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(
              alpha: PRFOpacities.subtle,
            ),
            borderRadius: BorderRadius.circular(PRFRadiusTokens.sm),
          ),
          child: Icon(
            icon,
            color: theme.colorScheme.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: PRFSpacingTokens.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: PRFSpacingTokens.xs),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: maxLines,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

String getThemeModeLabel(PRFThemeMode mode, AppLocalizations l10n) {
  return switch (mode) {
    PRFThemeMode.system => l10n.systemDefault,
    PRFThemeMode.light => l10n.lightMode,
    PRFThemeMode.dark => l10n.darkModeEnabled,
  };
}

Widget buildProfileCard(
  BuildContext context,
  ThemeData theme,
  AppLocalizations l10n,
) {
  return Container(
    padding: const EdgeInsets.all(PRFSpacingTokens.xl),
    decoration: BoxDecoration(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
      boxShadow: PRFShadowTokens.card(theme.colorScheme.shadow),
    ),
    child: Column(
      children: [
        // Profile Picture
        Stack(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withValues(
                      alpha: PRFOpacities.subtle,
                    ),
                    theme.colorScheme.secondary.withValues(
                      alpha: PRFOpacities.subtle,
                    ),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(
                    alpha: PRFOpacities.glow,
                  ),
                  width: 3,
                ),
              ),
              child: ClipOval(
                child: ValueListenableBuilder(
                  valueListenable: Hive.box<dynamic>(
                    PRFSuperAppConfig.instance!.values.hiveBox,
                  ).listenable(),
                  builder: (context, _, _) {
                    final profilePicture = getIt<HiveService>()
                        .retrieveMember()
                        ?.profilePicture;

                    return profilePicture != null
                        ? Image.network(
                            profilePicture.temporaryURL,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.person_rounded,
                              size: 50,
                              color: theme.colorScheme.primary,
                            ),
                          )
                        : Icon(
                            Icons.person_rounded,
                            size: 50,
                            color: theme.colorScheme.primary,
                          );
                  },
                ),
              ),
            ),
            const ChangeProfilePictureButton(),
          ],
        ),
        const SizedBox(height: PRFSpacingTokens.lg),
        // User Name
        ValueListenableBuilder(
          valueListenable: Hive.box<dynamic>(
            PRFSuperAppConfig.instance!.values.hiveBox,
          ).listenable(),
          builder: (context, _, _) {
            final profile = getIt<HiveService>().auth.retrieveProfile();
            return Text(
              profile?.name ?? 'User',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            );
          },
        ),
        const SizedBox(height: PRFSpacingTokens.xs),
        // User Email
        ValueListenableBuilder(
          valueListenable: Hive.box<dynamic>(
            PRFSuperAppConfig.instance!.values.hiveBox,
          ).listenable(),
          builder: (context, _, _) {
            final profile = getIt<HiveService>().auth.retrieveProfile();
            return Text(
              profile?.email ?? '',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            );
          },
        ),
      ],
    ),
  );
}

Widget buildPersonalInfoSection(
  BuildContext context,
  ThemeData theme,
  AppLocalizations l10n,
  PRFUser profile,
) {
  return Container(
    padding: const EdgeInsets.all(PRFSpacingTokens.xl),
    decoration: BoxDecoration(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
      boxShadow: PRFShadowTokens.card(theme.colorScheme.shadow),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.person_outline_rounded,
              color: theme.colorScheme.primary,
              size: 24,
            ),
            const SizedBox(width: PRFSpacingTokens.md),
            Text(
              'Personal Information',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: PRFSpacingTokens.xl),
        buildInfoField(
          context,
          label: l10n.name,
          value: profile.name,
          icon: Icons.badge_outlined,
        ),
        const SizedBox(height: PRFSpacingTokens.lg),
        buildInfoField(
          context,
          label: l10n.email,
          value: profile.email,
          icon: Icons.email_outlined,
        ),
        if (profile.member?.bio != null && profile.member!.bio!.isNotEmpty) ...[
          const SizedBox(height: PRFSpacingTokens.lg),
          buildInfoField(
            context,
            label: l10n.bio,
            value: profile.member!.bio!,
            icon: Icons.description_outlined,
            maxLines: 3,
          ),
        ],
      ],
    ),
  );
}

Widget buildMembershipsSection(
  BuildContext context,
  ThemeData theme,
  AppLocalizations l10n,
  PRFUser profile,
) {
  return Container(
    padding: const EdgeInsets.all(PRFSpacingTokens.xl),
    decoration: BoxDecoration(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
      boxShadow: PRFShadowTokens.card(theme.colorScheme.shadow),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.groups_outlined,
              color: theme.colorScheme.primary,
              size: 24,
            ),
            const SizedBox(width: PRFSpacingTokens.md),
            Text(
              l10n.memberships,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: PRFSpacingTokens.lg),
        ...profile.member!.memberships.asMap().entries.map(
          (entry) => Container(
            margin: EdgeInsets.only(
              bottom: entry.key < profile.member!.memberships.length - 1
                  ? 12
                  : 0,
            ),
            padding: const EdgeInsets.all(PRFSpacingTokens.lg),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(
                  alpha: PRFOpacities.muted,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(PRFSpacingTokens.sm),
                  decoration: BoxDecoration(
                    color: entry.value.approved
                        ? theme.colorScheme.primary.withValues(
                            alpha: PRFOpacities.subtle,
                          )
                        : theme.colorScheme.secondary.withValues(
                            alpha: PRFOpacities.subtle,
                          ),
                    borderRadius: BorderRadius.circular(PRFRadiusTokens.sm),
                  ),
                  child: Icon(
                    entry.value.approved
                        ? Icons.verified_outlined
                        : Icons.pending_outlined,
                    color: entry.value.approved
                        ? theme.colorScheme.primary
                        : theme.colorScheme.secondary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: PRFSpacingTokens.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.value.spiritualYear!.name,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        PrfMembershipType.fromIndex(entry.value.type).name,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: PRFSpacingTokens.sm,
                    vertical: PRFSpacingTokens.xs,
                  ),
                  decoration: BoxDecoration(
                    color: entry.value.approved
                        ? theme.colorScheme.primary.withValues(
                            alpha: PRFOpacities.subtle,
                          )
                        : theme.colorScheme.secondary.withValues(
                            alpha: PRFOpacities.subtle,
                          ),
                    borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
                  ),
                  child: Text(
                    entry.value.approved ? 'Approved' : 'Pending',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: entry.value.approved
                          ? theme.colorScheme.primary
                          : theme.colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildSettingsSection(
  BuildContext context,
  ThemeData theme,
  AppLocalizations l10n,
) {
  return Container(
    padding: const EdgeInsets.all(PRFSpacingTokens.xl),
    decoration: BoxDecoration(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
      boxShadow: PRFShadowTokens.card(theme.colorScheme.shadow),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.settings_outlined,
              color: theme.colorScheme.primary,
              size: 24,
            ),
            const SizedBox(width: PRFSpacingTokens.md),
            Text(
              l10n.settings,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: PRFSpacingTokens.xl),
        BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            final themeCubit = context.read<ThemeCubit>();
            final currentMode = themeCubit.currentThemeMode;
            final surfaceColor = theme.colorScheme.surfaceContainerHighest;
            final outlineColor = theme.colorScheme.outline.withValues(
              alpha: 0.2,
            );
            final primaryLight = theme.colorScheme.primary.withValues(
              alpha: 0.1,
            );

            return Container(
              padding: const EdgeInsets.all(PRFSpacingTokens.lg),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(PRFRadiusTokens.smd),
                border: Border.all(color: outlineColor),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(PRFSpacingTokens.sm),
                    decoration: BoxDecoration(
                      color: primaryLight,
                      borderRadius: BorderRadius.circular(PRFRadiusTokens.sm),
                    ),
                  ),
                  const SizedBox(width: PRFSpacingTokens.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.darkMode,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          getThemeModeLabel(currentMode, l10n),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch.adaptive(
                    value: currentMode == PRFThemeMode.dark,
                    onChanged: (value) {
                      themeCubit.setThemeMode(
                        value ? PRFThemeMode.dark : PRFThemeMode.light,
                      );
                    },
                    activeTrackColor: theme.colorScheme.primary,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );
}

Widget buildFooterSection(
  BuildContext context,
  ThemeData theme,
  AppLocalizations l10n,
) {
  return Container(
    padding: const EdgeInsets.all(PRFSpacingTokens.xl),
    decoration: BoxDecoration(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
      boxShadow: PRFShadowTokens.card(theme.colorScheme.shadow),
    ),
    child: Column(
      children: [
        Text.rich(
          TextSpan(
            text: l10n.byUsing,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            children: [
              TextSpan(
                text: l10n.terms,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    final uri = Uri(
                      scheme: 'https',
                      host: 'parkroadfellowship.org',
                      path: '/privacy-policy',
                    );
                    await UrlHelper.openUrl(uri);
                  },
              ),
              TextSpan(
                text: l10n.and,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              TextSpan(
                text: l10n.privacyPolicy,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    final uri = Uri(
                      scheme: 'https',
                      host: 'parkroadfellowship.org',
                      path: 'privacy-policy',
                    );
                    await UrlHelper.openUrl(uri);
                  },
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: PRFSpacingTokens.md),
        Text(
          l10n.version(
            AppVersionHelper.getAppVersion(),
          ),
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    ),
  );
}

class ChangeProfilePictureButton extends StatelessWidget {
  const ChangeProfilePictureButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return ValueListenableBuilder(
      valueListenable: Hive.box<dynamic>(
        PRFSuperAppConfig.instance!.values.hiveBox,
      ).listenable(),
      builder: (context, _, _) {
        final member = getIt<HiveService>().retrieveMember();
        if (member == null) return const SizedBox.shrink();
        return Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () =>
                context.read<ChangeProfilePictureCubit>().changeProfilePicture(
                  context: context,
                  modelUlid: member.ulid,
                  model: PRFMediaModel.memberProfilePictures,
                  mediaType: PRFMediaType.photos,
                ),
            child: Container(
              padding: const EdgeInsets.all(PRFSpacingTokens.sm),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: PRFColors.black.withValues(
                      alpha: PRFOpacities.muted,
                    ),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child:
                  BlocConsumer<
                    ChangeProfilePictureCubit,
                    ChangeProfilePictureState
                  >(
                    listener: (context, state) {
                      state.mapOrNull(
                        loaded: (_) {
                          Gaimon.success();
                          PRFSnackbar.success(
                            context,
                            l10n.successfullyUpdated,
                          );
                        },
                        error: (error) {
                          Gaimon.error();
                          PRFSnackbar.error(
                            context,
                            error.message,
                          );
                        },
                      );
                    },
                    builder: (context, state) => state.maybeWhen(
                      orElse: () => const Icon(
                        Icons.camera_alt_rounded,
                        size: 20,
                        color: PRFColors.white,
                      ),
                      loading: () => SizedBox.square(
                        dimension: 20,
                        child: PRFCircularProgressIndicator(
                          color: theme.colorScheme.surface,
                        ),
                      ),
                    ),
                  ),
            ),
          ),
        );
      },
    );
  }
}
