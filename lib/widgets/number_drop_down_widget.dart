import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gogo_pharma/common/font_style.dart';

import '../generated/assets.dart';
import '../utils/countrycodes.dart';

class NumberDropDownWidget extends StatelessWidget {
  final ValueNotifier<String> countryCode;
  const NumberDropDownWidget({Key? key, required this.countryCode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, bottom: 1.h),
      child: PopupMenuButton<String>(
        itemBuilder: (context) {
          return CountryCodes.items.map((str) {
            return PopupMenuItem(
              value: str,
              child: ValueListenableBuilder<String>(
                  builder: (context, value, child) =>
                      Text(str, style: FontStyle.grey14Medium),
                  valueListenable: countryCode),
            );
          }).toList();
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ValueListenableBuilder(
                builder: (context, value, child) {
                  return Text(value.toString(),
                      style: FontStyle.black14MediumW400);
                },
                valueListenable: countryCode),
            SizedBox(
              width: 8.w,
            ),
            SvgPicture.asset(
              Assets.iconsCountryCodeDropDown,
              height: 8.h,
              width: 9.w,
            ),
            SizedBox(
              width: 8.w,
            ),
          ],
        ),
        onSelected: (v) {
          countryCode.value = v;
        },
      ),
    );
  }
}
