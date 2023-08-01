import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/common/nav_routes.dart';
import 'package:gogo_pharma/common/route_generator.dart';
import 'package:gogo_pharma/generated/assets.dart';

import '../../services/app_config.dart';

class AddMoreFromWishListTile extends StatelessWidget {
  const AddMoreFromWishListTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: InkWell(
        onTap: () =>
            NavRoutes.navToWishList(context, navFrom: RouteGenerator.routeCart),
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
          child: Row(
            children: [
              SizedBox(
                width: 4.w,
              ),
              Expanded(
                child: Row(
                  children: [
                    SvgPicture.asset(
                      Assets.iconsWishlistBlack,
                      height: 13.h,
                      width: 15.w,
                    ),
                    SizedBox(
                      width: 7.w,
                    ),
                    Text(
                      context.loc.addMoreFromWishlist,
                      style: FontStyle.black14MediumStrong,
                    ).avoidOverFlow()
                  ],
                ),
              ),
              RotatedBox(
                quarterTurns: context.isArabic ? 10 : 0,
                child: SvgPicture.asset(
                  Assets.iconsArrowRightGreen,
                  color: Colors.black,
                  height: 9.h,
                  width: 5.w,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
