import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gogo_pharma/models/cancel_order_product.dart';
import 'package:gogo_pharma/views/orders/cancel_order_screen.dart';
import 'package:gogo_pharma/views/orders/order_failed_screen.dart';
import 'package:gogo_pharma/views/account/account_page.dart';
import 'package:gogo_pharma/models/route_arguments.dart';
import 'package:gogo_pharma/views/address/add_address_screen.dart';
import 'package:gogo_pharma/views/all_reviews/all_reviews.dart';
import 'package:gogo_pharma/views/address/select_address_screen.dart';
import 'package:gogo_pharma/views/apply_coupon_screen.dart';
import 'package:gogo_pharma/views/auth_screens/login.dart';
import 'package:gogo_pharma/views/auth_screens/otp.dart';
import 'package:gogo_pharma/views/cart/cart_screen.dart';
import 'package:gogo_pharma/views/category/category_details/category_details.dart';
import 'package:gogo_pharma/views/checkout/checkout_screen.dart';
import 'package:gogo_pharma/views/invite_a_friend.dart';
import 'package:gogo_pharma/views/language_screen.dart';
import 'package:gogo_pharma/views/location/select_location_screen.dart';
import 'package:gogo_pharma/views/my_reviews_and_ratings/my_reviews_and_ratings.dart';
import 'package:gogo_pharma/views/my_reviews_and_ratings/review_product_screen.dart';
import 'package:gogo_pharma/views/orders/order_successful_screen.dart';
import 'package:gogo_pharma/views/orders/order_details_screen.dart';
import 'package:gogo_pharma/views/product_details/product_detail_screen.dart';
import 'package:gogo_pharma/views/product_listing/product_filter.dart';
import 'package:gogo_pharma/views/product_details/product_detail_web_view.dart';
import 'package:gogo_pharma/views/product_listing/product_listing.dart';
import 'package:gogo_pharma/views/product_listing/search_product_filter.dart';
import 'package:gogo_pharma/views/product_listing/search_product_listing.dart';
import 'package:gogo_pharma/views/auth_screens/signup_screen.dart';
import 'package:gogo_pharma/views/wishlist/wsihlist_ui_screen.dart';
import '../views/main_screen/main_screen.dart';
import '../views/orders/orders_screen.dart';
import '../views/personal_info/personal_info_screen.dart';
import '../views/splash_screen.dart';
import 'constants.dart';

class RouteGenerator {
  static const String routeMain = "/main";
  static const String routeInitial = "/";
  static const String routeLogin = "/login";
  static const String routeOTP = "/otp";
  static const String routeError = "/error";
  static const String routeSignUp = "/signup";
  static const String routeAccountScreen = "/accountPage";
  static const String routePersonalInfoScreen = "/personalInfoScreen";
  static const String routeCategoryDetails = "/categoryDetails";
  static const String routeProductListing = "/productListing";
  static const String routeSearchProductListing = "/searchProductListing";
  static const String routeSearchProductFilter = "/searchProductFilter";
  static const String routeProductDetails = "/productDetails";
  static const String routeProductFilter = "/productFilter";
  static const String routeSelectAddressScreen = "/selectAddress";
  static const String routeAddAddressScreen = "/addAddress";
  static const String routeSelectLocationScreen = "/selectLocation";
  static const String routeProductDetailsWebView = "/productDetailsWebView";
  static const String routeAllReviews = "/allReviews";
  static const String routeWishList = "/wishListScreen";
  static const String routeMyReviewsAndRatings = "/myReviewsAndRatings";
  static const String routeReviewProduct = "/ReviewProduct";
  static const String routeOrders = "/orders";
  static const String routeOrderDetails = "/ordersDetails";
  static const String routeCheckOut = "/checkOutScreen";
  static const String routeInviteAFriend = "/inviteAFriend";
  static const String routeCart = "/cartScreen";
  static const String routeApplyCoupon = "/applyCouponScreen";
  static const String routeOrderSuccessfullyPlaced = "/orderSuccessfullyPlaced";
  static const String routePaymentFailedScreenUI = "/PaymentFailedScreenUI";
  static const String routeLanguageScreen = "/LanguageScreen";
  static const String routeCancelOrderScreen = "/CancelOrderScreen";

