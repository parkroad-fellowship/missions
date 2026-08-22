import 'dart:io';
import 'dart:ui' as ui;

import 'package:app/features/home/wrapped/wrapped_theme.dart';
import 'package:app/l10n/l10n.dart';
import 'package:app/models/remote/member/prf_member_engagement.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gaimon/gaimon.dart';
import 'package:path_provider/path_provider.dart';
import 'package:prf_design/prf_design.dart';
import 'package:share_plus/share_plus.dart';

// =============================================================================
// SLIDE SCAFFOLD + BACKDROP
// =============================================================================

class WrappedSlide extends StatelessWidget {
  const WrappedSlide({
    required this.palette,
    required this.children,
    this.scrollable = false,
    super.key,
  });

  final WrappedPalette palette;
  final List<Widget> children;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );

    return ColoredBox(
      color: palette.base,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _WrappedBackdrop(palette: palette),
          Positioned(
            right: -44,
            bottom: -36,
            child: ExcludeSemantics(
              child: Icon(
                palette.glyph,
                size: 300,
                color: palette.accent.withValues(alpha: 0.06),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: scrollable
                  ? SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        vertical: PRFSpacingTokens.xxl,
                      ),
                      child: content,
                    )
                  : content,
            ),
          ),
          if (scrollable && !reducedMotion)
            const Align(
              alignment: Alignment(0, 0.94),
              child: _ScrollCue(),
            ),
        ],
      ),
    );
  }
}

class _ScrollCue extends StatelessWidget {
  const _ScrollCue();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ExcludeSemantics(
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: PRFColors.black.withValues(alpha: PRFOpacities.muted),
          ),
          child: Padding(
            padding: const EdgeInsets.all(PRFSpacingTokens.sm),
            child:
                const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20,
                      color: PRFColors.white,
                    )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .slideY(
                      begin: -0.25,
                      end: 0.25,
                      duration: 900.ms,
                      curve: Curves.easeInOut,
                    ),
          ),
        ),
      ).animate(delay: 2400.ms).fadeOut(duration: 400.ms),
    );
  }
}

class _WrappedBackdrop extends StatelessWidget {
  const _WrappedBackdrop({required this.palette});

  final WrappedPalette palette;

  static const List<(Alignment, double, Offset, Offset, int)> _blobs = [
    (
      Alignment(-0.55, -0.75),
      340.0,
      Offset(26, -18),
      Offset(-30, 24),
      5500,
    ),
    (
      Alignment(0.75, -0.3),
      300.0,
      Offset(-32, 22),
      Offset(28, -20),
      6500,
    ),
    (
      Alignment(-0.15, 0.85),
      380.0,
      Offset(18, -26),
      Offset(-22, 18),
      7500,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Stack(
        fit: StackFit.expand,
        children: [
          for (final (i, blob) in _blobs.indexed)
            Positioned.fill(
              child: Align(
                alignment: blob.$1,
                child: _blobContainer(blob, i),
              ),
            ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                radius: 1.2,
                colors: [Color(0x00000000), Color(0x61000000)],
                stops: [0.55, 1],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _blobContainer(
    (Alignment, double, Offset, Offset, int) blob,
    int index,
  ) {
    final color = palette.blobs[index % palette.blobs.length];
    final alpha = [0.5, 0.42, 0.36][index % 3];

    return Container(
          width: blob.$2,
          height: blob.$2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                color.withValues(alpha: alpha),
                color.withValues(alpha: 0),
              ],
            ),
          ),
        )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .move(
          begin: blob.$3,
          end: blob.$4,
          duration: blob.$5.ms,
          curve: Curves.easeInOut,
        );
  }
}

// =============================================================================
// SHARED BUILDING BLOCKS
// =============================================================================

class HeroNumber extends StatelessWidget {
  const HeroNumber({
    required this.value,
    this.label,
    this.accent = PRFColors.white,
    this.numberSize = 132,
    super.key,
  });

  final int value;
  final String? label;
  final Color accent;
  final double numberSize;

  @override
  Widget build(BuildContext context) {
    final reducedMotion = MediaQuery.disableAnimationsOf(context);

    final number = Semantics(
      label: value.toString(),
      excludeSemantics: true,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.86,
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: reducedMotion
              ? Text(
                  value.toString(),
                  style: TextStyle(
                    fontSize: numberSize,
                    fontWeight: FontWeight.w900,
                    color: accent,
                    height: 0.95,
                    letterSpacing: -2,
                  ),
                )
              : TweenAnimationBuilder<int>(
                  tween: IntTween(begin: 0, end: value),
                  duration: const Duration(milliseconds: 1600),
                  curve: Curves.easeOutExpo,
                  builder: (context, count, _) {
                    return Text(
                      count.toString(),
                      style: TextStyle(
                        fontSize: numberSize,
                        fontWeight: FontWeight.w900,
                        color: accent,
                        height: 0.95,
                        letterSpacing: -2,
                      ),
                    );
                  },
                ),
        ),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (reducedMotion)
          number
        else
          number
              .animate(delay: 250.ms)
              .fadeIn(duration: 500.ms)
              .scale(
                begin: const Offset(0.85, 0.85),
                end: const Offset(1, 1),
                curve: Curves.easeOutBack,
              ),
        if (label != null) ...[
          const SizedBox(height: PRFSpacingTokens.md),
          Text(
                label!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: PRFColors.white.withValues(alpha: PRFOpacities.high),
                  letterSpacing: 0.4,
                ),
              )
              .animate(delay: 550.ms)
              .fadeIn(duration: 450.ms)
              .slideY(begin: 0.25, end: 0),
        ],
      ],
    );
  }
}

