import 'package:flutter/cupertino.dart';
import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/route_generator.dart';
import 'package:gogo_pharma/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import '../models/route_arguments.dart';
import '../providers/app_data_provider.dart';
import '../providers/location_provider.dart';
import '../providers/product_detail_provider.dart';
import '../services/app_config.dart';
import '../services/shared_preference_helper.dart';

class NavRoutes {
  static Future<void> navByType(BuildContext context,
      {String type = '',
      String id = '',
      String title = '',
      bool navBackToHome = false}) async {
    switch (type.toLowerCase()) {
      case 'category':
        Navigator.pushNamed(context, RouteGenerator.routeProductListing,
            arguments: RouteArguments(id: id, title: title));
        break;
      case 'product':
        Navigator.popUntil(context, (route) {
          if (route.settings.name == RouteGenerator.routeProductDetails) {
            if (context.read<ProductDetailProvider>().productDetailData?.sku !=
                id) {
              Navigator.popAndPushNamed(
                  context, RouteGenerator.routeProductDetails,
                  arguments: RouteArguments(sku: id, title: title));
            }
            return true;
          } else {
            Navigator.pushNamed(context, RouteGenerator.routeProductDetails,
                arguments: RouteArguments(sku: id, title: title));
            return true;
          }
        });
        break;
      default:
        "No route found".log(name: 'navByType');
    }
  }

  static Future<void> navFromSplashScreen(BuildContext context) async {
    bool loginState = await SharedPreferencesHelper.fetchLoginState();
    AppData.navFrom = '';
    if (loginState) {
      bool val = await context.read<AppDataProvider>().fetchCartData(context);
      if (val) {
        _navFromSplash(context);
      }
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, RouteGenerator.routeLogin, (route) => false,arguments: RouteArguments(isFromSplash: true));
    }
  }

  static void _navFromSplash(BuildContext context) {
    context.read<LocationProvider>().getSavedUserLocation().then((value) {
      if (value.isEmpty) {
        Navigator.pushNamedAndRemoveUntil(
            context, RouteGenerator.routeSelectLocationScreen, (route) => false,
            arguments:
                RouteArguments(navFromState: NavFromState.navFromSplash));
      } else {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteGenerator.routeMain,
          (route) => false,
        );
      }
    });
  }

  static Future<void> navToCart(BuildContext context) async {
    context.read<CartProvider>().pageInit().then(
        (value) => Navigator.pushNamed(context, RouteGenerator.routeCart));
  }

  static Future<void> navAfterLogin(BuildContext context) async {
    bool val = await context.read<AppDataProvider>().fetchCartData(context);
    if (val) {
      context.read<LocationProvider>().getSavedUserLocation().then((value) {
        if (value.isEmpty) {
          Navigator.pushNamedAndRemoveUntil(context,
              RouteGenerator.routeSelectLocationScreen, (route) => false,
              arguments:
                  RouteArguments(navFromState: NavFromState.navFromSplash));
        } else {
          AppData.navFrom.isEmpty || AppData.navFrom == RouteGenerator.routeMain
              ? Navigator.pushNamedAndRemoveUntil(
                  context,
                  RouteGenerator.routeMain,
                  (route) => false,
                )
              : Navigator.of(context).popUntil((route) {
                  return route.settings.name != null
                      ? route.settings.name == AppData.navFrom
                      : true;
                });
        }
      });
    }
  }

  static Future<void> navToWishList(BuildContext context,
      {String navFrom = ''}) async {
    AppData.navFrom = navFrom;
    AppData.accessToken.isEmpty
        ? Navigator.pushNamed(context, RouteGenerator.routeLogin)
        : Navigator.pushNamed(context, RouteGenerator.routeWishList);
  }

  static Future<dynamic> navToLogin(BuildContext context,
      {String navFrom = RouteGenerator.routeMain}) async {
    AppData.navFrom = navFrom;
    return await Navigator.pushNamed(context, RouteGenerator.routeLogin);
  }
}
