import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';

import '../../common/constants.dart';
import '../../common/route_generator.dart';
import '../../utils/color_palette.dart';

class AddAddressButton extends StatelessWidget {
  final VoidCallback? onTap;
  const AddAddressButton({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 14.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              size: 28.r,
              color: HexColor('#36BFB8'),
            ),
            SizedBox(width: 9.w),
            Expanded(
                child: Text(context.loc.addNewAddress,
                        style: FontStyle.semiBold14Green)
                    .avoidOverFlow())
          ],
        ),
      ),
    );
  }
}
