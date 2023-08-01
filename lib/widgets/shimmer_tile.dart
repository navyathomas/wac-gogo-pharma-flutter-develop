import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/color_palette.dart';

class ShimmerTile extends StatelessWidget {
  final double? height;
  final double? width;
  final bool? isCircle;
  final double? borderRadius;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  const ShimmerTile(
      {Key? key,
      this.height,
      this.width,
      this.isCircle,
      this.margin,
      this.padding,
      this.borderRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? double.maxFinite,
      width: width ?? double.maxFinite,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: (isCircle ?? false)
              ? null
              : BorderRadius.circular(borderRadius ?? 0.0),
          shape: (isCircle ?? false) ? BoxShape.circle : BoxShape.rectangle),
    );
  }
}

class ShimmerLoader extends StatelessWidget {
  final Widget child;
  const ShimmerLoader({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      highlightColor: ColorPalette.shimmerHighlightColor,
      baseColor: ColorPalette.shimmerBaseColor,
      child: child,
    );
  }
}
