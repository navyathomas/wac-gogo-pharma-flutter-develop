import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/common/route_generator.dart';
import 'package:gogo_pharma/models/route_arguments.dart';
import 'package:gogo_pharma/providers/search_provider.dart';
import 'package:gogo_pharma/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../common/nav_routes.dart';
import '../generated/assets.dart';
import '../providers/cart_provider.dart';
import '../utils/color_palette.dart';

class CommonAppBar extends AppBar {
  final String? pageTitle;
  final bool? enableNavBAck;
  final double? elevationVal;
  final Widget? titleWidget;
  final BuildContext? buildContext;
  final List<Widget>? actionList;
  final bool disableWish;

  CommonAppBar({
    Key? key,
    this.pageTitle,
    this.enableNavBAck,
    this.elevationVal,
    this.buildContext,
    this.titleWidget,
    this.actionList,
    this.disableWish = false,
  }) : super(
          key: key,
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
          elevation: elevationVal ?? 0.5,
          shadowColor: HexColor('#D9E3E3'),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          titleSpacing: 0,
          title: titleWidget ??
              Text(
                pageTitle ?? '',
                textAlign: TextAlign.left,
                style: FontStyle.black15Medium,
              ),
          automaticallyImplyLeading: enableNavBAck ?? true,
          actions: actionList ??
              <Widget>[
                IconButton(
                    icon: SvgPicture.asset(
                      Assets.iconsSearchWhite,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      if (buildContext != null) {
                        Navigator.of(buildContext).pushNamedAndRemoveUntil(
                            RouteGenerator.routeMain, (route) => false,
                            arguments: RouteArguments(
                              index: 2,
                              enableFullScreen: true
                            ));
                      }
                    }),
                Visibility(
                    visible: !disableWish,
                    child: IconButton(
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
                    )),
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
                    badgeContent: Text('${value.cartCount}',
                        style: FontStyle.white10Regular),
                    child: SvgPicture.asset(
                      Assets.iconsCart,
                      color: Colors.black,
                    ),
                  );
                }))
              ],
        );
}