class _Eyebrow extends StatelessWidget {
  const _Eyebrow(this.text, {this.color = _mutedWhite});

  static const _mutedWhite = Color(0xB3FFFFFF);

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: 3,
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.3, end: 0);
  }
}

class _GlowPill extends StatelessWidget {
  const _GlowPill({
    required this.icon,
    required this.text,
    required this.accent,
  });

  final IconData icon;
  final String text;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: PRFSpacingTokens.lg,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: PRFColors.white.withValues(alpha: PRFOpacities.subtle),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: PRFColors.white.withValues(alpha: PRFOpacities.muted),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: accent),
          const SizedBox(width: PRFSpacingTokens.xs),
          Flexible(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: PRFColors.white,
              ),
            ),
          ),
        ],
      ),
    ).animate(delay: 800.ms).fadeIn().slideY(begin: 0.15, end: 0);
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: PRFColors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: PRFColors.white.withValues(alpha: PRFOpacities.prominent),
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 34,
      margin: const EdgeInsets.symmetric(horizontal: PRFSpacingTokens.xl),
      color: PRFColors.white.withValues(alpha: PRFOpacities.muted),
    );
  }
}

class _SpotlightCard extends StatelessWidget {
  const _SpotlightCard({
    required this.title,
    required this.subtitle,
    required this.accent,
    this.icon,
  });

  final String title;
  final String subtitle;
  final Color accent;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
          constraints: const BoxConstraints(maxWidth: 320),
          padding: const EdgeInsets.all(PRFSpacingTokens.lg),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                PRFColors.white.withValues(alpha: PRFOpacities.subtle),
                PRFColors.white.withValues(alpha: PRFOpacities.faint),
              ],
            ),
            borderRadius: BorderRadius.circular(PRFRadiusTokens.lg),
            border: Border.all(
              color: accent.withValues(alpha: PRFOpacities.muted),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 26, color: accent),
                const SizedBox(height: PRFSpacingTokens.sm),
              ],
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: PRFColors.white,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: PRFSpacingTokens.xs),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: PRFColors.white.withValues(
                    alpha: PRFOpacities.prominent,
                  ),
                  height: 1.35,
                ),
              ),
            ],
          ),
        )
        .animate(delay: 700.ms)
        .fadeIn(duration: 500.ms)
        .slideY(begin: 0.15, end: 0);
  }
}

