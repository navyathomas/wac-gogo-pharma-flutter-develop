import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/generated/assets.dart';
import 'package:gogo_pharma/providers/location_provider.dart';
import 'package:gogo_pharma/services/app_config.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../common/route_generator.dart';
import '../../models/route_arguments.dart';

class HomeLocationTile extends StatelessWidget {
  const HomeLocationTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        AppData.navFromState = NavFromState.navFromHome;
        Navigator.pushNamed(context, RouteGenerator.routeSelectLocationScreen,
            arguments: RouteArguments(navFromState: NavFromState.navFromHome));
      },
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
          child: Row(
            children: [
              Text(
                context.loc.deliverTo,
                style: FontStyle.grey_6E6E6E_13Regular.copyWith(height: 1.1.h),
              ),
              Text(
                ' :',
                style: FontStyle.grey_6E6E6E_13Regular,
              ),
              SizedBox(
                width: 10.w,
              ),
              Consumer<LocationProvider>(builder: (context, model, _) {
                return Flexible(
                  child: Text(
                    _locationText(model.savedUserLocation),
                    style: FontStyle.grey_6E6E6E_13Medium,
                  ).avoidOverFlow(),
                );
              }),
              SizedBox(
                width: 5.w,
              ),
              Expanded(
                child: SvgPicture.asset(
                  Assets.iconsArrowDown,
                  alignment: context.myLocale == 'ar'
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  height: 5.h,
                  width: 5.w,
                ),
              )
            ],
          )),
    );
  }

  String _locationText(String val) {
    if (val.length > 20) {
      return '${val.substring(0, 20)}...';
    } else {
      return val;
    }
  }
}
