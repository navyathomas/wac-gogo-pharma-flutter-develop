import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/nav_routes.dart';
import 'package:gogo_pharma/common/update_data.dart';
import 'package:gogo_pharma/common/route_generator.dart';
import 'package:gogo_pharma/generated/assets.dart';
import 'package:gogo_pharma/common/font_Style.dart';
import 'package:gogo_pharma/models/local_products.dart';
import 'package:gogo_pharma/providers/app_data_provider.dart';
import 'package:gogo_pharma/providers/wishlist_provider.dart';
import 'package:gogo_pharma/services/app_config.dart';
import 'package:gogo_pharma/services/helpers.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:gogo_pharma/widgets/common_button.dart';
import 'package:gogo_pharma/widgets/common_image_view.dart';
import 'package:gogo_pharma/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatefulWidget {
  final NavFromState? navFromState;
  final String productImage;
  final String productName;
  final String? quantityAndUnit;
  final String rating;
  final String currency;
  final String actualPrice;
  final String offerPercentage;
  final String offerPrice;
  final String type;
  final String sku;
  final Function? onViewTap;
  final String? stockStatus;

  final bool offerTag;
  const ProductCard(
      {Key? key,
      this.offerTag = false,
      this.productName = "",
      this.quantityAndUnit,
      this.rating = "",
      this.actualPrice = "",
      this.offerPercentage = "",
      this.offerPrice = "",
      this.productImage = "",
      this.currency = "",
      this.type = "",
      this.sku = "",
      this.onViewTap,
      this.stockStatus = "",
      required this.navFromState})
      : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final ValueNotifier<bool> addButton = ValueNotifier<bool>(true);
  final ValueNotifier<int> count = ValueNotifier<int>(1);

  @override
  Widget build(BuildContext context) {
    double textScale =
        Helpers.validateScale(MediaQuery.of(context).textScaleFactor) - 1;
    return Stack(
      children: [
        Container(
            width: 180.w,
            padding: EdgeInsets.only(
              top: 14.h,
            ),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8.sp)),
            child: Column(
              children: [
                // SizedBox(
                //   height: 9.27.h,
                // ),
                SizedBox(height: 2.h),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      //PRODUCT IMAGE
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          CommonImageView(
                            image: widget.productImage,
                            height: 142.h,
                            width: context.sw(),
                            boxFit: BoxFit.contain,
                          ),
                          widget.stockStatus != "In Stock"
                              ? ReusableWidgets.outOfStockTag(context)
                              : const SizedBox(),
                        ],
                      ),
                      //PRODUCT IMAGE CLOSE

                      //RATING
                      widget.rating == "" || widget.rating == "0.0"
                          ? const SizedBox()
                          : Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6.0.h)),
                                  border: Border.all(
                                      color: HexColor('#E6E6E6'), width: 1.h)),
                              height: 20.h,
                              width: 41.w,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: SizedBox(
                                      height: 10.59.h,
                                      width: 10.59.w,
                                      child: SvgPicture.asset(
                                        Assets.iconsRatestar,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 3.5.h,
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Text(
                                      widget.rating,
                                      style: FontStyle.litegrey11Regular,
                                    ).avoidOverFlow(),
                                  )
                                ],
                              ))
                      //RATING CLOSE
                    ],
                  ),
                ),

                // SizedBox(
                //   height: 11.85.h,
                // ),
                SizedBox(
                  height: 7.h,
                ),

                //PRODUCT DETAILS
                SizedBox(
                  height: 110.h + (textScale * 150), //<== latest added height
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          widget.productName,
                          style: FontStyle.liteblack13Medium,
                        ).avoidOverFlow(maxLine: 2),

                        widget.quantityAndUnit == "" ||
                                widget.quantityAndUnit == null ||
                                widget.quantityAndUnit == "null"
                            ? const SizedBox()
                            : context.isArabic
                                ? SizedBox(
                                    height: 1.h,
                                  )
                                : SizedBox(
                                    height: 5.h,
                                  ),
                        //  SizedBox(
                        //     height: 1.9.h,
                        //   ),
                        widget.quantityAndUnit == "" ||
                                widget.quantityAndUnit == null ||
                                widget.quantityAndUnit == "null"
                            ? const SizedBox()
                            : Text(
                                widget.quantityAndUnit!,
                                style: FontStyle.litegrey11Regular,
                              ).avoidOverFlow(),
                        widget.actualPrice == ""
                            ? SizedBox(
                                height: 2.h,
                              )
                            :
                            // SizedBox(
                            //   height: 1.9.h,
                            // ),
                            SizedBox(
                                height: 5.h,
                              ),

                        Row(
                          children: [
                            Flexible(
                              flex: 5,
                              child: widget.actualPrice == ""
                                  ? const SizedBox()
                                  // SizedBox(height: 14.h)
                                  : Text(
                                      Helpers.alignCustomPrice(
                                          widget.currency,
                                          Helpers.convertToDouble(
                                              widget.actualPrice)),
                                      style: FontStyle
                                          .litegrey11RegularLineThrough,
                                    ).avoidOverFlow(),
                            ),
                            widget.actualPrice == ""
                                ? const SizedBox()
                                : SizedBox(
                                    width: 3.5.w,
                                  ),
                            Flexible(
                              flex: 5,
                              child: widget.actualPrice == ""
                                  ? const SizedBox()
                                  // SizedBox(
                                  //     height: 14.h,
                                  //  )
                                  : Text(
                                      Helpers.alignDiscount(
                                          widget.offerPercentage, context),
                                      style: FontStyle.primary11Medium,
                                    ).avoidOverFlow(),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 3.63.h,
                        ),
                        Text(
                          Helpers.alignCustomPrice(widget.currency,
                              Helpers.convertToDouble(widget.offerPrice)),
                          style: FontStyle.black13bold,
                        ).avoidOverFlow(),
                        // SizedBox(
                        //   height: 16.56.h,
                        // ),
                        SizedBox(
                          height: 8.15.h,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child:
                      Consumer<AppDataProvider>(builder: (context, model, _) {
                    LocalProducts _localProduct =
                        model.appProductData[widget.sku] ?? LocalProducts();
                    return _localProduct.quantity == 0
                        ? SizedBox(
                            height: 35.h,
                            child: CommonButton(
                              onPressed: widget.stockStatus == "OUT_OF_STOCK" ||
                                      widget.stockStatus == "Out Of Stock" ||
                                      widget.stockStatus == "Out_Of_Stock" ||
                                      widget.stockStatus == "out of stock" ||
                                      widget.stockStatus == "out_of_stock" ||
                                      widget.stockStatus == "OUT OF STOCK" ||
                                      widget.stockStatus == "" ||
                                      widget.stockStatus == null
                                  ? null
                                  : () {
                                      if (widget.type.toLowerCase() ==
                                          Constants.configurableProduct) {
                                        if (widget.onViewTap != null) {
                                          widget.onViewTap!();
                                        }
                                      } else {
                                        UpdateData.addProductToCart(
                                            sku: widget.sku,
                                            context: context,
                                            fromCart: widget.navFromState !=
                                                    null &&
                                                widget.navFromState ==
                                                    NavFromState.navFromCart,
                                            qty: 1);
                                      }
                                    },
                              buttonText: widget.type.toLowerCase() ==
                                      Constants.configurableProduct
                                  ? context.loc.view
                                  : context.loc.add,
                            ),
                          )
                        : quantityButton(_localProduct);
                  }),
                ),
                SizedBox(height: 15.22.h)
                //PRODUCT DETAILS CLOSE
              ],
            )),

        //OFFER TAG
        widget.offerTag
            ? Padding(
                padding: EdgeInsets.only(top: 11.h, left: 10.h),
                child: SizedBox(
                  width: 40.h,
                  height: 40.h,
                  child: SvgPicture.asset(
                    Assets.iconsRedCircle,
                  ),
                ),
              )
            : const SizedBox(),

        //OFFER TAG CLOSE
        //FAVOURATE ICON
        Consumer<AppDataProvider>(builder: (_, model, __) {
          String? sku = widget.sku;
          LocalProducts localProducts = Helpers.getLocalProducts(model, sku);
          return Positioned(
            top: 2.h,
            right: 2.w,
            child: InkWell(
              onTap: () {
                if (AppData.accessToken.isNotEmpty) {
                  addToWishList(model);
                } else {
                  switch (widget.navFromState) {
                    case NavFromState.navFromCart:
                      NavRoutes.navToLogin(context,
                              navFrom: RouteGenerator.routeCart)
                          .then((value) {
                        addToWishList(model);
                      });
                      break;
                    case NavFromState.navFromProductList:
                      NavRoutes.navToLogin(context,
                              navFrom: RouteGenerator.routeProductListing)
                          .then((value) {
                        addToWishList(model);
                      });
                      break;
                    case NavFromState.navFromProductDetail:
                      NavRoutes.navToLogin(context,
                              navFrom: RouteGenerator.routeProductDetails)
                          .then((value) {
                        addToWishList(model);
                      });
                      break;

                    default:
                      NavRoutes.navToLogin(context);
                  }
                }
              },
              child: CircleAvatar(
                backgroundColor: Colors.white12,
                radius: 20.r,
                child: localProducts.isFavourite
                    ? SizedBox(
                        height: 14.h,
                        width: 17.h,
                        child: SvgPicture.asset(
                          Assets.iconsFavOrange,
                        ),
                      )
                    : SizedBox(
                        height: 14.h,
                        width: 17.h,
                        child: SvgPicture.asset(
                          Assets.iconsFavourate,
                        ),
                      ),
              ),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
          );
        }),
        //FAVOURATE ICON CLOSE
      ],
    );
  }

  Widget quantityButton(LocalProducts _localProduct) {
    return Container(
      height: 35.h,
      width: 148.w,
      decoration: BoxDecoration(
          border: Border.all(color: ColorPalette.borderGreenGrey),
          borderRadius: BorderRadius.circular(8.sp)),
      child: Row(
        children: [
          _localProduct.quantity == 1
              ? Flexible(
                  flex: 3,
                  child: InkWell(
                    onTap: () => UpdateData.removeFromCart(
                        sku: widget.sku,
                        context: context,
                        cartItemId: '${_localProduct.cartItemId ?? ''}',
                        fromCart: widget.navFromState != null &&
                            widget.navFromState == NavFromState.navFromCart),
                    child: Center(
                      child: SvgPicture.asset(
                        Assets.iconsDelete,
                      ),
                    ),
                  ),
                )
              : Flexible(
                  flex: 3,
                  child: InkWell(
                    onTap: (() => UpdateData.updateItemsFromCart(
                        sku: widget.sku,
                        qty: (_localProduct.quantity ?? 2) - 1,
                        context: context,
                        cartItemId: '${_localProduct.cartItemId ?? ''}',
                        fromCart: widget.navFromState != null &&
                            widget.navFromState == NavFromState.navFromCart)),
                    child: const SizedBox(
                        child: Center(
                            child: Icon(
                      Icons.remove,
                      size: 19,
                    ))),
                  ),
                ),
          Container(
            color: ColorPalette.borderGreenGrey,
            width: 1,
          ),
          Flexible(
            flex: 4,
            child: SizedBox(
                child: Center(child: Text('${_localProduct.quantity ?? 1}'))),
          ),
          Container(
            color: ColorPalette.borderGreenGrey,
            width: 1,
          ),
          Flexible(
            flex: 3,
            child: InkWell(
              onTap: widget.stockStatus == "OUT_OF_STOCK" ||
                      widget.stockStatus == "Out Of Stock" ||
                      widget.stockStatus == "Out_Of_Stock" ||
                      widget.stockStatus == "out of stock" ||
                      widget.stockStatus == "out_of_stock" ||
                      widget.stockStatus == "OUT OF STOCK" ||
                      widget.stockStatus == "" ||
                      widget.stockStatus == null
                  ? null
                  : (() => UpdateData.addProductToCart(
                        sku: widget.sku,
                        context: context,
                        fromCart: widget.navFromState != null &&
                            widget.navFromState == NavFromState.navFromCart,
                        qty: 1,
                      )),
              child: SizedBox(
                  child: Center(
                child: SvgPicture.asset(
                  Assets.iconsAdd,
                ),
              )),
            ),
          )
        ],
      ),
    );
  }

  void addToWishList(AppDataProvider model) {
    String? sku = widget.sku;
    LocalProducts localProducts = Helpers.getLocalProducts(model, sku);
    if (AppData.accessToken.isNotEmpty) {
      if (!localProducts.isFavourite) {
        UpdateData.addToWishList(
            sku: sku, context: context, name: widget.productName);
      } else {
        UpdateData.removeFromWishList(sku: sku, context: context);
      }
    }
  }
}
