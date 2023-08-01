import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/common/route_generator.dart';
import 'package:gogo_pharma/providers/cart_provider.dart';
import 'package:gogo_pharma/providers/payment_provider.dart';
import 'package:gogo_pharma/services/helpers.dart';
import 'package:gogo_pharma/widgets/common_button.dart';
import 'package:gogo_pharma/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../../../generated/assets.dart';
import '../../../utils/color_palette.dart';

class OrderFailedScreen extends StatelessWidget {
  const OrderFailedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#00CBC0"),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).popUntil((route) {
                    return route.settings.name != null
                        ? route.settings.name == RouteGenerator.routeMain
                        : true;
                  });
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 46.h, left: 19.w, right: 19.w),
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
                  Assets.iconsPaymentFailedIcon,
                  height: 95.07.h,
                  width: 106.w,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 19.5.h),
                  child: Text(context.loc.paymentFailed,
                      style: FontStyle.black18SemiBold),
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: 28.w, right: 29.w, bottom: 19.5.h),
                      child: Text(context.loc.paymentFailedSummary,
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          style: FontStyle.grey_556879_13Medium),
                    ),
                    Text(context.read<PaymentProvider>().user!,
                        textAlign: TextAlign.center,
                        style: FontStyle.grey_556879_13Strong),
                    ReusableWidgets.emptyBox(height: 17.65.h),
                    Divider(
                        color: HexColor(
                          "#E3E3E3",
                        ),
                        height: 1),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 18.h, bottom: 6.h, left: 26.w, right: 26.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          context.read<PaymentProvider>().orderID == ""
                              ? const SizedBox()
                              : Text(context.loc.orderID,
                                  style: FontStyle.shadeGrey12Regular),
                          Text(context.loc.totalOrder,
                              style: FontStyle.shadeGrey12Regular),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: 19.5.h, left: 26.w, right: 26.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              context
                                  .read<PaymentProvider>()
                                  .orderID
                                  .toString(),
                              style: FontStyle.black12Medium),
                          Text(
                              Helpers.alignPrice(
                                  context
                                      .read<CartProvider>()
                                      .cartModel
                                      ?.prices
                                      ?.grandTotal
                                      ?.currency,
                                  context
                                      .read<CartProvider>()
                                      .cartModel
                                      ?.prices
                                      ?.grandTotal),
                              style: FontStyle.black12Medium),
                        ],
                      ),
                    ),
                    Divider(
                        color: HexColor(
                          "#E3E3E3",
                        ),
                        height: 1),
                  ],
                ),
                ReusableWidgets.emptyBox(height: 19.73.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 45.w),
                  child: CommonButton(
                      height: 48.h,
                      onPressed: () {
                        Navigator.of(context).popUntil((route) {
                          return route.settings.name != null
                              ? route.settings.name == RouteGenerator.routeMain
                              : true;
                        });
                      },
                      buttonText: context.loc.tryAgain),
                ),
                ReusableWidgets.emptyBox(height: 20.h)
              ],
            ),
          ),
          ReusableWidgets.emptyBox(height: 90.h)
        ],
      ),
    );
  }
}