class _RankBar extends StatelessWidget {
  const _RankBar({
    required this.label,
    required this.count,
    required this.factor,
    required this.accent,
    required this.delay,
  });

  final String label;
  final int count;
  final double factor;
  final Color accent;
  final int delay;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 108,
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: PRFColors.white,
            ),
          ),
        ),
        const SizedBox(width: PRFSpacingTokens.sm),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: Stack(
              children: [
                Container(
                  height: 10,
                  color: PRFColors.white.withValues(alpha: PRFOpacities.faint),
                ),
                FractionallySizedBox(
                      widthFactor: factor.clamp(0.04, 1),
                      child: Container(
                        height: 10,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [accent, accent.withValues(alpha: 0.65)],
                          ),
                        ),
                      ),
                    )
                    .animate(delay: delay.ms)
                    .scaleX(
                      begin: 0,
                      end: 1,
                      alignment: Alignment.centerLeft,
                      duration: 900.ms,
                      curve: Curves.easeOutCubic,
                    ),
              ],
            ),
          ),
        ),
        const SizedBox(width: PRFSpacingTokens.sm),
        SizedBox(
          width: 36,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              count.toString(),
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: PRFColors.white,
              ),
            ),
          ),
        ),
      ],
    ).animate(delay: delay.ms).fadeIn(duration: 400.ms);
  }
}

class _ProgressRing extends StatelessWidget {
  const _ProgressRing({
    required this.percentage,
    required this.accent,
    required this.label,
  });

  final double percentage;
  final Color accent;
  final String label;

  @override
  Widget build(BuildContext context) {
    final progress = percentage.clamp(0, 100) / 100;
    final reducedMotion = MediaQuery.disableAnimationsOf(context);

    final ring = SizedBox(
      width: 96,
      height: 96,
      child: CustomPaint(
        painter: _RingPainter(progress: progress, accent: accent),
        child: Center(
          child: Text(
            '${percentage.round()}%',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: PRFColors.white,
            ),
          ),
        ),
      ),
    );

    return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (reducedMotion)
              ring
            else
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: progress),
                duration: const Duration(milliseconds: 1400),
                curve: Curves.easeOutCubic,
                builder: (context, value, _) => SizedBox(
                  width: 96,
                  height: 96,
                  child: CustomPaint(
                    painter: _RingPainter(progress: value, accent: accent),
                    child: Center(
                      child: Text(
                        '${percentage.round()}%',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: PRFColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: PRFSpacingTokens.sm),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: PRFColors.white.withValues(
                  alpha: PRFOpacities.prominent,
                ),
                letterSpacing: 1.2,
              ),
            ),
          ],
        )
        .animate(delay: 600.ms)
        .fadeIn(duration: 500.ms)
        .scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1, 1),
          curve: Curves.easeOutBack,
        );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({required this.progress, required this.accent});

  final double progress;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..color = PRFColors.white.withValues(alpha: PRFOpacities.faint);

    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..shader = LinearGradient(
        colors: [accent, accent.withValues(alpha: 0.55)],
      ).createShader(Offset.zero & size);

    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2 - 4;

    canvas
      ..drawCircle(center, radius, trackPaint)
      ..drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -1.5708,
        6.2832 * progress,
        false,
        progressPaint,
      );
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.accent != accent;
}

class _EmptySectionContent extends StatelessWidget {
  const _EmptySectionContent({required this.message, required this.icon});

  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 48,
          color: PRFColors.white.withValues(alpha: PRFOpacities.glow),
        ),
        const SizedBox(height: PRFSpacingTokens.lg),
        Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: PRFColors.white.withValues(alpha: PRFOpacities.high),
            height: 1.4,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0);
  }
}

String _humanize(String raw) {
  final parts = raw.replaceAll('_', ' ').trim().split(' ')
    ..removeWhere((element) => element.isEmpty);
  return parts
      .map(
        (part) => part.isEmpty
            ? part
            : '${part[0].toUpperCase()}${part.substring(1).toLowerCase()}',
      )
      .join(' ');
}

// =============================================================================
// PAGE WIDGETS
// =============================================================================

