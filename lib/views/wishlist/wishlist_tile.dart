import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/common/route_generator.dart';
import 'package:gogo_pharma/common/update_data.dart';
import 'package:gogo_pharma/generated/assets.dart';
import 'package:gogo_pharma/models/route_arguments.dart';
import 'package:gogo_pharma/services/helpers.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:gogo_pharma/widgets/common_button.dart';
import 'package:gogo_pharma/widgets/common_image_view.dart';

import 'package:gogo_pharma/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../../models/product_listing_model.dart';
import '../../providers/wishlist_provider.dart';

class WishListTile extends StatelessWidget {
  final int index;

  const WishListTile({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WishListProvider>(builder: (context, value, child) {
      Item? item = value.wishListItem?.items?[index].product;
      MaximumPrice? maximumPrice = item?.priceRange?.maximumPrice;
      return InkWell(
        onTap: () {
          Navigator.pushNamed(context, RouteGenerator.routeProductDetails,
              arguments: RouteArguments(sku: item?.sku));
        },
        child: Stack(
          children: [
            Container(
                padding: EdgeInsets.only(top: 12.h, left: 15.w, right: 15.w),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.sp)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          //PRODUCT IMAGE
                          ReusableWidgets.emptyBox(
                            childWidget: CommonImageView(
                              boxFit: BoxFit.contain,
                              image: item?.smallImage?.appImageUrl ?? "",
                            ),
                          ),
                          //PRODUCT IMAGE CLOSE
                          item?.stockStatus != "In Stock"
                              ? ReusableWidgets.outOfStockTag(context)
                              : ReusableWidgets.emptyBox(),
                        ],
                      ),
                    ),
                    //PRODUCT DETAILS
                    Flexible(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child:
                                LayoutBuilder(builder: (context, constraint) {
                              double _height = constraint.maxHeight;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ReusableWidgets.emptyBox(
                                    height: _height * 0.06.h,
                                  ),
                                  Text(item?.name ?? '',
                                          style: FontStyle.black13Medium
                                              .copyWith(height: 1.2.h))
                                      .avoidOverFlow(),
                                  ReusableWidgets.emptyBox(
                                    height: _height * 0.02.h,
                                  ),
                                  if ((item?.weight ?? '').isNotEmpty)
                                    Text(
                                      item?.weight ?? item?.volumn,
                                      style: FontStyle.litegrey11Regular
                                          .copyWith(height: 1.2.h),
                                      overflow: TextOverflow.ellipsis,
                                    ).avoidOverFlow(),
                                  ReusableWidgets.emptyBox(
                                    height: _height * 0.05.h,
                                  ),
                                  item?.priceRange?.maximumPrice?.discount
                                              ?.percentOff !=
                                          0
                                      ? Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Flexible(
                                              flex: 5,
                                              child: Text(
                                                Helpers.alignPrice(
                                                    maximumPrice?.regularPrice
                                                        ?.currency,
                                                    maximumPrice?.regularPrice),
                                                style: FontStyle
                                                    .litegrey11RegularLineThrough
                                                    .copyWith(height: 1.2.h),
                                              ).avoidOverFlow(),
                                            ),
                                            ReusableWidgets.emptyBox(
                                              width: 5.5.w,
                                            ),
                                            if (item?.priceRange?.maximumPrice
                                                    ?.discount?.percentOff !=
                                                0)
                                              Flexible(
                                                flex: 5,
                                                child: Text(
                                                  "${item?.priceRange?.maximumPrice?.discount?.percentOff ?? 0}%\t${context.loc.off}",
                                                  style: FontStyle
                                                      .primary11Medium
                                                      .copyWith(height: 1.2.h),
                                                ).avoidOverFlow(),
                                              ),
                                          ],
                                        )
                                      :
                                  ReusableWidgets.emptyBox(
                                    height: _height * 0.03.h,
                                  ),
                                  Text(
                                    Helpers.alignPrice(
                                        maximumPrice?.finalPrice?.currency,
                                        maximumPrice?.finalPrice),
                                    style: FontStyle.black13bold
                                        .copyWith(height: 1.2.h),
                                  ).avoidOverFlow(),
                                  ReusableWidgets.emptyBox(
                                    height: _height * 0.04.h,
                                  ),
                                ],
                              );
                            }),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 11.89.h),
                            height: 38.11.h,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.r)),
                                border: Border.all(
                                  width: 1.w,
                                  color: HexColor("#DEDEDE"),
                                )),
                            child: CommonButton(
                              buttonStyle: ElevatedButton.styleFrom(
                                onPrimary: Colors.white,
                                primary: Colors.white,
                                onSurface: HexColor("#DEDEDE"),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r)),
                                elevation: 0,
                              ),
                              onPressed: item?.stockStatus == "Out Of Stock"
                                  ? null
                                  : () {
                                      if (item?.typename == "SimpleProduct") {
                                        UpdateData.addProductToCart(
                                            fromWishList: true,
                                            sku: "${item?.sku}",
                                            context: context,
                                            qty: 1,
                                            wishlistSuccessText:
                                                context.loc.movedToCart);
                                        UpdateData.removeFromWishList(
                                            sku: item?.sku ?? "",
                                            context: context,
                                            fromWishList: true);
                                      } else {
                                        Navigator.pushNamed(context,
                                            RouteGenerator.routeProductDetails,
                                            arguments:
                                                RouteArguments(sku: item?.sku));
                                      }
                                    },
                              fontStyle: item?.stockStatus != "Out Of Stock"
                                  ? FontStyle.black14Medium
                                      .copyWith(height: 1.2.h)
                                  : FontStyle.disable14TextMedium
                                      .copyWith(height: 1.2.h),
                              buttonText: item?.typename == "SimpleProduct"
                                  ? context.loc.moveToCart
                                  : context.loc.viewProduct,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
            Positioned(
              right: 2,
              top: 2,
              child: InkWell(
                onTap: () {
                  UpdateData.removeFromWishList(
                      sku: item?.sku ?? "",
                      context: context,
                      fromWishList: true);
                },
                child: CircleAvatar(
                  backgroundColor: Colors.white12,
                  radius: 20.r,
                  child: SvgPicture.asset(
                    Assets.iconsWishlistTileClose,
                    height: 23.h,
                    width: 23.w,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
