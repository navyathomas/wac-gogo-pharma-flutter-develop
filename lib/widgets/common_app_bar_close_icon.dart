import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gogo_pharma/common/font_style.dart';

class CommonAppBarCloseIcon extends AppBar {
  final double? elevationVal;
  final String? pageTitle;
  final BuildContext? buildContext;
  final SystemUiOverlayStyle? systemCustomOverlayStyle;
  final Color? shadowedColor;
  final Widget? iconButton;
  final TextStyle? textStyle;
  final double? titleSpace;

  CommonAppBarCloseIcon(
      {this.elevationVal,
      this.systemCustomOverlayStyle,
      this.pageTitle,
      this.buildContext,
      this.iconButton,
      this.textStyle,
      this.titleSpace,
      this.shadowedColor,
      Key? key})
      : super(
            key: key,
            title: Text(pageTitle ?? "",
                style: textStyle ?? FontStyle.black15Medium),
            leading: iconButton,
            elevation: elevationVal,
            titleSpacing: titleSpace,
            backgroundColor: Colors.white,
            systemOverlayStyle: systemCustomOverlayStyle,
            shadowColor: shadowedColor);
}