class IntroWrappedPage extends StatelessWidget {
  const IntroWrappedPage({
    required this.memberName,
    required this.year,
    super.key,
  });

  final String memberName;
  final int year;

  @override
  Widget build(BuildContext context) {
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    final yearText = Text(
      '$year',
      style: const TextStyle(
        fontSize: 128,
        fontWeight: FontWeight.w900,
        color: PRFColors.white,
        height: 1,
        letterSpacing: -4,
      ),
    );

    return WrappedSlide(
      palette: WrappedPalettes.intro,
      scrollable: true,
      children: [
        _Eyebrow(
          context.l10n.wrappedTagline,
          color: WrappedPalettes.intro.accent,
        ),
        const SizedBox(height: PRFSpacingTokens.lg),
        if (reducedMotion)
          yearText
        else
          yearText
              .animate(delay: 300.ms)
              .fadeIn(duration: 600.ms)
              .scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1, 1),
                curve: Curves.easeOutBack,
              ),
        const SizedBox(height: PRFSpacingTokens.md),
        Text(
              memberName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: PRFColors.white,
                height: 1.1,
              ),
            )
            .animate(delay: 700.ms)
            .fadeIn(duration: 550.ms)
            .slideY(begin: 0.3, end: 0),
        const SizedBox(height: PRFSpacingTokens.xl),
        Text(
          context.l10n.wrappedSwipeHint,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: PRFColors.white.withValues(alpha: PRFOpacities.prominent),
            letterSpacing: 0.6,
          ),
        ).animate(delay: 1200.ms).fadeIn(duration: 500.ms),
      ],
    );
  }
}

class MissionsWrappedPage extends StatelessWidget {
  const MissionsWrappedPage({
    required this.missionStats,
    super.key,
  });

  final MissionStats missionStats;

  @override
  Widget build(BuildContext context) {
    const palette = WrappedPalettes.missions;

    if (missionStats.totalMissions == 0) {
      return WrappedSlide(
        palette: palette,
        children: [
          _EmptySectionContent(
            message: context.l10n.wrappedMissionsEmptyMessage,
            icon: Icons.explore_outlined,
          ),
        ],
      );
    }

    return WrappedSlide(
      palette: palette,
      scrollable: true,
      children: [
        _Eyebrow(context.l10n.wrappedMissionsTitle),
        const SizedBox(height: PRFSpacingTokens.lg),
        HeroNumber(
          value: missionStats.totalMissions,
          label: context.l10n.missionsCompleted,
          accent: palette.accent,
        ),
        if (missionStats.missionStreak > 0) ...[
          const SizedBox(height: PRFSpacingTokens.xl),
          _GlowPill(
            icon: Icons.local_fire_department_rounded,
            text: context.l10n.wrappedMissionStreakTitle(
              missionStats.missionStreak,
            ),
            accent: const Color(0xFFFF8A00),
          ),
          const SizedBox(height: PRFSpacingTokens.xs),
          Text(
            context.l10n.wrappedMissionStreakSubtitle,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: PRFColors.white.withValues(alpha: PRFOpacities.prominent),
            ),
          ).animate(delay: 950.ms).fadeIn(),
        ],
        const SizedBox(height: PRFSpacingTokens.xxl),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _MiniStat(
              value: missionStats.schoolsReached.toString(),
              label: context.l10n.wrappedSchoolsReached,
            ),
            const _StatDivider(),
            _MiniStat(
              value: '${(missionStats.completionRate * 100).round()}%',
              label: context.l10n.wrappedCompletion,
            ),
          ],
        ).animate(delay: 1050.ms).fadeIn().slideY(begin: 0.2, end: 0),
        if (missionStats.favoriteMissionType != null) ...[
          const SizedBox(height: PRFSpacingTokens.xl),
          Text(
            context.l10n.wrappedFavoriteMissionType(
              _humanize(missionStats.favoriteMissionType!.name),
            ),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: palette.accent,
            ),
          ).animate(delay: 1250.ms).fadeIn(),
        ],
      ],
    );
  }
}

