import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/common/route_generator.dart';
import 'package:gogo_pharma/models/route_arguments.dart';
import 'package:gogo_pharma/providers/app_data_provider.dart';
import 'package:gogo_pharma/providers/cart_provider.dart';
import 'package:provider/provider.dart';

import '../../common/nav_routes.dart';
import '../../generated/assets.dart';
import '../../utils/color_palette.dart';

class MainAppBar extends AppBar {
  final BuildContext? buildContext;
  final bool isAccount;
  MainAppBar({
    Key? key,
    this.isAccount = false,
    this.buildContext,
  }) : super(
          key: key,
          iconTheme: const IconThemeData(
            color: Colors.white, //change your color here
          ),
          backgroundColor: ColorPalette.primaryColor,
          elevation: 0.0,
          title: isAccount
              ? Padding(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w),
                  child: Text(
                    buildContext.isNull
                        ? Constants.myAccount
                        : buildContext!.loc.myAccount,
                    style: FontStyle.white15Medium,
                  ),
                )
              : SvgPicture.asset(
                  Assets.iconsLogo,
                  height: 25.h,
                  width: 67.w,
                ),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: SvgPicture.asset(isAccount
                    ? Assets.iconsSearchWhite
                    : Assets.iconsNotification),
              ),
              onPressed: () {
                if (buildContext != null) {
                  if (isAccount) {
                    Navigator.pushNamedAndRemoveUntil(buildContext,
                        RouteGenerator.routeMain, (route) => false,
                        arguments:
                            RouteArguments(index: 2, enableFullScreen: true));
                  }
                }
              },
            ),
            IconButton(
              icon: SvgPicture.asset(Assets.iconsWishlist),
              onPressed: () {
                if (buildContext != null) {
                  NavRoutes.navToWishList(buildContext,
                      navFrom: RouteGenerator.routeMain);
                }
              },
            ),
            IconButton(onPressed: () {
              if (buildContext != null) {
                NavRoutes.navToCart(buildContext);
              }
            }, icon: Consumer<CartProvider>(builder: (_, value, __) {
              return Badge(
                toAnimate: true,
                shape: BadgeShape.circle,
                badgeColor: HexColor('#FD7600'),
                padding: EdgeInsets.all(5.r),
                borderRadius: BorderRadius.circular(8.r),
                badgeContent:
                    Text('${value.cartCount}', style: FontStyle.white10Regular),
                child: SvgPicture.asset(Assets.iconsCart),
              );
            }))
          ],
        );
}
