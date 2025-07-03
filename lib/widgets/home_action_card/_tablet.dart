import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeActionCardTablet extends StatelessWidget {
  const HomeActionCardTablet({
    required this.title,
    required this.assetPath,
    this.onTap,
    super.key,
  });

  final String title;
  final String assetPath;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final scaleFactor = Misc.getScaleFactor(context);
    
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: width,
            padding: EdgeInsets.fromLTRB(
              100 * scaleFactor,
              80 * scaleFactor,
              300 * scaleFactor,
              80 * scaleFactor,
            ),
            margin: const EdgeInsets.symmetric(horizontal: 32),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary,
              borderRadius: BorderRadius.circular(48 * scaleFactor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(assetPath, height: 250 * scaleFactor),
                SizedBox(height: 100 * scaleFactor),
                Text(
                  title,
                  style: theme.textTheme.displayMedium?.copyWith(
                    color: theme.colorScheme.onSecondary,
                    fontWeight: FontWeight.w700,
                    fontSize: 36,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 40 * scaleFactor),
              ],
            ),
          ),
          Positioned(
            right: 32,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: SizedBox.square(dimension: 220 * scaleFactor),
            ),
          ),
          Positioned(
            right: 32,
            bottom: 0,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 140 * scaleFactor,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: SizedBox.square(
                  dimension: 230 * scaleFactor,
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 100 * scaleFactor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