class ImpactWrappedPage extends StatelessWidget {
  const ImpactWrappedPage({
    required this.impactStats,
    super.key,
  });

  final ImpactStats impactStats;

  @override
  Widget build(BuildContext context) {
    const palette = WrappedPalettes.impact;

    if (impactStats.soulsTouched == 0) {
      return WrappedSlide(
        palette: palette,
        children: [
          _EmptySectionContent(
            message: context.l10n.wrappedImpactEmptyMessage,
            icon: Icons.favorite_rounded,
          ),
        ],
      );
    }

    final decisionTypes = [...impactStats.decisionTypes]
      ..sort((a, b) => b.count.compareTo(a.count));
    final topTypes = decisionTypes.take(4).toList();
    final maxCount = topTypes.fold<int>(
      1,
      (max, type) => type.count > max ? type.count : max,
    );

    return WrappedSlide(
      palette: palette,
      scrollable: true,
      children: [
        _Eyebrow(context.l10n.wrappedImpactTitle),
        const SizedBox(height: PRFSpacingTokens.lg),
        HeroNumber(
          value: impactStats.soulsTouched,
          label: context.l10n.soulsTouched,
          accent: palette.accent,
        ),
        if (impactStats.mostImpactfulMission != null) ...[
          const SizedBox(height: PRFSpacingTokens.xl),
          _SpotlightCard(
            title: impactStats.mostImpactfulMission!.name,
            subtitle: context.l10n.wrappedMostImpactfulMissionSubtitle(
              impactStats.mostImpactfulMission!.soulsCount,
            ),
            accent: palette.accent,
            icon: Icons.star_rounded,
          ),
        ],
        if (topTypes.isNotEmpty) ...[
          const SizedBox(height: PRFSpacingTokens.xxl),
          _Eyebrow(context.l10n.wrappedDecisionTypes),
          const SizedBox(height: PRFSpacingTokens.xs),
          Text(
            context.l10n.wrappedDecisionTypesSubtitle,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: PRFColors.white.withValues(alpha: PRFOpacities.prominent),
            ),
          ).animate(delay: 200.ms).fadeIn(),
          const SizedBox(height: PRFSpacingTokens.lg),
          for (final (index, type) in topTypes.indexed)
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: PRFSpacingTokens.sm,
              ),
              child: _RankBar(
                label: _humanize(type.type),
                count: type.count,
                factor: type.count / maxCount,
                accent: palette.accent,
                delay: 850 + index * 150,
              ),
            ),
        ],
      ],
    );
  }
}

class LearningWrappedPage extends StatelessWidget {
  const LearningWrappedPage({
    required this.learningStats,
    super.key,
  });

  final LearningStats learningStats;

  @override
  Widget build(BuildContext context) {
    const palette = WrappedPalettes.learning;

    if (learningStats.coursesCompleted == 0 &&
        learningStats.lessonsCompleted == 0) {
      return WrappedSlide(
        palette: palette,
        children: [
          _EmptySectionContent(
            message: context.l10n.wrappedLearningEmptyMessage,
            icon: Icons.menu_book_rounded,
          ),
        ],
      );
    }

    return WrappedSlide(
      palette: palette,
      scrollable: true,
      children: [
        _Eyebrow(context.l10n.wrappedLearningTitle),
        const SizedBox(height: PRFSpacingTokens.lg),
        HeroNumber(
          value: learningStats.coursesCompleted,
          label: context.l10n.coursesCompleted,
          accent: palette.accent,
        ),
        const SizedBox(height: PRFSpacingTokens.xxl),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _ProgressRing(
              percentage: learningStats.learningProgressPercentage,
              accent: palette.accent,
              label: context.l10n.wrappedOverallProgress,
            ),
            const _StatDivider(),
            _MiniStat(
              value: learningStats.lessonsCompleted.toString(),
              label: context.l10n.wrappedLessonsCompleted,
            ),
          ],
        ).animate(delay: 650.ms).fadeIn().slideY(begin: 0.15, end: 0),
        if (learningStats.learningStreak > 0) ...[
          const SizedBox(height: PRFSpacingTokens.xl),
          _GlowPill(
            icon: Icons.flash_on_rounded,
            text: context.l10n.wrappedLearningStreakTitle(
              learningStats.learningStreak,
            ),
            accent: const Color(0xFFFFD400),
          ),
          const SizedBox(height: PRFSpacingTokens.xs),
          Text(
            context.l10n.wrappedLearningStreakSubtitle,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: PRFColors.white.withValues(alpha: PRFOpacities.prominent),
            ),
          ).animate(delay: 1000.ms).fadeIn(),
        ],
        if (learningStats.favoriteCourse != null) ...[
          const SizedBox(height: PRFSpacingTokens.xl),
          _SpotlightCard(
            title: learningStats.favoriteCourse!.name,
            subtitle: context.l10n.wrappedCourseProgress(
              learningStats.favoriteCourse!.progressPercentage.round(),
            ),
            accent: palette.accent,
            icon: Icons.school_rounded,
          ),
        ],
      ],
    );
  }
}

