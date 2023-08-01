import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:gogo_pharma/widgets/common_button.dart';
import 'package:gogo_pharma/widgets/reusable_functions.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../common/const.dart';

class UpdateAppContainer extends StatelessWidget {
  final bool enableForceUpdate;
  const UpdateAppContainer({Key? key, this.enableForceUpdate = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(15.w, 10.h, 15.w, 44.h),
            padding: EdgeInsets.fromLTRB(26.w, 37.h, 26.w, 15.h),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(16.r)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.loc.newVersionAvailable,
                      style: FontStyle.black18SemiBold
                          .copyWith(color: HexColor('#282C3F')),
                    ),
                    16.verticalSpace,
                    Text(
                      enableForceUpdate
                          ? context.loc.pleaseUpdateAppToNewVersionToContinue
                          : context.loc.pleaseUpdateAppToNewVersion,
                      style: FontStyle.black14Regular,
                    ),
                  ],
                ),
                13.verticalSpace,
                CommonButton(
                  buttonText: context.loc.updateNow,
                  onPressed: () async {
                    PackageInfo packageInfo = await PackageInfo.fromPlatform();
                    String url = Platform.isAndroid
                        ? "market://details?id=${packageInfo.packageName}"
                        : 'https://apps.apple.com/app/gogopharma/id${Const.appId}';
                    ReusableFunctions.launchApp(url);
                  },
                ),
                if (!enableForceUpdate) ...[12.verticalSpace, _CancelButton()]
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    }
    return false;
  }
}

class _CancelButton extends StatelessWidget {
  const _CancelButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      width: double.maxFinite,
      child: TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'No, Thanks',
            style: FontStyle.black15Medium
                .copyWith(color: ColorPalette.primaryColor),
          )),
    );
  }
}
