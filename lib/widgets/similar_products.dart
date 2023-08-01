import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/route_generator.dart';
import 'package:gogo_pharma/widgets/common_product_card.dart';
import 'package:gogo_pharma/widgets/reusable_functions.dart';
import 'package:gogo_pharma/widgets/reusable_widgets.dart';

import '../models/product_listing_model.dart';
import '../models/route_arguments.dart';

class SimilarProductWidgets extends StatelessWidget {
  final NavFromState navFromState;
  final List<Item>? relatedProducts;
  final Function? onCall;
  const SimilarProductWidgets(
      {Key? key,
      this.relatedProducts,
      this.onCall,
      this.navFromState = NavFromState.navFromProductDetail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: (relatedProducts != null && relatedProducts!.isNotEmpty
              ? Column(
                  children: [
                    ReusableWidgets.headTileRow(context,
                        title: context.loc.similarProducts,
                        trailingText: context.loc.viewAll,
                        enableShopAll: false,
                        padding: EdgeInsets.only(
                            top: 20.h, bottom: 10.h, left: 16.w, right: 16.w),
                        onTap: () => Navigator.pushNamed(
                            context, RouteGenerator.routeProductListing,
                            arguments: RouteArguments(title: '', id: ''))),
                    SizedBox(
                      height: 340.h,
                      child: LayoutBuilder(builder: (context, constraints) {
                        return ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (cxt, index) {
                              double _width =
                                  (constraints.maxWidth * 0.5) - 7.5.w;
                              Item? _relatedProduct = relatedProducts?[index];
                              MaximumPrice? maxPrice =
                                  _relatedProduct?.priceRange?.maximumPrice;
                              return GestureDetector(
                                onTap: () => Navigator.pushNamed(context,
                                        RouteGenerator.routeProductDetails,
                                        arguments: RouteArguments(
                                            sku: _relatedProduct?.sku ?? '',
                                            item: _relatedProduct))
                                    .then((value) {
                                  if (onCall != null) onCall!();
                                }),
                                child: SizedBox(
                                  width: _width,
                                  child: ProductCard(
                                    stockStatus: _relatedProduct?.stockStatus,
                                    navFromState: navFromState,
                                    type: _relatedProduct?.typename ?? '',
                                    sku: _relatedProduct?.sku ?? '',
                                    productName: _relatedProduct?.name ?? '',
                                    productImage: _relatedProduct
                                            ?.smallImage?.appImageUrl ??
                                        '',
                                    quantityAndUnit:
                                        '${_relatedProduct?.weight ?? _relatedProduct?.volumn ?? ''}',
                                    rating:
                                        '${_relatedProduct?.ratingData?.ratingAggregationValue ?? ''}',
                                    actualPrice: ReusableFunctions
                                            .checkDiscount(maxPrice)
                                        ? '${maxPrice?.regularPrice?.value ?? '0.0'}'
                                        : '',
                                    offerPercentage:
                                        '${maxPrice?.discount?.percentOff ?? '0'}',
                                    currency: maxPrice?.regularPrice?.currency ?? '',
                                    offerPrice:
                                        '${maxPrice?.finalPrice?.value ?? '0.0'}',
                                    onViewTap: () => Navigator.pushNamed(
                                            context,
                                            RouteGenerator.routeProductDetails,
                                            arguments: RouteArguments(
                                                sku:
                                                    _relatedProduct?.sku ?? ''))
                                        .then((value) {
                                      if (onCall != null) onCall!();
                                    }),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (_, __) => SizedBox(
                                  width: 5.w,
                                ),
                            itemCount: relatedProducts?.length ?? 0);
                      }),
                    )
                  ],
                )
              : const SizedBox())
          .animatedSwitch(),
    );
  }
}
