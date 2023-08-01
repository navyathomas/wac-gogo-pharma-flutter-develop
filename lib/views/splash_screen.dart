import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/generated/assets.dart';
import 'package:gogo_pharma/models/force_update_issue.dart';
import 'package:gogo_pharma/providers/app_data_provider.dart';
import 'package:gogo_pharma/providers/app_localization_provider.dart';
import 'package:gogo_pharma/providers/auth_provider.dart';
import 'package:gogo_pharma/services/app_config.dart';
import 'package:gogo_pharma/services/firebase_messaging_services.dart';
import 'package:gogo_pharma/services/remote_config_services.dart';
import 'package:gogo_pharma/views/product_listing/search_product_listing.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import '../common/constants.dart';
import '../common/nav_routes.dart';
import '../services/firebase_dynamic_link_sevices.dart';
import '../services/flavour_config.dart';
import '../services/gql_client.dart';
import '../services/helpers.dart';
import '../utils/color_palette.dart';
import '../widgets/reusable_widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final ValueNotifier<bool> enableError = ValueNotifier(false);

  @override
  void initState() {
    Future.microtask(() => initialFetch());
    super.initState();
  }

  Future<void> initialFetch() async {
    final network = await Helpers.isInternetAvailable(enableToast: false);
    if (network) {
      fetchData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          children: [
            Expanded(
              child: Text(Constants.noNetworkDesc,
                  style: FontStyle.white13Regular),
            ),
            SizedBox(
              width: 10.w,
            ),
            IconButton(
                onPressed: () async {
                  final network =
                      await Helpers.isInternetAvailable(enableToast: false);
                  if (network) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    fetchData();
                  }
                },
                icon: const Icon(
                  Icons.refresh_rounded,
                  color: Colors.white,
                ))
          ],
        ),
        duration: const Duration(days: 1),
        backgroundColor: HexColor('#FF5353'),
      ));
    }
  }

  Future<void> fetchData() async {
    final flavour = FlavourConstants.findFlavour;
    final _authProvider = context.read<AuthProvider>();
    await context.read<AppLocalizationProvider>().getLocalLocale();
    enableError.value = false;
    FirebaseMessagingServices.fetchFirebaseToken(context);
    RemoteConfigServices.instance.fetchRemoteConfigValue(context);
    FirebaseDynamicLinkServices.instance.fetchInviteLink(context);
    GraphQLClientConfiguration.instance
        .config(initial: true)
        .then((bool value) async {
      if (value) {
        AppData.baseUrl = flavour.getBaseUrl();
        ForceUpdateModel? forceUpdateModel =
            await context.read<AppDataProvider>().checkForceUpdate();
        if (forceUpdateModel == null) {
          String _cartId = await _authProvider.fetchCartId(context);
          if (_cartId.isNotEmpty) {
            NavRoutes.navFromSplashScreen(context);
          }
        } else {
          PackageInfo packageInfo = await PackageInfo.fromPlatform();
          int buildNumber = int.parse(packageInfo.buildNumber);
          int latestBuildNumber = Platform.isAndroid
              ? forceUpdateModel.forceUpdate!.androidVersion!
              : forceUpdateModel.forceUpdate!.iosVersion!;
          if (buildNumber < latestBuildNumber) {
            ReusableWidgets.showUpdateAppSheet(
                context, forceUpdateModel.forceUpdate?.enabled ?? false);
          } else {
            String _cartId = await _authProvider.fetchCartId(context);
            if (_cartId.isNotEmpty) {
              NavRoutes.navFromSplashScreen(context);
            }
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final flavour = FlavourConstants.findFlavour;
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: ColorPalette.primaryColor,
          body: SafeArea(
              top: false,
              child: SizedBox(
                child: Stack(
                  children: [
                    Center(
                        child: SvgPicture.asset(
                      Assets.iconsLogo,
                      alignment: Alignment.center,
                    )),
                    Positioned(
                      top: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: AppBar(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.transparent,
                        elevation: 0,
                        systemOverlayStyle: const SystemUiOverlayStyle(
                          statusBarColor: Colors.transparent,
                          statusBarBrightness: Brightness.dark,
                          statusBarIconBrightness: Brightness.light,
                          systemNavigationBarIconBrightness: Brightness.light,
                        ),
                      ),
                    ),
                    _noNetworkTile()
                  ],
                ),
              )),
        );
      },
    );
  }

  Widget _noNetworkTile() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ValueListenableBuilder<bool>(
          valueListenable: enableError,
          builder: (context, value, _) {
            return (value
                    ? Container(
                        decoration: BoxDecoration(
                            color: HexColor('#FF5353'),
                            borderRadius: BorderRadius.circular(4.r)),
                        margin: EdgeInsets.all(8.r),
                        padding: EdgeInsets.fromLTRB(12.w, 8.h, 0, 8.h),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(context.loc.noNetworkDesc,
                                  style: FontStyle.white13Regular),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            IconButton(
                                onPressed: () {
                                  initialFetch();
                                },
                                icon: const Icon(
                                  Icons.refresh_rounded,
                                  color: Colors.white,
                                ))
                          ],
                        ),
                      )
                    : const SizedBox())
                .animatedSwitch();
          }),
    );
  }
}
