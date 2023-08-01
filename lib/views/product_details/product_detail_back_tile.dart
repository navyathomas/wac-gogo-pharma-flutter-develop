import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/color_palette.dart';

class ProductDetailBackTile extends StatelessWidget {
  final Widget? child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  const ProductDetailBackTile({Key? key, this.child, this.padding, this.margin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: HexColor('#0000000A'),
                  blurRadius: 5.r,
                  spreadRadius: 5.r,
                  offset: const Offset(0,3)
              )
            ]
        ),
        margin: margin ?? EdgeInsets.zero,
        padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: child ?? const SizedBox());
  }
}
