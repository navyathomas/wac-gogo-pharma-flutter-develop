import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';

import '../utils/color_palette.dart';

class CommonTextFormField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final String? hintText2;
  final TextInputType? inputType;
  final Function? validator;
  final Function? onTap;
  final Function? onEditingComplete;
  final bool isObscure;
  final Widget? prefix;
  final TextStyle? hintFontStyle;
  final Function? onSaved;
  final void Function(String)? onChanged;
  final TextInputAction? inputAction;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? maxLength;
  final bool autoFocus;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final bool defaultFont;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget? customIcon;
  final EdgeInsetsGeometry? contentPadding;
  final FocusNode? focusNode;
  final bool textEnabled;
  final bool textIsReadOnly;
  final double? prefixIconWidth;
  final bool addressHintStyle;
  final bool cancelHintStyle;
  final bool disableFocusNode;
  final bool removeOutlineBorder;
  final ValueChanged<String>? onFieldSubmitted;

  const CommonTextFormField(
      {Key? key,
      this.hintText,
      this.labelText,
      this.prefix,
      this.inputType,
      this.keyboardType,
      this.validator,
      this.hintFontStyle,
      this.onTap,
      this.onEditingComplete,
      this.autoFocus = false,
      this.isObscure = false,
      this.onSaved,
      this.onChanged,
      this.inputAction,
      this.inputFormatters,
      this.controller,
      this.maxLength,
      this.maxLines,
      this.defaultFont = true,
      this.prefixIcon,
      this.contentPadding,
      this.suffixIcon,
      this.focusNode,
      this.customIcon,
      this.textEnabled = true,
      this.textIsReadOnly = false,
      this.hintText2,
      this.addressHintStyle = false,
      this.disableFocusNode = false,
      this.removeOutlineBorder = false,
      this.prefixIconWidth, this.cancelHintStyle=false, this.onFieldSubmitted})
      : super(key: key);

  @override
  State<CommonTextFormField> createState() => _CommonTextFormFieldState();
}

class _CommonTextFormFieldState extends State<CommonTextFormField> {
  ValueNotifier<bool> enableLabel = ValueNotifier(false);
  bool enableObscure = true;

  @override
  Widget build(BuildContext context) {
    final outlinedBorder = !widget.removeOutlineBorder
        ? OutlineInputBorder(
            borderSide: BorderSide(
              color: ColorPalette.primaryColor,
              width: 1.0.r,
            ),
            borderRadius: BorderRadius.all(Radius.circular(8.r)))
        : null;
    final outlinedErrorBorder = !widget.removeOutlineBorder
        ? OutlineInputBorder(
            borderSide: BorderSide(
              color: HexColor("#FC6261"),
              width: 1.0.r,
            ),
            borderRadius: BorderRadius.all(Radius.circular(8.r)))
        : null;
    final outlinedBorderWithoutSelection = !widget.removeOutlineBorder
        ? OutlineInputBorder(
            borderSide: BorderSide(
              color: HexColor("#D9E3E3"),
              width: 1.0.r,
            ),
            borderRadius: BorderRadius.all(Radius.circular(8.r)))
        : null;
    return Theme(
      data: ThemeData(
          hintColor: HexColor('#696969'),
          primarySwatch: ColorPalette.materialPrimary,
          fontFamily: FontStyle.themeFont,
          brightness: Brightness.light,
          appBarTheme: const AppBarTheme(
              systemOverlayStyle: SystemUiOverlayStyle(
                  systemNavigationBarIconBrightness: Brightness.light,
                  statusBarIconBrightness: Brightness.light,
                  statusBarBrightness: Brightness.dark)),
          textSelectionTheme:
              const TextSelectionThemeData(cursorColor: Colors.black)),
      child: TextFormField(

        cursorColor: ColorPalette.primaryColor,
        enabled: widget.textEnabled,
        readOnly: widget.textIsReadOnly,
        focusNode: widget.focusNode,
        maxLines: widget.maxLines ?? 1,
        textInputAction: widget.inputAction,
        keyboardType: widget.inputType,
        controller: widget.controller,
        style: FontStyle.black14MediumW400,
        onFieldSubmitted: widget.onFieldSubmitted,
        validator: widget.validator == null
            ? (val) {
                return null;
              }
            : (val) => widget.validator!(val),
        onChanged: widget.onChanged ??
            (val) {
              if (widget.controller!.text.isNotEmpty) {
                enableLabel.value = true;
              } else {
                enableLabel.value = false;
              }
            },
        autocorrect: false,
        enableSuggestions: false,
        obscureText: widget.isObscure ? enableObscure : false,
        inputFormatters: widget.inputFormatters,
        maxLength: widget.maxLength,
        autofocus: widget.autoFocus,
        textAlign: context.myLocale == 'ar' ? TextAlign.right : TextAlign.left,
        decoration: InputDecoration(
          prefixIconConstraints:
              BoxConstraints(maxWidth: widget.prefixIconWidth ?? 55.w),
          isDense: false,
          prefixIcon: widget.prefixIcon,
          icon: widget.customIcon,
          // floatingLabelBehavior: FloatingLabelBehavior.always,
          border: outlinedBorderWithoutSelection,
          counterText: "",
          enabledBorder: outlinedBorderWithoutSelection,
          disabledBorder: outlinedBorderWithoutSelection,
          focusedBorder: outlinedBorder,
          contentPadding: widget.contentPadding ?? EdgeInsets.all(20.h),
          errorBorder: outlinedErrorBorder,
          focusedErrorBorder: outlinedErrorBorder,
          labelText: widget.labelText,

          //when giving label style the error style will not work it should be styled in main for default
          // labelStyle: widget.focusNode!.hasFocus
          //     ? FontStyle.primary14Medium
          //     : FontStyle.grey14Medium,
          hintStyle: widget.cancelHintStyle?FontStyle.lightCreamGrey14Medium:FontStyle.grey14Medium,
          hintText: widget.hintText,
          prefix: widget.prefix,
          suffixIcon:
              //  widget.isObscure
              // ? IconButton(
              //     icon: Icon(
              //       Icons.remove_red_eye_outlined,
              //       color:
              //           enableObscure ? Colors.black : ColorPalette.primaryColor,
              //     ),
              //     onPressed: () => setState(() {
              //       enableObscure = !enableObscure;
              //     }),
              //   )
              // :
              widget.suffixIcon,
        ),
      ),
    );
  }
}