class PrayerWrappedPage extends StatelessWidget {
  const PrayerWrappedPage({
    required this.prayerStats,
    super.key,
  });

  final PrayerStats prayerStats;

  @override
  Widget build(BuildContext context) {
    const palette = WrappedPalettes.prayer;

    if (prayerStats.prayerResponses == 0 &&
        prayerStats.prayerConsistencyDays == 0) {
      return WrappedSlide(
        palette: palette,
        children: [
          _EmptySectionContent(
            message: context.l10n.wrappedPrayerEmptyMessage,
            icon: Icons.volunteer_activism_rounded,
          ),
        ],
      );
    }

    return WrappedSlide(
      palette: palette,
      children: [
        _Eyebrow(context.l10n.wrappedPrayerTitle),
        const SizedBox(height: PRFSpacingTokens.lg),
        HeroNumber(
          value: prayerStats.prayerResponses,
          label: context.l10n.prayerResponses,
          accent: palette.accent,
        ),
        if (prayerStats.prayerConsistencyDays > 0) ...[
          const SizedBox(height: PRFSpacingTokens.xl),
          _GlowPill(
            icon: Icons.auto_awesome_rounded,
            text: context.l10n.wrappedPrayerConsistencyTitle(
              prayerStats.prayerConsistencyDays,
            ),
            accent: palette.accent,
          ),
          const SizedBox(height: PRFSpacingTokens.xs),
          Text(
            context.l10n.wrappedPrayerConsistencySubtitle,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: PRFColors.white.withValues(alpha: PRFOpacities.prominent),
            ),
          ).animate(delay: 1000.ms).fadeIn(),
        ],
      ],
    );
  }
}

class EventsWrappedPage extends StatelessWidget {
  const EventsWrappedPage({
    required this.eventStats,
    super.key,
  });

  final EventStats eventStats;

  @override
  Widget build(BuildContext context) {
    const palette = WrappedPalettes.events;

    return WrappedSlide(
      palette: palette,
      scrollable: true,
      children: [
        _Eyebrow(context.l10n.wrappedEventsTitle),
        const SizedBox(height: PRFSpacingTokens.lg),
        HeroNumber(
          value: eventStats.eventsAttended,
          label: context.l10n.eventsAttended,
          accent: palette.accent,
        ),
        const SizedBox(height: PRFSpacingTokens.xxl),
        _SpotlightCard(
          title: context.l10n.wrappedActiveParticipantTitle,
          subtitle: context.l10n.wrappedActiveParticipantSubtitle,
          accent: palette.accent,
          icon: Icons.emoji_events_rounded,
        ),
        if (eventStats.upcomingEvents > 0) ...[
          const SizedBox(height: PRFSpacingTokens.xl),
          _MiniStat(
            value: eventStats.upcomingEvents.toString(),
            label: context.l10n.wrappedUpcomingEvents,
          ).animate(delay: 1100.ms).fadeIn(),
        ],
      ],
    );
  }
}

class SummaryWrappedPage extends StatefulWidget {
  const SummaryWrappedPage({
    required this.memberEngagement,
    required this.year,
    super.key,
  });

