import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/utils/color_palette.dart';

class CustomDivider extends StatelessWidget {
  final double? height;
  final double? width;

  const CustomDivider({Key? key, this.height, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? .3.h,
      width: width ?? context.sw(),
      color: ColorPalette.dimGrey,
    );
  }
}