  Route generateRoute(RouteSettings settings, {var routeBuilders}) {
    var args = settings.arguments;
    RouteArguments? _routeArguments;
    switch (settings.name) {
      case routeMain:
        if (args != null) _routeArguments = args as RouteArguments;
        return _buildRoute(
            routeMain,
            MainScreen(
              tabIndex: _routeArguments?.index ?? 0,
            ),
            enableFullScreen: _routeArguments?.enableFullScreen ?? false);
      case routeInitial:
        return _buildRoute(routeInitial, const SplashScreen());
      case routeOTP:
        var arg = settings.arguments;
        return _buildRoute(
            routeOTP,
            OTP(
              mobOREmail: arg.toString(),
            ));
      case routeLogin:
        if (args != null) _routeArguments = args as RouteArguments;
        return _buildRoute(routeLogin,
            Login(isFromSplash: _routeArguments?.isFromSplash ?? false));
      case routeProductFilter:
        return _buildRoute(routeProductFilter, const ProductFilter());
      case routeSearchProductFilter:
        return _buildRoute(
            routeSearchProductFilter, const SearchProductFilter());
      case routeSignUp:
        return _buildRoute(routeSignUp, const SignUpScreen());
      case routePersonalInfoScreen:
        return _buildRoute(routePersonalInfoScreen, const PersonalInfoScreen());
      case routeCart:
        return _buildRoute(routeCart, const CartScreen());
      case routeCheckOut:
        return _buildRoute(routeCheckOut, const CheckOutScreen());
      case routeInviteAFriend:
        return _buildRoute(routeInviteAFriend, const InviteAFriend());
      case routeAllReviews:
        return _buildRoute(
            routeAllReviews,
            AllReviews(
              sku: '$args',
            ));
      case routeProductDetails:
        if (args != null) _routeArguments = args as RouteArguments;
        return _buildRoute(
            routeProductDetails,
            ProductDetailScreen(
              routeArguments: _routeArguments,
            ));
      case routeProductListing:
        RouteArguments routeArguments = args as RouteArguments;
        return _buildRoute(
            routeProductListing,
            ProductListing(
              categoryID: routeArguments.id == null
                  ? routeArguments.categoriesIDs
                  : ['"${routeArguments.id}"'],
              sort: routeArguments.sort ?? {},
              filter: routeArguments.filter,
              urlPath: routeArguments.param,
              appbarTitle: routeArguments.title ?? '',
            ));
      case routeSearchProductListing:
        RouteArguments routeArguments = args as RouteArguments;
        return _buildRoute(
            routeSearchProductListing,
            SearchProductListing(
              searchkey: routeArguments.searchKey ?? '',
              categoryID: routeArguments.id == null
                  ? routeArguments.categoriesIDs
                  : ['"${routeArguments.id}"'],
              sort: routeArguments.sort ?? {},
              filter: routeArguments.filter,
              appbarTitle: routeArguments.title ?? '',
            ));

      case routeCategoryDetails:
        RouteArguments routeArguments = args as RouteArguments;
        return _buildRoute(
            routeCategoryDetails,
            CategoryDetails(
              id: routeArguments.id ?? '',
              title: routeArguments.title,
            ));
      case routeLanguageScreen:
        return _buildRoute(routeLanguageScreen, const LanguageScreen());
      case routeAccountScreen:
        return _buildRoute(routeAccountScreen, const AccountPage());
      case routeProductDetailsWebView:
        RouteArguments routeArguments = args as RouteArguments;
        return _buildRoute(
            routeProductDetailsWebView,
            ProductDetailWebView(
              identifier: routeArguments.title ?? '',
              hideActions: routeArguments.param ?? true,
            ));
      case routeApplyCoupon:
        return _buildRoute(routeApplyCoupon, const ApplyCouponScreen(),
            enableFullScreen: true);

      case routeSelectAddressScreen:
        return _buildRoute(
            routeSelectAddressScreen, const SelectAddressScreen());

      case routeAddAddressScreen:
        RouteArguments routeArguments = args as RouteArguments;
        return _buildRoute(
            routeAddAddressScreen,
            AddAddressScreen(
              isEditAddress: routeArguments.isEditAddress!,
              addresses: routeArguments.addresses,
              apartment: routeArguments.apartmentSelectedFromLocation ?? '',
              latitude: routeArguments.latitude,
              longitude: routeArguments.longitude,
              navFromState:
                  routeArguments.navFromState ?? NavFromState.navFromAccount,
            ));

      case routeSelectLocationScreen:
        RouteArguments? routeArguments =
            args == null ? null : args as RouteArguments;
        return _buildRoute(
            routeSelectLocationScreen,
            SelectLocation(
              navFromState:
                  routeArguments?.navFromState ?? NavFromState.navFromAccount,
            ));

      case routeWishList:
        return _buildRoute(routeWishList, const WishListUIScreen());
      case routeMyReviewsAndRatings:
        return _buildRoute(
            routeMyReviewsAndRatings, const MyReviewsAndRatings());
      case routeReviewProduct:
        RouteArguments routeArguments = args as RouteArguments;
        return _buildRoute(
            routeReviewProduct,
            ReviewProductScreen(
              reviewProductName: routeArguments.reviewProductName,
              reviewImageUrl: routeArguments.reviewImageUrl,
              reviewProductSku: routeArguments.sku,
              isFromOrders: routeArguments.isFromOrders,
            ),
            enableFullScreen: true);
      case routeOrders:
        return _buildRoute(routeOrders, const OrdersScreen());
      case routeOrderDetails:
        RouteArguments routeArguments = args as RouteArguments;
        return _buildRoute(
            routeOrderDetails,
            OrderDetailScreen(
              index: routeArguments.index,
              incrementId: routeArguments.incrementId ?? "",
            ));
      case routeOrderSuccessfullyPlaced:
        RouteArguments routeArguments = args as RouteArguments;
        return _buildRoute(routeOrderSuccessfullyPlaced,
            OrderSuccessScreen(moneyPrice: routeArguments.priceMoney),
            enableFullScreen: true);
      case routePaymentFailedScreenUI:
        return _buildRoute(
            routePaymentFailedScreenUI, const OrderFailedScreen(),
            enableFullScreen: true);
      case routeCancelOrderScreen:
        RouteArguments routeArguments = args as RouteArguments;
        return _buildRoute(
            routeCancelOrderScreen,
            CancelOrderScreen(
              itemIndex: routeArguments.itemIndex,
              items: routeArguments.orderDetailsItems,
           reasonStrings: routeArguments.reasonStrings, ));
      default:
        return _buildRoute(routeError, const ErrorView());
    }
  }

  Route _buildRoute(String route, Widget widget,
      {bool enableFullScreen = false}) {
    return CupertinoPageRoute(
        fullscreenDialog: enableFullScreen,
        settings: RouteSettings(name: route),
        builder: (_) => widget);
  }
}

class ErrorView extends StatelessWidget {
  const ErrorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Error View")),
        body: const Center(child: Text('Page not found')));
  }
}
