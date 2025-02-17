import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GoogleAuthButton extends StatelessWidget {
  const GoogleAuthButton({
    required this.onPressed,
    required this.title,
    required this.disabled,
    super.key,
    this.isLoading,
  });

  final VoidCallback onPressed;
  final String title;
  final bool disabled;
  final bool? isLoading;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return MaterialButton(
          color: const Color(0xffFAFAFA),
          minWidth: double.infinity,
          height: 55,
          elevation: 0,
          highlightElevation: 0,
          focusElevation: 0,
          hoverElevation: 0,
          disabledElevation: 0,
          onPressed: onPressed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: const BorderSide(color: Colors.grey),
          ),
          child: SizedBox(
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Spacer(),
                if (isLoading ?? false) ...[
                  const SizedBox(width: 16),
                  SizedBox(
                    height: 14,
                    width: 14,
                    child: CircularProgressIndicator(
                      color: Colors.black.withValues(alpha: .4),
                      backgroundColor: const Color(0xffFAFAFA),
                      strokeWidth: 2,
                    ),
                  ),
                  const SizedBox(width: 8),
                ] else
                  const SizedBox.shrink(),
                const Spacer(),
                SizedBox(
                  height: 18,
                  width: 18,
                  child: SvgPicture.asset(
                    (isLoading ?? false)
                        ? 'assets/images/authentication/google_logo_loading.svg'
                        : 'assets/images/authentication/google_logo.svg',
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.normal,
                    color:
                        (isLoading ?? false)
                            ? Colors.black.withValues(alpha: .4)
                            : Colors.black,
                    fontFamily: 'Helvetica Neue',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                if (isLoading ?? false) ...[
                  const SizedBox(height: 14, width: 38),
                ] else
                  const SizedBox.shrink(),
                const Spacer(),
              ],
            ),
          ),
        );
      },
    );
  }
}
