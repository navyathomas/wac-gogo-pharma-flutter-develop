import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/widgets/reusable_widgets.dart';

import '../generated/assets.dart';
import '../utils/color_palette.dart';

class CustomListTileAccountScreen extends StatefulWidget {
  final double? height;
  final double? wholeHeight;
  final double? width;
  final double? textWidgetLeftPadding;
  final Widget? trailingIcon;
  final String? titleText;
  final String? imageIconPath;
  final VoidCallback? onTap;

  const CustomListTileAccountScreen(
      {Key? key,
      this.trailingIcon,
      this.titleText,
      this.onTap,
      this.height,
      this.width,
      this.imageIconPath,
      this.textWidgetLeftPadding,
      this.wholeHeight})
      : super(key: key);

  @override
  State<CustomListTileAccountScreen> createState() =>
      _CustomListTileAccountScreenState();
}

class _CustomListTileAccountScreenState
    extends State<CustomListTileAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        height: widget.wholeHeight ?? 58.h,
        decoration: BoxDecoration(
          color: HexColor("#FFFFFF"),
          borderRadius: BorderRadius.all(Radius.circular(12.r)),
          boxShadow: [
            BoxShadow(
              color: HexColor("#EAF2F2"),
              offset: const Offset(0, 1),
              blurRadius: 1,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 22.5.w,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    widget.imageIconPath ?? "",
                    width: widget.width,
                    height: widget.height,
                    color: HexColor("#000000"),
                  ),
                  SizedBox(
                    width: widget.textWidgetLeftPadding ?? 16.5.w,
                  ),
                  Text(widget.titleText ?? "",
                      style: FontStyle.black14MediumStrong),
                ],
              ),
            ),
            RotatedBox(
              quarterTurns: context.myLocale == 'ar' ? 10 : 0,
              child: SvgPicture.asset(
                Assets.iconsIconFeatherChevronRight,
                width: 3.75.w,
                height: 7.75.h,
                color: HexColor("#8A9CAC"),
              ),
            ),
            SizedBox(
              width: 17.65.w,
            )
          ],
        ),
      ),
    );
  }
}
