import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/common/route_generator.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:gogo_pharma/views/product_details/product_detail_back_tile.dart';
import 'package:gogo_pharma/views/product_details/product_detail_rating_tile.dart';
import 'package:gogo_pharma/widgets/reusable_widgets.dart';

import '../../common/constants.dart';
import '../../models/product_listing_model.dart';

class ProductDetailsWidgets {
  static ProductDetailsWidgets? _instance;

  static ProductDetailsWidgets get instance {
    _instance ??= ProductDetailsWidgets();
    return _instance!;
  }


  List<Widget> productDetailRatingTile(
      BuildContext context, Item? productItem) {
    return (productItem?.productReviewCount ?? 0) == 0
        ? []
        : [
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.only(top: 7.h),
                padding: EdgeInsets.fromLTRB(16.w, 19.h, 16.w, 15.h),
                color: Colors.white,
                child: Text(
                  context.loc.ratings,
                  style: FontStyle.black16Medium,
                  maxLines: 2,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.only(left: 16.h, right: 16.h, bottom: 30.h),
                child: RatingIndicatorTile(
                  productItem: productItem,
                ),
              ),
            ),
            if (productItem?.reviews?.items != null &&
                productItem!.reviews!.items!.isNotEmpty) ...[
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                return productItem.reviews?.items?[index] == null
                    ? const SizedBox()
                    : RatingTile(
                        reviewsItem: productItem.reviews?.items?[index],
                      );
              }, childCount: productItem.reviews?.items?.length)),
              SliverToBoxAdapter(
                child: ReusableWidgets.divider(
                    color: HexColor('#EAF2F2'), height: 1.h),
              ),
              SliverToBoxAdapter(
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(
                      context, RouteGenerator.routeAllReviews,
                      arguments: productItem.sku),
                  child: ProductDetailBackTile(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 14.h),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            context.loc.allReviews,
                            style: FontStyle.green14Medium_36BFB8,
                          )),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: HexColor('#556879'),
                            size: 16.r,
                          )
                        ],
                      )),
                ),
              )
            ]
          ];
  }
}
