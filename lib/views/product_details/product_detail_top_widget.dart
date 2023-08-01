import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/common/route_generator.dart';
import 'package:gogo_pharma/common/update_data.dart';
import 'package:gogo_pharma/generated/assets.dart';
import 'package:gogo_pharma/models/local_products.dart';
import 'package:gogo_pharma/models/product_listing_model.dart';
import 'package:gogo_pharma/providers/app_data_provider.dart';
import 'package:gogo_pharma/services/app_config.dart';
import 'package:gogo_pharma/services/firebase_dynamic_link_sevices.dart';
import 'package:gogo_pharma/services/helpers.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:gogo_pharma/views/product_details/product_detail_back_tile.dart';
import 'package:gogo_pharma/widgets/common_image_view.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../common/nav_routes.dart';
import '../../widgets/reusable_functions.dart';
import '../../widgets/reusable_widgets.dart';

class ProductDetailTopWidget extends StatelessWidget {
  final PageController controller;
  final Item? productItem;

  const ProductDetailTopWidget(
      {Key? key, required this.controller, this.productItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: ProductDetailBackTile(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductDetailImage(
                controller: controller,
                productItem: productItem,
              ),
              ProductDetailTitleTile(
                productItem: productItem,
              )
            ],
          )),
    );
  }
}

class ProductDetailTitleTile extends StatelessWidget {
  final Item? productItem;

  const ProductDetailTitleTile({Key? key, required this.productItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 13.h,
          ),
          Text(
            productItem?.name ?? '',
            style: FontStyle.black19Medium,
          ),
          SizedBox(
            height: 8.h,
          ),
          _rating(context, productItem?.ratingData),
          SizedBox(
            height: 11.h,
          ),
          _priceWidget(context,
              price: productItem?.priceRange?.maximumPrice,
              currency:
                  productItem?.priceRange?.maximumPrice?.finalPrice?.currency),
          SizedBox(
            height: 8.h,
          ),
          _stockAndDeliveryTile(context, productItem?.getDeliveryMode),
          SizedBox(
            height: 20.h,
          ),
        ],
      ),
    );
  }

  Widget _rating(BuildContext context, RatingData? ratingData) {
    return Row(
      children: [
        if ('${ratingData?.ratingAggregationValue ?? ''}' != '0.0') ...[
          SvgPicture.asset(
            Assets.iconsStar,
            height: 11.r,
            width: 11.r,
          ),
          SizedBox(
            width: 5.w,
          ),
          Text(
              '${ratingData?.ratingAggregationValue}'
                  .cvtToAr(loc: context.myLocale),
              style: FontStyle.black13Regular)
        ],
        SizedBox(
          width: 2.w,
        ),
        if ((ratingData?.productReviewCount ?? '').isNotEmpty)
          Flexible(
              child: Text(
            '(${(ratingData?.productReviewCount ?? '').cvtToAr(loc: context.myLocale)})',
            style: FontStyle.grey_6E6E6E_13Regular,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ))
      ],
    );
  }

  Widget _priceWidget(BuildContext context,
      {MaximumPrice? price, String? currency = ''}) {
    return RichText(
        textAlign: TextAlign.start,
        text: TextSpan(children: [
          if (ReusableFunctions.checkDiscount(price)) ...[
            TextSpan(
                text: Helpers.alignPrice(currency, price?.regularPrice),
                style: FontStyle.grey15Regular8A9CACLine),
            WidgetSpan(
                child: SizedBox(
              width: 8.w,
            ))
          ],
          TextSpan(
              text: Helpers.alignPrice(currency, price?.finalPrice),
              style: FontStyle.black18SemiBold),
          WidgetSpan(
              child: SizedBox(
            width: 7.w,
          )),
          if (ReusableFunctions.checkDiscount(price))
            TextSpan(
                text:
                    Helpers.alignDiscount(price?.discount?.percentOff, context),
                style: FontStyle.primary14Medium),
        ]));
  }

  Widget _stockAndDeliveryTile(
      BuildContext context, GetDeliveryMode? getDeliveryMode) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        productItem?.stockStatus ?? '',
        style: (productItem?.stockStatus ?? '') == 'In Stock'
            ? FontStyle.green13Medium
            : FontStyle.green13Medium.copyWith(color: HexColor('#FF7373')),
      ),
      if ((getDeliveryMode?.deliveryText ?? '').isNotEmpty) ...[
        SizedBox(
          height: 12.h,
        ),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SvgPicture.asset(
              Assets.iconsTruck,
              height: 12.h,
              width: 14.w,
            ),
            SizedBox(
              width: 7.w,
            ),
            Text(
              getDeliveryMode?.deliveryText ?? '',
              style: FontStyle.grey12Medium_556879,
            ),
            if (getDeliveryMode?.isFreeDelivery ?? false) ...[
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
        )
      ]
    ]);
  }
}