  final PRFMemberEngagement memberEngagement;
  final int year;

  @override
  State<SummaryWrappedPage> createState() => _SummaryWrappedPageState();
}

class _SummaryWrappedPageState extends State<SummaryWrappedPage> {
  final GlobalKey _cardKey = GlobalKey();
  bool _sharing = false;

  PRFMemberEngagement get _m => widget.memberEngagement;

  String _shareText() {
    return context.l10n.wrappedShareText(
      widget.year,
      _m.missionStats.totalMissions,
      _m.impactStats.soulsTouched,
      _m.learningStats.coursesCompleted,
      _m.eventStats.eventsAttended,
      _m.prayerStats.prayerResponses,
    );
  }

  Future<void> _shareCard() async {
    if (_sharing) return;
    setState(() => _sharing = true);

    try {
      final boundary = _cardKey.currentContext?.findRenderObject();
      XFile? cardImage;

      if (boundary is RenderRepaintBoundary) {
        if (boundary.debugNeedsPaint) {
          await Future<void>.delayed(Duration.zero);
        }
        final image = await boundary.toImage(pixelRatio: 3);
        final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
        image.dispose();

        if (byteData != null && mounted) {
          final directory = await getTemporaryDirectory();
          final file = File('${directory.path}/prf_wrapped_${widget.year}.png');
          await file.writeAsBytes(byteData.buffer.asUint8List());
          cardImage = XFile(file.path);
        }
      }

      await SharePlus.instance.share(
        ShareParams(
          files: cardImage != null ? [cardImage] : null,
          text: _shareText(),
        ),
      );
      Gaimon.success();
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final aboveAverage = _m.comparativeStats?.aboveAverage ?? const [];

    return WrappedSlide(
      palette: WrappedPalettes.finale,
      scrollable: true,
      children: [
        Text(
          l10n.wrappedSummaryTitle,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w900,
            color: PRFColors.white,
            letterSpacing: -0.5,
          ),
        ).animate(delay: 150.ms).fadeIn().slideY(begin: 0.25, end: 0),
        const SizedBox(height: PRFSpacingTokens.xl),
        RepaintBoundary(
              key: _cardKey,
              child: _RecapCard(engagement: _m, year: widget.year),
            )
            .animate(delay: 300.ms)
            .fadeIn(duration: 550.ms)
            .slideY(begin: 0.12, end: 0)
            .scale(
              begin: const Offset(0.92, 0.92),
              end: const Offset(1, 1),
              curve: Curves.easeOutBack,
            ),
        const SizedBox(height: PRFSpacingTokens.lg),
        Text(
          l10n.wrappedCommunalLine(widget.year),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: PRFColors.white.withValues(alpha: PRFOpacities.stronger),
            height: 1.4,
          ),
        ).animate(delay: 450.ms).fadeIn(),
        if (aboveAverage.isNotEmpty) ...[
          const SizedBox(height: PRFSpacingTokens.md),
          Text(
            l10n.wrappedAboveAverage(aboveAverage.map(_humanize).join(', ')),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: WrappedPalettes.finale.accent,
            ),
          ).animate(delay: 500.ms).fadeIn(),
        ],
        const SizedBox(height: PRFSpacingTokens.xl),
        Semantics(
          button: true,
          child: FilledButton.icon(
            onPressed: _sharing ? null : _shareCard,
            icon: _sharing
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: PRFColors.navyBlue,
                    ),
                  )
                : const Icon(
                    Icons.ios_share_rounded,
                    color: PRFColors.navyBlue,
                  ),
            label: Text(
              l10n.wrappedShareCta,
              style: const TextStyle(
                color: PRFColors.navyBlue,
                fontWeight: FontWeight.w900,
                fontSize: 15,
              ),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: WrappedPalettes.finale.accent,
              padding: const EdgeInsets.symmetric(
                horizontal: PRFSpacingTokens.xl,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(PRFRadiusTokens.xxl),
              ),
            ),
          ),
        ).animate(delay: 650.ms).fadeIn().slideY(begin: 0.15, end: 0),
        const SizedBox(height: PRFSpacingTokens.md),
        TextButton(
          onPressed: () => Navigator.of(context).maybePop(),
          child: Text(
            l10n.wrappedGoBack,
            style: TextStyle(
              color: PRFColors.white.withValues(alpha: PRFOpacities.prominent),
              fontWeight: FontWeight.w600,
            ),
          ),
        ).animate(delay: 750.ms).fadeIn(),
        const SizedBox(height: PRFSpacingTokens.lg),
        Text(
          l10n.wrappedThankYouPersonal(_m.memberName, widget.year),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: PRFColors.white.withValues(alpha: PRFOpacities.prominent),
            height: 1.4,
          ),
        ).animate(delay: 850.ms).fadeIn(),
        const SizedBox(height: PRFSpacingTokens.xs),
        Text(
          l10n.wrappedNextYearCta,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: WrappedPalettes.finale.accent,
          ),
        ).animate(delay: 950.ms).fadeIn(),
      ],
    );
  }
}

