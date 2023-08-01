import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/extensions.dart';

import '../utils/color_palette.dart';

class CustomRadio extends StatelessWidget {
  final VoidCallback? onTap;
  final bool enable;
  final double? heightWidth;
  const CustomRadio({Key? key, this.onTap, this.enable = false, this.heightWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: heightWidth??18.w,
        width: heightWidth??18.w,
        padding: enable ? EdgeInsets.all(5.r) : null,
        decoration: BoxDecoration(
            color: enable ? ColorPalette.primaryColor : Colors.white,
            shape: BoxShape.circle,
            border: enable ? null : Border.all(color: HexColor('#8A9CAC'))),
        child: Container(
            decoration: const BoxDecoration(
                color: Colors.white, shape: BoxShape.circle)),
      ).animatedSwitch(),
    );
  }
}