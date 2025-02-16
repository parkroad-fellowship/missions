import 'package:app/utils/_index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class InputFormField extends StatefulWidget {
  const InputFormField({
    required this.hintText,
    required this.controller,
    super.key,
    this.showSuffix,
    this.hidePassword,
    this.isTextBox,
    this.isUnderLine,
    this.isEmail,
    this.enabled = true,
    this.toggleHidePassword,
    this.onTap,
    this.prefixIconAssetUrl,
    this.readOnly,
    this.keyboardType,
    this.onChanged,
    this.maxLength,
    this.inputFormatters = const [],
    this.maxLines = 1,
    this.textCapitalization = TextCapitalization.none,
  });
  final String hintText;
  final TextEditingController controller;
  final String? prefixIconAssetUrl;
  final bool? showSuffix;
  final bool? hidePassword;
  final VoidCallback? toggleHidePassword;
  final VoidCallback? onTap;
  final VoidCallback? onChanged;
  final bool? isTextBox;
  final bool? isUnderLine;
  final bool? isEmail;
  final bool? enabled;
  final bool? readOnly;
  final TextInputType? keyboardType;
  final int? maxLength;
  final List<TextInputFormatter> inputFormatters;
  final int? maxLines;
  final TextCapitalization textCapitalization;

  @override
  State<InputFormField> createState() => _InputFormFieldState();
}

class _InputFormFieldState extends State<InputFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textCapitalization: widget.textCapitalization,
      keyboardType: widget.keyboardType,
      enabled: widget.enabled,
      readOnly: widget.readOnly ?? false,
      controller: widget.controller,
      maxLength: widget.maxLength,
      obscureText: widget.hidePassword ?? false,
      minLines: widget.toggleHidePassword != null
          ? null
          : widget.isTextBox != null
              ? 3
              : 1,
      maxLines: widget.maxLines,
      onTap: widget.onTap,
      onChanged: widget.onChanged == null ? (_) {} : (_) => widget.onChanged!(),
      inputFormatters: [
        if (widget.keyboardType == TextInputType.number ||
            widget.keyboardType ==
                const TextInputType.numberWithOptions(decimal: true))
          FilteringTextInputFormatter.digitsOnly,
      ],
      style: PRFText.theme().headlineSmall!.copyWith(
            color: widget.isEmail != null
                ? PRFApp.theme().kPrimaryColorV2
                : PRFApp.theme().kBlackColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
      decoration: InputDecoration(
        disabledBorder: widget.isUnderLine != null
            ? UnderlineInputBorder(
                borderSide: BorderSide(
                  color: PRFApp.theme().kAccent4GreyColor,
                ),
              )
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: widget.enabled == false
                      ? PRFApp.theme().kGreyColor
                      : PRFApp.theme().kSecondaryGreyColor,
                ),
              ),
        border: widget.isUnderLine != null
            ? UnderlineInputBorder(
                borderSide: BorderSide(
                  color: PRFApp.theme().kAccent4GreyColor,
                ),
              )
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(
                  color: widget.enabled == false
                      ? PRFApp.theme().kGreyColor
                      : PRFApp.theme().kSecondaryGreyColor,
                ),
              ),
        suffixIcon: (widget.showSuffix == null)
            ? null
            : IconButton(
                onPressed: widget.toggleHidePassword,
                splashRadius: 18,
                icon: Icon(
                  !(widget.hidePassword == null || widget.hidePassword == false)
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: PRFApp.theme().kBlackColor,
                  size: 24,
                ),
              ),
        prefixIcon: !widget.hintText.startsWith('Search')
            ? widget.prefixIconAssetUrl != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: SizedBox(
                      height: 15,
                      width: 15,
                      child: SvgPicture.asset(
                        widget.prefixIconAssetUrl!,
                        height: 15,
                        width: 15,
                      ),
                    ),
                  )
                : null
            : Icon(
                CupertinoIcons.search,
                color: PRFApp.theme().kBlackColor,
                size: 18,
              ),
        contentPadding: widget.isUnderLine != null
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
        fillColor: widget.enabled == false && widget.isUnderLine == null
            ? const Color(0xffF7F7F7)
            : PRFApp.theme().kBackgroundColor,
        filled: widget.enabled == false,
        hintText: widget.hintText,
        hintStyle: PRFText.theme().headlineSmall!.copyWith(
              color: widget.isUnderLine != null
                  ? PRFApp.theme().kAccent12GreyColor
                  : PRFApp.theme().kDullGreyColor,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}
