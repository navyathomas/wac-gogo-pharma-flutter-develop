import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:gogo_pharma/services/app_config.dart';
import 'package:gogo_pharma/services/helpers.dart';
import 'package:gogo_pharma/services/shared_preference_helper.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../providers/app_data_provider.dart';
import '../widgets/reusable_widgets.dart';

class FirebaseDynamicLinkServices {
  static FirebaseDynamicLinkServices? _instance;
  static FirebaseDynamicLinkServices get instance {
    _instance ??= FirebaseDynamicLinkServices();
    return _instance!;
  }

  Future<String> createDynamicLink(
      {String? sku,
      String? name,
      BuildContext? context,
      String? image,
      String? url}) async {
    ReusableWidgets.circularLoader();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    print(packageInfo.packageName + 'Package Name');

    final DynamicLinkParameters dynamicLinkParams = DynamicLinkParameters(
      socialMetaTagParameters: SocialMetaTagParameters(
          description: 'Check this out $name on Gogo Pharma',
          imageUrl: Uri.parse(image!)),
      uriPrefix: 'https://gogopharma.page.link',
      link: Uri.parse(url ?? '${AppData.baseUrl}$sku.html'),
      androidParameters: AndroidParameters(
        packageName: packageInfo.packageName,
        minimumVersion: 1,
      ),
      iosParameters: IOSParameters(
        bundleId: packageInfo.packageName,
        minimumVersion: packageInfo.version,
        appStoreId: '',
      ),
    );
    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);

    return '${dynamicLink.shortUrl}';
  }

  Future<void> initDynamicLinks(BuildContext context) async {
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      final Uri deepLink = dynamicLinkData.link;
      final AppDataProvider provider = context.read<AppDataProvider>();
      if (!deepLink.query.contains("referral_code")) {
        context
            .read<AppDataProvider>()
            .navByDeepLink(context: context, url: deepLink.path);
      }
    }, onDone: () {}).onError((error) {
      // Handle errors
    });

    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      if (!deepLink.query.contains("referral_code")) {
        context
            .read<AppDataProvider>()
            .navByDeepLink(context: context, url: deepLink.path);
      }
    }
  }

  Future<void> fetchInviteLink(BuildContext context) async {
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      final Uri deepLink = dynamicLinkData.link;
      if (deepLink.query.contains("referral_code")) {
        navToRegister(deepLink.query);
      }
    }, onDone: () {}).onError((error) {
      // Handle errors
    });

    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      if (deepLink.query.contains("referral_code")) {
        navToRegister(deepLink.query);
      }
    }
  }

  Future<String> createInviteLink({String? image, String? url}) async {
    ReusableWidgets.circularLoader();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    print(packageInfo.packageName + 'Package Name');

    final DynamicLinkParameters dynamicLinkParams = DynamicLinkParameters(
      socialMetaTagParameters: SocialMetaTagParameters(
          description:
              "Hey I'm inviting you to Gogo Pharma, Join now by downloading and registering in the app by clicking the following link.",
          imageUrl: Uri.parse(image ?? '')),
      uriPrefix: 'https://gogopharma.page.link',
      link: Uri.parse(url ?? '${AppData.baseUrl}.html'),
      androidParameters: AndroidParameters(
        packageName: packageInfo.packageName,
        minimumVersion: 1,
      ),
      iosParameters: IOSParameters(
        bundleId: packageInfo.packageName,
        minimumVersion: packageInfo.version,
        appStoreId: '',
      ),
    );
    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);

    return '${dynamicLink.shortUrl}';
  }

  void navToRegister(String referral) {
    String code = referral.contains('=') ? referral.split('=').last : '';
    SharedPreferencesHelper.saveReferral(code);
  }
}
