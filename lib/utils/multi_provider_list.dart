import 'package:flutter/material.dart';
import 'package:gogo_pharma/providers/address_provider.dart';
import 'package:gogo_pharma/providers/app_data_provider.dart';
import 'package:gogo_pharma/providers/app_localization_provider.dart';
import 'package:gogo_pharma/providers/cart_provider.dart';
import 'package:gogo_pharma/providers/category_provider.dart';
import 'package:gogo_pharma/providers/connectivity_provider.dart';
import 'package:gogo_pharma/providers/home_provider.dart';
import 'package:gogo_pharma/providers/location_provider.dart';
import 'package:gogo_pharma/providers/orders_provider.dart';
import 'package:gogo_pharma/providers/order_summary_provider.dart';
import 'package:gogo_pharma/providers/payment_provider.dart';
import 'package:gogo_pharma/providers/personal_info_provider.dart';
import 'package:gogo_pharma/providers/product_detail_provider.dart';
import 'package:gogo_pharma/providers/product_provider.dart';
import 'package:gogo_pharma/providers/review_provider.dart';
import 'package:gogo_pharma/providers/reviews_and_ratings_provider.dart';
import 'package:gogo_pharma/providers/search_product_provider.dart';
import 'package:gogo_pharma/providers/wishlist_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../providers/account_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/search_provider.dart';

class MultiProviderList {
  static List<SingleChildWidget> providerList = [
    ChangeNotifierProvider(create: (_) => AppLocalizationProvider()),
    ChangeNotifierProvider(create: (_) => AppDataProvider()),
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => HomeProvider()),
    ChangeNotifierProvider(create: (_) => PersonalInfoProvider()),
    ChangeNotifierProvider(create: (_) => ProductProvider()),
    ChangeNotifierProvider(create: (_) => SearchProductProvider()),
    ChangeNotifierProvider(create: (context) {
      ConnectivityProvider changeNotifier = ConnectivityProvider();
      changeNotifier.initialLoad();
      return changeNotifier;
    }),
    ChangeNotifierProvider(create: (_) => CategoryProvider()),
    ChangeNotifierProvider(create: (_) => SearchProvider()),
    ChangeNotifierProvider(create: (_) => AddressProvider()),
    ChangeNotifierProvider(create: (_) => ProductDetailProvider()),
    ChangeNotifierProvider(create: (_) => ReviewProvider()),
    ChangeNotifierProvider(create: (_) => CartProvider()),
    ChangeNotifierProvider(create: (_) => WishListProvider()),
    ChangeNotifierProvider(create: (_) => LocationProvider()),
    ChangeNotifierProvider(create: (_) => ReviewsAndRatingsProvider()),
    ChangeNotifierProvider(create: (_) => OrderSummaryProvider()),
    ChangeNotifierProvider(create: (_) => OrdersProvider()),
    ChangeNotifierProvider(create: (_) => PaymentProvider()),
    ChangeNotifierProvider(create: (_) => AccountProvider()),
  ];
}
