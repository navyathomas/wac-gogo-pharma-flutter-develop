import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';

import '../generated/assets.dart';

class LocationTile extends StatelessWidget {
  final VoidCallback? onTap;
  final String? title;
  const LocationTile({Key? key, this.title, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
          child: Row(
            children: [
              Text(
                context.loc.deliverTo,
                style: FontStyle.black14Regular,
              ),
              Text(
                ':',
                style: FontStyle.grey_6E6E6E_13Regular,
              ),
              SizedBox(
                width: 10.w,
              ),
              Flexible(
                child: Text(
                  _locationText(title ?? ''),
                  style: FontStyle.black14Medium,
                ).avoidOverFlow(),
              ),
              SizedBox(
                width: 5.w,
              ),
              SvgPicture.asset(
                Assets.iconsArrowDown,
                height: 5.h,
                width: 5.w,
              )
            ],
          )),
    );
  }

  String _locationText(String val) {
    if (val.length > 25) {
      return '${val.substring(0, 25)}...';
    } else {
      return val;
    }
  }
}
