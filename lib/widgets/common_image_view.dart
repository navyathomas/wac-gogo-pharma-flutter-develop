import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:octo_image/octo_image.dart';

class CommonImageView extends StatelessWidget {
  final String image;
  final double? height;
  final bool isCircular;
  final BoxFit? boxFit;
  final bool enableLoader;
  final double? width;
  final Alignment? alignment;

  const CommonImageView(
      {Key? key,
      required this.image,
      this.height,
      this.width,
      this.alignment,
      this.enableLoader = true,
      this.boxFit,
      this.isCircular = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OctoImage(
      alignment: alignment,
      image: NetworkImage(image),
      placeholderBuilder: (context) => Container(
        height: height ?? double.maxFinite,
        width: width ?? double.maxFinite,
        decoration: enableLoader
            ? BoxDecoration(
                color: Colors.transparent, //HexColor('E8E8E8'),
                shape: isCircular ? BoxShape.circle : BoxShape.rectangle)
            : null,
        child: enableLoader
            ? Container(
                height: height ?? double.maxFinite,
                width: width ?? double.maxFinite,
                color: ColorPalette.shimmerBaseColor,
              )
            : null,
      ),
      errorBuilder: (context, _, __) => enableLoader
          ? Container(
              height: height ?? double.maxFinite,
              width: width ?? double.maxFinite,
              color: ColorPalette.shimmerBaseColor,
            )
          : const SizedBox(),
      imageBuilder: isCircular ? OctoImageTransformer.circleAvatar() : null,
      fit: boxFit ?? BoxFit.contain,
      height: height ?? double.maxFinite,
      width: width ?? double.maxFinite,
    );
  }
}
