import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/common/route_generator.dart';
import 'package:gogo_pharma/generated/assets.dart';
import 'package:gogo_pharma/providers/cart_provider.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:gogo_pharma/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../../models/cart_model.dart';
import '../../services/helpers.dart';

class CartBottomDetailTile extends StatelessWidget {
  final CartModel? cartModel;
  final bool fromCartPage;
  const CartBottomDetailTile(
      {Key? key, this.cartModel, this.fromCartPage = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(23.w, 0.h, 23.w, 15.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (fromCartPage) ...[
                SizedBox(
                  height: 21.h,
                ),
                Text(
                  context.loc.coupons,
                  style: FontStyle.black16SemiBold_2B,
                ),
                _applyCoupon(context, cartModel),
                ReusableWidgets.divider(height: 1.h, color: HexColor('#D9E3E3'))
              ],
              ..._priceDetailView(context, cartModel)
            ],
          ),
        ),
        _staticMessage(context)
      ],
    );
  }

  Widget _staticMessage(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              Assets.iconsBadge,
              height: 27.h,
              width: 23.w,
            ),
            SizedBox(
              width: 16.w,
            ),
            Text(context.loc.cartReturnMsg, style: FontStyle.grey12Regular_504F4F.copyWith(height: 1.2.h))
          ],
        ));
  }

  Widget _applyCoupon(BuildContext context, CartModel? model) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18.h),
      child: Row(
        children: [
          Expanded(
              child: Row(
            children: [
              SvgPicture.asset(
                Assets.iconsPriceTag,
                height: 18.w,
                width: 18.w,
              ),
              Expanded(
                child: Align(
                  alignment: context.isArabic
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: (model?.appliedCoupons != null
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context.loc.oneCouponApplied,
                                    style: FontStyle.black14MediumStrong,
                                  ).avoidOverFlow(),
                                  if (checkCouponAmount(
                                          cartModel?.customPricesApp ?? []) !=
                                      null) ...[
                                    SizedBox(
                                      height: 4.h,
                                    ),
                                    Text(
                                      '${context.loc.youSavedAdditional} ${checkCouponAmount(cartModel?.customPricesApp ?? [])}',
                                      style: FontStyle.green12Regular,
                                    ).avoidOverFlow()
                                  ]
                                ],
                              )
                            : Text(
                                context.loc.applyCoupons,
                                style: FontStyle.black14MediumStrong,
                              ).avoidOverFlow())
                        .animatedSwitch(),
                  ),
                ),
              ),
            ],
          )),
          TextButton(
            onPressed: () {
              if (model?.appliedCoupons == null) {
                Navigator.pushNamed(context, RouteGenerator.routeApplyCoupon);
              } else {
                context.read<CartProvider>().removeCouponFromCart(context);
              }
            },
            style: ElevatedButton.styleFrom(
              fixedSize:
                  Size(model?.appliedCoupons != null ? 87.w : 99.w, 41.h),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.r))),
              side: BorderSide(
                color: HexColor('#36BFB8'),
              ),
            ),
            child: Text(
              model?.appliedCoupons != null
                  ? context.loc.remove
                  : context.loc.apply,
              style: FontStyle.green14Medium_36BFB8,
            ).animatedSwitch(),
          ),
        ],
      ),
    );
  }

  List<Widget> _priceDetailView(BuildContext context, CartModel? cartModel) {
    return [
      Padding(
          padding: EdgeInsets.only(top: 18.h, bottom: 16.h),
          child: Text(
            context.loc.priceDetails,
            style: FontStyle.black15Medium_2B,
          )),
      ListView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cartModel?.customPricesApp?.length ?? 0,
          shrinkWrap: true,
          itemBuilder: (cxt, index) {
            return _priceTileSwitcher(
                context, cartModel?.customPricesApp?[index]);
          }),
      ReusableWidgets.divider(
          height: 1.h,
          color: HexColor('#D9E3E3'),
          margin: EdgeInsets.only(top: 8.h, bottom: 16.h)),
      _priceTile(
        leadTitle: context.loc.total,
        trailTitle: Helpers.alignPrice(cartModel?.prices?.grandTotal?.currency, cartModel?.prices?.grandTotal),
        leadStyle: FontStyle.black15SemiBold,
        trailStyle: FontStyle.black15SemiBold,
      ),
    ];
  }

  Widget _priceTileSwitcher(
      BuildContext context, CustomPricesApp? customPricesApp) {
    switch (customPricesApp?.className ?? '') {
      case 'zero_discount':
        return _priceTile(
            leadTitle: customPricesApp?.label ?? '',
            trailTitle: context.loc.applyCoupon,
            trailStyle: FontStyle.orange14Regular,
            onTap: () {
              Navigator.pushNamed(context, RouteGenerator.routeApplyCoupon);
            });
      case 'discount':
        return _priceTile(
            leadTitle: customPricesApp?.label ?? '',
            trailTitle: Helpers.alignCustomPrice(
                customPricesApp?.currency, customPricesApp?.value),
            trailStyle: FontStyle.green14Regular);
      case 'free_shipping':
        return _priceTile(
            leadTitle: customPricesApp?.label ?? '',
            trailTitle: (customPricesApp?.value ?? '0.0') == 0.0
                ? context.loc.free
                : Helpers.alignCustomPrice(
                    customPricesApp?.currency, customPricesApp?.value),
            trailStyle: (customPricesApp?.value ?? '0.0') == 0.0
                ? FontStyle.green14Regular
                : null);
      default:
        return _priceTile(
            leadTitle: customPricesApp?.label ?? '',
            trailTitle: Helpers.alignCustomPrice(
                customPricesApp?.currency, customPricesApp?.value));
    }
  }

  Widget _priceTile(
      {String? trailTitle,
      String? leadTitle,
      TextStyle? trailStyle,
      TextStyle? leadStyle,
      VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            Expanded(
                child: Text(
              leadTitle ?? '',
              style: leadStyle ?? FontStyle.lightGreyBlack14Regular,
            ).avoidOverFlow()),
            SizedBox(
              width: 10.w,
            ),
            Text(
              trailTitle ?? '',
              textAlign: TextAlign.end,
              style: trailStyle ?? FontStyle.black14Regular,
            )
          ],
        ),
      ),
    );
  }

  String? checkCouponAmount(List<CustomPricesApp> customPricesApp) {
    String? val;
    CustomPricesApp? res = customPricesApp
        .firstWhere((element) => (element.className ?? '') == 'discount');
    if (res.value != null)
      val = Helpers.alignCustomPrice(res.currency, res.value);
    return val;
  }
}
