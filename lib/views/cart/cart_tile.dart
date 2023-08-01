import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/common/route_generator.dart';
import 'package:gogo_pharma/common/update_data.dart';
import 'package:gogo_pharma/models/local_products.dart';
import 'package:gogo_pharma/providers/app_data_provider.dart';
import 'package:gogo_pharma/services/app_config.dart';
import 'package:gogo_pharma/widgets/common_image_view.dart';
import 'package:provider/provider.dart';

import '../../common/nav_routes.dart';
import '../../generated/assets.dart';
import '../../models/cart_model.dart';
import '../../models/product_listing_model.dart';
import '../../services/helpers.dart';
import '../../utils/color_palette.dart';
import '../../widgets/reusable_widgets.dart';

class CartTile extends StatelessWidget {
  final CartItems? cartItems;

  const CartTile({Key? key, this.cartItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Price? finalPrice =
        cartItems?.prices?.customRowTotalPriceApp?.maximumPrice?.finalPrice;
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 9.h),
                    child: Text(
                      (cartItems?.product?.name ?? '') +
                          (cartItems?.configurableOptions ?? [])
                              .map((e) => "\t${e.valueLabel ?? ''}")
                              .join(','),
                      style: FontStyle.liteBlack13Regular.copyWith(height: 1.5),
                    ).avoidOverFlow(maxLine: 2),
                  ),
                  Text(
                    Helpers.alignPrice(finalPrice?.currency, finalPrice),
                    style: FontStyle.black14SemiBold,
                  ),
                  SizedBox(
                    height: 9.h,
                  ),
                  if (cartItems?.product?.getDeliveryMode?.deliveryText != null)
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          (cartItems?.product?.getDeliveryMode?.deliveryText)!,
                          style: FontStyle.grey12Medium_556879,
                        ),
                        if (cartItems
                                ?.product?.getDeliveryMode?.isFreeDelivery ??
                            false) ...[
                          Container(
                            height: 9.0,
                            width: 1.0,
                            color: HexColor('#C7C7C7'),
                            margin: EdgeInsets.symmetric(horizontal: 7.w),
                          ),
                          Text(
                            context.loc.free,
                            style: FontStyle.green12Medium_2AD16A,
                          )
                        ]
                      ],
                    ),
                  SizedBox(
                    height: 5.h,
                  ),
                ],
              )),
              SizedBox(
                width: 28.w,
              ),
              ClipRRect(
                  borderRadius: BorderRadius.circular(11.r),
                  child: CommonImageView(
                    image: cartItems?.quoteThumbnailUrl ?? '',
                    height: 90.w,
                    width: 90.w,
                  ))
            ],
          ),
          SizedBox(
            height: 17.h,
          ),
          LayoutBuilder(builder: (context, constraints) {
            double _width = constraints.maxWidth;

            return Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: context.isArabic
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        children: [
                          Consumer<AppDataProvider>(
                            builder: (_, model, __) {
                              return _removeSaveBtn(
                                  icon: Assets.iconsDelete,
                                  title: context.loc.remove,
                                  onTap: () {
                                    LocalProducts _localProduct =
                                        Helpers.getLocalProducts(
                                            context.read<AppDataProvider>(),
                                            cartItems?.variationData?.sku ??
                                                cartItems?.product?.sku);
                                    UpdateData.removeFromCart(
                                        sku: cartItems?.product?.sku ?? '',
                                        context: context,
                                        cartItemId: cartItems?.id ??
                                            '${_localProduct.cartItemId ?? ''}',
                                        fromCart: true);
                                  });
                            },
                          ),
                          ReusableWidgets.verticalDivider(
                            color: HexColor('#D9E3E3'),
                            margin: EdgeInsets.only(
                                left: (_width * 0.04), right: (_width * 0.03)),
                          ),
                          Opacity(
                            opacity:
                                (cartItems?.isStockAvailableForItem ?? false)
                                    ? 1.0
                                    : 0.3,
                            child: Consumer<AppDataProvider>(
                                builder: (_, model, __) {
                              String? sku = cartItems?.variationData?.sku ??
                                  cartItems?.product?.sku;
                              LocalProducts localProducts =
                                  Helpers.getLocalProducts(model, sku);
                              return _removeSaveBtn(
                                  icon: Assets.iconsWishlistBlack,
                                  title: context.loc.moveToWishList,
                                  onTap: () {
                                    if (AppData.accessToken.isEmpty) {
                                      NavRoutes.navToWishList(context,
                                          navFrom: RouteGenerator.routeCart);
                                    } else {
                                      if (!localProducts.isFavourite) {
                                        UpdateData.addToWishList(
                                            sku:
                                                cartItems?.variationData?.sku ??
                                                    cartItems?.product?.sku ??
                                                    '',
                                            name: '',
                                            fromCart: true,
                                            cartItemId:
                                                '${localProducts.cartItemId ?? ''}',
                                            context: context);
                                      } /*else {
                                        UpdateData.removeFromWishList(
                                            sku:
                                                cartItems?.variationData?.sku ??
                                                    cartItems?.product?.sku ??
                                                    '',
                                            context: context);
                                      }*/
                                    }
                                  });
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: _width * 0.02,
                ),
                _quantityTile(context, _width * 0.35, cartItems),
              ],
            );
          })
        ],
      ),
    );
  }

  Widget _removeSaveBtn(
      {required String icon,
      required String title,
      required Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              height: 11.h,
              width: 10.w,
            ),
            SizedBox(
              width: 6.w,
            ),
            Text(
              title,
              style: FontStyle.liteBlack12Medium,
            ).avoidOverFlow(),
          ],
        ),
      ),
    );
  }

  Widget _quantityTile(
      BuildContext context, double _width, CartItems? cartItem) {
    return Align(
      alignment:
          context.isArabic ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        height: 34.h,
        width: _width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
                color: (cartItems?.isStockAvailableForItem ?? false)
                    ? HexColor('#D9E3E3')
                    : HexColor('#E3BDBE'))),
        child: (cartItems?.isStockAvailableForItem ?? false)
            ? Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                      child: IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () {
                      String sku = cartItem?.variationData?.sku ??
                          cartItem?.product?.sku ??
                          '';
                      LocalProducts _localProduct = Helpers.getLocalProducts(
                          context.read<AppDataProvider>(), sku);
                      if ((cartItem?.quantity ?? 1) > 1) {
                        UpdateData.updateItemsFromCart(
                            sku: sku,
                            qty: (cartItem?.quantity ?? 1) - 1,
                            cartItemId: cartItem?.id ??
                                '${_localProduct.cartItemId ?? ''}',
                            context: context,
                            fromCart: true);
                      } else {
                        UpdateData.removeFromCart(
                            sku: sku,
                            context: context,
                            cartItemId: cartItem?.id ??
                                '${_localProduct.cartItemId ?? ''}',
                            fromCart: true);
                      }
                    },
                    icon: SvgPicture.asset(
                      Assets.iconsRemove,
                    ),
                  )),
                  ReusableWidgets.verticalDivider(
                    color: HexColor('#D9E3E3'),
                    height: 34.h,
                  ),
                  Expanded(
                      child: Center(
                          child: Text(
                    '${cartItem?.quantity ?? 1}',
                    style: FontStyle.liteBlack12Medium,
                    textAlign: TextAlign.center,
                  ).avoidOverFlow())),
                  ReusableWidgets.verticalDivider(
                    color: HexColor('#D9E3E3'),
                    height: 34.h,
                  ),
                  Expanded(
                      child: IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () {
                      LocalProducts _localProduct = Helpers.getLocalProducts(
                          context.read<AppDataProvider>(),
                          cartItem?.variationData?.sku ??
                              cartItem?.product?.sku);
                      UpdateData.updateItemsFromCart(
                          sku: cartItem?.product?.sku ?? '',
                          qty: (cartItem?.quantity ?? 1) + 1,
                          cartItemId: cartItem?.id ??
                              '${_localProduct.cartItemId ?? ''}',
                          context: context,
                          fromCart: true);
                    },
                    icon: SvgPicture.asset(
                      Assets.iconsAdd,
                    ),
                  ))
                ],
              )
            : Text(
                context.loc.outOfStock,
                textAlign: TextAlign.center,
                style: FontStyle.black12Medium
                    .copyWith(color: HexColor('#E50303')),
              ),
      ),
    );
  }
}
