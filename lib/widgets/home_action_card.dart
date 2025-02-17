import 'package:app/utils/_index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeActionCard extends StatelessWidget {
  const HomeActionCard({
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
    final width = MediaQuery.sizeOf(context).width;
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: width,
            padding: EdgeInsets.symmetric(horizontal: 100.w, vertical: 80.h),
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: PRFApp.theme().kSecondaryColorV2.withValues(alpha: 1),
              borderRadius: BorderRadius.circular(48.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(assetPath, height: 250.h),
                SizedBox(height: 100.h),
                Text(
                  title,
                  style: PRFText.theme().displayLarge?.copyWith(
                    color: PRFApp.theme().kPrimaryColorV2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: SizedBox(height: 225.h, width: 210.w),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 140.r,
              child: Container(
                decoration: BoxDecoration(
                  color: PRFApp.theme().kPrimaryColorV2,
                  shape: BoxShape.circle,
                ),
                child: SizedBox(
                  width: 230.w,
                  height: 230.h,
                  child: IconButton(
                    icon: Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 400.dg,
                    ),
                    onPressed: () {},
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
