import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';

import '../../common/constants.dart';
import '../../utils/color_palette.dart';

class SummaryTabTile extends StatelessWidget {
  final int pageViewIndex;
  SummaryTabTile({Key? key, this.pageViewIndex = 0}) : super(key: key);

  List<String> _titleList = [];

  @override
  Widget build(BuildContext context) {
    _titleList = [
      context.loc.address,
      context.loc.orderSummary,
      context.loc.payment
    ];
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(0, 12.h, 0, 10.h),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.sw(size: 0.08)),
            child: Row(
              children: [
                circularContainer(0),
                Expanded(
                  child: Container(
                    color: pageViewIndex >= 1
                        ? ColorPalette.primaryColor
                        : HexColor('#C7C7C7'),
                    height: 1.h,
                  ).animatedSwitch(),
                ),
                circularContainer(1),
                Expanded(
                  child: Container(
                    color: pageViewIndex >= 2
                        ? ColorPalette.primaryColor
                        : HexColor('#C7C7C7'),
                    height: 1.h,
                  ).animatedSwitch(),
                ),
                circularContainer(2),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: context.isArabic
                    ? context.sw(size: 0.1)
                    : context.sw(size: 0.06)),
            child: Row(
              children: List.generate(
                  _titleList.length, (index) => _textWidget(context, index)),
            ),
          )
        ],
      ),
    );
  }

  Widget circularContainer(int index) {
    return Container(
      height: 21.w,
      width: 21.w,
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 5.5.w, vertical: 3.h),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: pageViewIndex > index
              ? Colors.white
              : pageViewIndex != index
                  ? Colors.white
                  : ColorPalette.primaryColor,
          border: Border.all(color: ColorPalette.primaryColor)),
      child: (pageViewIndex > index
              ? Icon(
                  Icons.check,
                  size: 18.r,
                  color: ColorPalette.primaryColor,
                )
              : FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '${index + 1}',
                    textAlign: TextAlign.center,
                    style: pageViewIndex == index
                        ? FontStyle.white13Regular
                        : FontStyle.grey_696969_13Regular,
                  ),
                ))
          .animatedSwitch(),
    );
  }

  Widget _textWidget(BuildContext context, int index) {
    return Expanded(
      child: Align(
        alignment: index == 0
            ? context.isArabic
                ? Alignment.centerRight
                : Alignment.centerLeft
            : index == 1
                ? Alignment.center
                : context.isArabic
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
        child: Text(
          _titleList[index],
          textAlign: context.isArabic ? TextAlign.start : TextAlign.end,
          style: pageViewIndex == index
              ? FontStyle.grey12Regular_6969
                  .copyWith(fontWeight: FontWeight.w500, height: 1.2.h)
              : FontStyle.grey12Regular_6969.copyWith(height: 1.2.h),
        ).avoidOverFlow(),
      ),
    );
  }
}
