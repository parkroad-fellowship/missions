import 'package:app/features/home/shared/cubit/member_engagement_resource_cubit.dart';
import 'package:app/features/home/wrapped/pages/wrapped_pages.dart';
import 'package:app/features/home/wrapped/wrapped_theme.dart';
import 'package:app/l10n/arb/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prf_design/prf_design.dart';

class WrappedTimeline extends AnimatedWidget {
  const WrappedTimeline({
    required super.listenable,
    required this.pageCount,
    required this.currentPage,
    super.key,
  });

  final int pageCount;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    final progress = (listenable as Animation<double>).value;
    final l10n = AppLocalizations.of(context);

    return Semantics(
      liveRegion: true,
      label: l10n.wrappedProgressSemantics(currentPage + 1, pageCount),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: PRFSpacingTokens.md),
          child: Padding(
            padding: const EdgeInsets.only(top: PRFSpacingTokens.sm),
            child: Row(
              children: List.generate(pageCount, (index) {
                final fill = index < currentPage
                    ? 1.0
                    : index == currentPage
                    ? progress.clamp(0.0, 1.0)
                    : 0.0;

                return Expanded(
                  child: Container(
                    height: 3,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: PRFColors.white.withValues(
                        alpha: PRFOpacities.faint,
                      ),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: fill,
                          child: Container(color: PRFColors.white),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class WrappedPageEntry {
  const WrappedPageEntry({
    required this.title,
    required this.page,
    this.duration = const Duration(seconds: 7),
  });

  final String title;
  final Widget page;
  final Duration duration;
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
        icon: const Icon(Icons.arrow_back, color: PRFColors.white),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.close, color: PRFColors.white, size: 20),
      tooltip: AppLocalizations.of(context).wrappedCloseSemantics,
      onPressed: () => Navigator.of(context).maybePop(),
    );
  }
}

class _StatusScreen extends StatelessWidget {
  const _StatusScreen({
    required this.title,
    required this.message,
    required this.icon,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String message;
  final IconData icon;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRFColors.navy900,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.8, -0.9),
                radius: 1.4,
                colors: [Color(0x3D9DE35D), Color(0x00000000)],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.all(PRFSpacingTokens.sm),
                  child: _BackButton(),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(PRFSpacingTokens.xl),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 84,
                          height: 84,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: PRFColors.white.withValues(
                              alpha: PRFOpacities.subtle,
                            ),
                            border: Border.all(
                              color: PRFColors.white.withValues(
                                alpha: PRFOpacities.muted,
                              ),
                            ),
                          ),
                          child: Icon(
                            icon,
                            size: 36,
                            color: PRFColors.white.withValues(
                              alpha: PRFOpacities.high,
                            ),
                          ),
                        ).animate().fadeIn().scale(
                          begin: const Offset(0.8, 0.8),
                          end: const Offset(1, 1),
                          curve: Curves.easeOutBack,
                        ),
                        const SizedBox(height: PRFSpacingTokens.lg),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: PRFColors.white,
                          ),
                        ).animate(delay: 150.ms).fadeIn(),
                        if (message.trim().isNotEmpty) ...[
                          const SizedBox(height: PRFSpacingTokens.sm),
                          Text(
                            message,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: PRFColors.white.withValues(
                                alpha: PRFOpacities.high,
                              ),
                              height: 1.45,
                            ),
                          ).animate(delay: 300.ms).fadeIn(),
                        ],
                        const SizedBox(height: PRFSpacingTokens.xxl),
                        OutlinedButton(
                          onPressed: onAction,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: PRFColors.white,
                              width: 1.5,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: PRFSpacingTokens.xl,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                PRFRadiusTokens.xxl,
                              ),
                            ),
                          ),
                          child: Text(
                            actionLabel,
                            style: const TextStyle(
                              color: PRFColors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ).animate(delay: 450.ms).fadeIn(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildWrappedLoadingState(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  return Scaffold(
    backgroundColor: PRFColors.navy900,
    body: Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(-0.7, -0.8),
              radius: 1.3,
              colors: [Color(0x2E9DE35D), Color(0x00000000)],
            ),
          ),
        ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0.8, 0.9),
              radius: 1.3,
              colors: [Color(0x406E4CEB), Color(0x00000000)],
            ),
          ),
        ),
        const Positioned(
          top: 0,
          left: 0,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(PRFSpacingTokens.sm),
              child: _CloseButton(),
            ),
          ),
        ),
        const Center(child: PRFCircularProgressIndicator()),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: PRFSpacingTokens.xxl),
            child: Text(
              l10n.wrappedLoadingMessage,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: PRFColors.white.withValues(alpha: PRFOpacities.high),
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildWrappedEmptyState(BuildContext context, AppLocalizations l10n) {
  return _StatusScreen(
    title: l10n.wrappedNoImpactDataTitle,
    message: l10n.wrappedNoImpactDataDescription,
    icon: Icons.insights_rounded,
    actionLabel: l10n.wrappedGoBack,
    onAction: () => Navigator.of(context).maybePop(),
  );
}

Widget buildWrappedErrorState(
  BuildContext context,
  AppLocalizations l10n,
  String message,
) {
  return _StatusScreen(
    title: l10n.wrappedSomethingWentWrong,
    message: message.trim(),
    icon: Icons.error_outline_rounded,
    actionLabel: l10n.wrappedTryAgain,
    onAction: () {
      context.read<MemberEngagementResourceCubit>().loadEngagement(
        year: DateTime.now().year,
      );
    },
  );
}

Widget buildInsufficientDataPage(BuildContext context, AppLocalizations l10n) {
  return Scaffold(
    backgroundColor: PRFColors.navy900,
    body: Stack(
      children: [
        WrappedSlide(
          palette: WrappedPalettes.reflective,
          children: [
            Icon(
              Icons.eco_rounded,
              size: 52,
              color: WrappedPalettes.reflective.accent.withValues(
                alpha: PRFOpacities.glow,
              ),
            ),
            const SizedBox(height: PRFSpacingTokens.md),
            Text(
              l10n.wrappedInsufficientDataTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: PRFColors.white,
              ),
            ).animate(delay: 200.ms).fadeIn(),
            const SizedBox(height: PRFSpacingTokens.sm),
            Text(
              l10n.wrappedInsufficientDataMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: PRFColors.white.withValues(alpha: PRFOpacities.high),
                height: 1.45,
              ),
            ).animate(delay: 400.ms).fadeIn(),
          ],
        ),
        const Positioned(
          top: 0,
          left: 0,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(PRFSpacingTokens.sm),
              child: _BackButton(),
            ),
          ),
        ),
      ],
    ),
  );
}