class ProductDetailImage extends StatelessWidget {
  final PageController controller;
  final Item? productItem;

  const ProductDetailImage(
      {Key? key, required this.controller, this.productItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (productItem == null) return const SizedBox();
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(0, 43.h, 0, 0),
          height: 320.h,
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: controller,
                  children: List.generate(
                    productItem?.mediaGallery?.length ?? 0,
                    (int index) => Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: CommonImageView(
                        image: '${productItem?.mediaGallery?[index].url}',
                        height: 296.h,
                        boxFit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              if ((productItem?.mediaGallery?.length ?? 0) > 1)
                SmoothPageIndicator(
                  controller: controller,
                  count: productItem?.mediaGallery?.length ?? 0,
                  effect: ExpandingDotsEffect(
                      paintStyle: PaintingStyle.fill,
                      expansionFactor: 2,
                      activeDotColor: ColorPalette.primaryColor,
                      dotColor: HexColor('#D9E3E3'),
                      spacing: 6.6.w,
                      dotHeight: 7.0.w,
                      dotWidth: 7.0.w),
                )
            ],
          ),
        ),
        Positioned(
          right: 10.w,
          top: 15.h,
          child: Column(
            children: [
              Consumer<AppDataProvider>(builder: (_, model, __) {
                String? sku = productItem?.parentSku ?? productItem?.sku ?? '';
                LocalProducts localProducts =
                    Helpers.getLocalProducts(model, sku);
                return CircleAvatar(
                  backgroundColor: Colors.white12,
                  child: IconButton(
                    onPressed: () {
                      if (AppData.accessToken.isNotEmpty) {
                        if (!localProducts.isFavourite) {
                          UpdateData.addToWishList(
                              sku: sku,
                              context: context,
                              name: productItem?.name ?? '');
                        } else {
                          UpdateData.removeFromWishList(
                              sku: sku, context: context);
                        }
                      } else {
                        NavRoutes.navToLogin(context,
                                navFrom: RouteGenerator.routeProductDetails)
                            .then((value) {
                          if (AppData.accessToken.isNotEmpty) {
                            if (!localProducts.isFavourite) {
                              UpdateData.addToWishList(
                                  sku: sku,
                                  context: context,
                                  name: productItem?.name ?? '');
                            } else {
                              UpdateData.removeFromWishList(
                                  sku: sku, context: context);
                            }
                          }
                        });
                      }
                    },
                    icon: localProducts.isFavourite
                        ? SvgPicture.asset(
                            Assets.iconsFavOrange,
                            height: 23.r,
                            width: 23.r,
                          )
                        : SvgPicture.asset(
                            Assets.iconsWishlist,
                            color: HexColor('#8A9CAC'),
                            height: 23.r,
                            width: 23.r,
                          ),
                    padding: EdgeInsets.zero,
                  ),
                );
              }),
              SizedBox(
                height: 5.h,
              ),
              CircleAvatar(
                backgroundColor: Colors.white12,
                child: IconButton(
                  onPressed: () => shareProduct(context, productItem),
                  icon: SvgPicture.asset(
                    Assets.iconsShare,
                    color: HexColor('#8A9CAC'),
                    height: 22.r,
                    width: 22.r,
                  ),
                  padding: EdgeInsets.zero,
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Future<void> shareProduct(BuildContext context, Item? productItem) async {
    ReusableWidgets.customCircularLoader(context);
    try {
      String shareCode = await FirebaseDynamicLinkServices.instance
          .createDynamicLink(
              sku: productItem?.sku ?? '',
              name: productItem?.name ?? '',
              image: productItem?.smallImage?.appImageUrl ?? "",
              url: productItem?.shareUrl);
      String text =
          'Check this out ${productItem?.name ?? ''} \n$shareCode on Gogo Pharma';
      Share.share(text)
          .whenComplete(() => context.rootPop())
          .onError((error, stackTrace) => context.rootPop());
    } catch (_) {
      context.rootPop();
    }
  }
}
