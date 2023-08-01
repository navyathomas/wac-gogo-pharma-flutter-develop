import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/common/route_generator.dart';
import 'package:gogo_pharma/generated/assets.dart';
import 'package:gogo_pharma/models/product_listing_model.dart';
import 'package:gogo_pharma/providers/payment_provider.dart';
import 'package:gogo_pharma/services/helpers.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:gogo_pharma/widgets/common_button.dart';
import 'package:gogo_pharma/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

class OrderSuccessScreen extends StatelessWidget {
   OrderSuccessScreen({Key? key,this.moneyPrice}) : super(key: key);

  Price ? moneyPrice;

  @override
  Widget build(BuildContext context) {
    print(moneyPrice?.value);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamedAndRemoveUntil(
            context, RouteGenerator.routeMain, (route) => false);
        return true;
      },
      child: Scaffold(
        backgroundColor: HexColor("#00CBC0"),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: (() => Navigator.pushNamedAndRemoveUntil(
                      context, RouteGenerator.routeMain, ((route) => false))),
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: 46.h, left: 19.w, right: 19.w),
                    child: ReusableWidgets.emptyBox(
                        height: 21.40.h,
                        width: 21.40.w,
                        childWidget: const Icon(
                          Icons.close,
                          color: Colors.white,
                        )),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 19.w, right: 19.w, top: 113.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(17.r),
              ),
              child: Column(
                children: [
                  ReusableWidgets.emptyBox(height: 61.h),
                  SvgPicture.asset(
                    Assets.iconsSuccessfullyOrderPlacedIcon,
                    height: 106.15.h,
                    width: 111.35.w,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 19.h),
                    child: Text(context.loc.thankYou,
                        style: FontStyle.black18SemiBold),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 37.w),
                    child: Column(
                      children: [
                        Text(context.loc.orderSuccessFullSummary,
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            style: FontStyle.grey_556879_13Medium),
                        Text(context.read<PaymentProvider>().user!,
                            textAlign: TextAlign.center,
                            style: FontStyle.grey_556879_13Strong),
                        ReusableWidgets.emptyBox(height: 17.65.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(context.loc.orderTotal,
                                style: FontStyle.black12Medium),
                            Text(
                                Helpers.alignPrice(
                                   moneyPrice?.currency,
                                    moneyPrice),
                                style: FontStyle.black12Medium),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(context.loc.paymentMethodColon,
                                style: FontStyle.black12Medium),
                            Text(context.read<PaymentProvider>().selectedMethod,
                                style: FontStyle.black12Medium),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ReusableWidgets.emptyBox(height: 29.73.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 45.w),
                    child: CommonButton(
                      height: 48.h,
                      onPressed: (() => Navigator.pushNamedAndRemoveUntil(
                          context,
                          RouteGenerator.routeMain,
                          ((route) => false))),
                      buttonText: context.loc.continueShopping,
                    ),
                  ),
                  ReusableWidgets.emptyBox(height: 33.h)
                ],
              ),
            ),
            ReusableWidgets.emptyBox(height: 90.h)
          ],
        ),
      ),
    );
  }
}