class _RecapCard extends StatelessWidget {
  const _RecapCard({required this.engagement, required this.year});

  final PRFMemberEngagement engagement;
  final int year;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final rows = <(String, String)>[
      (
        engagement.missionStats.totalMissions.toString(),
        l10n.wrappedMissionsLabel,
      ),
      (
        engagement.impactStats.soulsTouched.toString(),
        l10n.soulsTouched,
      ),
      (
        engagement.learningStats.coursesCompleted.toString(),
        l10n.wrappedCoursesLabel,
      ),
      if (engagement.prayerStats.prayerResponses > 0)
        (
          engagement.prayerStats.prayerResponses.toString(),
          l10n.prayerResponses,
        ),
      if (engagement.eventStats.eventsAttended > 0)
        (
          engagement.eventStats.eventsAttended.toString(),
          l10n.wrappedEventsLabel,
        ),
    ];

    return Container(
      constraints: const BoxConstraints(maxWidth: 340),
      padding: const EdgeInsets.all(PRFSpacingTokens.xl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [PRFColors.navyBlue, PRFColors.navy900],
        ),
        borderRadius: BorderRadius.circular(PRFRadiusTokens.xxl),
        border: Border.all(
          color: WrappedPalettes.finale.accent.withValues(
            alpha: PRFOpacities.glow,
          ),
          width: 1.2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: WrappedPalettes.finale.accent,
                  borderRadius: BorderRadius.circular(PRFRadiusTokens.md),
                ),
                child: const Icon(
                  Icons.explore_rounded,
                  color: PRFColors.navy900,
                  size: 22,
                ),
              ),
              const SizedBox(width: PRFSpacingTokens.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.wrappedTagline.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: WrappedPalettes.finale.accent,
                        letterSpacing: 2.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.wrappedHighlightsTitle(year),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: PRFColors.white,
                        height: 1.05,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: PRFSpacingTokens.lg),
          Divider(
            color: PRFColors.white.withValues(alpha: PRFOpacities.hairline),
          ),
          const SizedBox(height: PRFSpacingTokens.sm),
          for (final (i, row) in rows.indexed) ...[
            if (i > 0) const SizedBox(height: PRFSpacingTokens.sm),
            _RecapRow(value: row.$1, label: row.$2),
          ],
          const SizedBox(height: PRFSpacingTokens.md),
          Divider(
            color: PRFColors.white.withValues(alpha: PRFOpacities.hairline),
          ),
          const SizedBox(height: PRFSpacingTokens.sm),
          Text(
            l10n.wrappedHighlightsSubtitle,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: PRFColors.white.withValues(
                alpha: PRFOpacities.prominent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecapRow extends StatelessWidget {
  const _RecapRow({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 52,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: WrappedPalettes.finale.accent,
            ),
          ),
        ),
        const SizedBox(width: PRFSpacingTokens.md),
        Expanded(
          child: Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: PRFColors.white.withValues(alpha: PRFOpacities.high),
              letterSpacing: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
