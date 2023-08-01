import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/common/nav_routes.dart';
import 'package:provider/provider.dart';

import '../../common/route_generator.dart';
import '../../generated/assets.dart';
import '../../providers/cart_provider.dart';
import '../../utils/color_palette.dart';

class CategoryAppBar extends AppBar {
  final BuildContext? buildContext;
  final String? titleTxt;
  CategoryAppBar({Key? key, this.buildContext, this.titleTxt})
      : super(
          key: key,
          iconTheme: const IconThemeData(
            color: Colors.white, //change your color here
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Text(
            titleTxt ?? Constants.categories,
            style: FontStyle.black15Medium,
          ),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: SvgPicture.asset(
                Assets.iconsWishlist,
                color: Colors.black,
              ),
              onPressed: () {
                if (buildContext != null) {
                  NavRoutes.navToWishList(buildContext,
                      navFrom: RouteGenerator.routeMain);
                }
              },
            ),
            IconButton(
              icon: Consumer<CartProvider>(builder: (_, value, __) {
                return Badge(
                  toAnimate: true,
                  shape: BadgeShape.circle,
                  badgeColor: HexColor('#FD7600'),
                  padding: EdgeInsets.all(5.r),
                  borderRadius: BorderRadius.circular(8.r),
                  badgeContent: Text('${value.cartCount}',
                      style: FontStyle.white10Regular),
                  child:
                      SvgPicture.asset(Assets.iconsCart, color: Colors.black),
                );
              }),
              onPressed: () {
                if (buildContext != null) {
                  NavRoutes.navToCart(buildContext);
                }
              },
            ),
          ],
        );
}
