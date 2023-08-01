import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/providers/app_localization_provider.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:gogo_pharma/widgets/common_app_bar.dart';
import 'package:gogo_pharma/widgets/custom_radio.dart';
import 'package:gogo_pharma/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HexColor("#F4F7F4"),
        appBar: CommonAppBar(
          buildContext: context,
          pageTitle: context.loc.language,
          actionList: const [],
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.white,
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 18.h,
                    ),
                    Text(
                      context.loc.chooseLanguage,
                      style: FontStyle.regular13_556879,
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    _customTile(
                        status: context.myLocale == 'en',
                        title: 'English',
                        onTap: () {
                          context
                              .read<AppLocalizationProvider>()
                              .changeLocale('en');
                        }),
                    ReusableWidgets.divider(height: 1.0),
                    _customTile(
                        status: context.myLocale == 'ar',
                        title: 'عربي',
                        onTap: () => context
                            .read<AppLocalizationProvider>()
                            .changeLocale('ar')),
                    SizedBox(
                      height: 3.h,
                    ),
                  ],
                ),
              )
            ],
          ),
        )));
  }

  Widget _customTile({bool status = true, String? title, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 17.h),
        child: Row(
          children: [
            CustomRadio(
              enable: status,
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: Text(
                title ?? '',
                style: FontStyle.black14Medium,
              ),
            )
          ],
        ),
      ),
    );
  }
}
