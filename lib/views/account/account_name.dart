import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/providers/personal_info_provider.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:provider/provider.dart';

class AccountName extends StatelessWidget {
  const AccountName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 20.w, right: 20.w),
        child: Consumer<PersonalInfoProvider>(builder: (context, value, _) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                  text: TextSpan(
                      style: value.nameColor
                          ? FontStyle.white19Bold
                          : FontStyle.white19Bold.copyWith(color: ColorPalette.primaryColor),
                      text: context.loc.hi,
                      children: [
                    const TextSpan(text: ','),
                    WidgetSpan(
                        child: SizedBox(
                      width: 5.w,
                    )),
                    TextSpan(
                        text: value.personalInfoData?.customer?.firstname ?? "")
                  ])),
              SizedBox(height: 3.h),
              Text(context.loc.thanksGoGoCustomer,
                  style: value.nameColor
                      ? FontStyle.white13Regular.copyWith(height: 1.2.h)
                      : FontStyle.white13Regular
                          .copyWith(height: 1.2.h, color: ColorPalette.primaryColor)),
            ],
          );
        }),
        width: double.infinity);
  }
}
