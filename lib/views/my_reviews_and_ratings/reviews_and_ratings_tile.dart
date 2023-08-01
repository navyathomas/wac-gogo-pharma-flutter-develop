import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/common/route_generator.dart';
import 'package:gogo_pharma/models/route_arguments.dart';
import 'package:gogo_pharma/providers/reviews_and_ratings_provider.dart';
import 'package:gogo_pharma/views/my_reviews_and_ratings/ReviewWriteTile.dart';
import 'package:gogo_pharma/views/my_reviews_and_ratings/review_product_screen.dart';
import 'package:gogo_pharma/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../../utils/color_palette.dart';
import '../../widgets/common_image_view.dart';

class ReviewsAndRatingTile extends StatelessWidget {
  final Function(bool)? onComplete;
  const ReviewsAndRatingTile(
      {Key? key,  required this.index, this.onComplete})
      : super(key: key);


  final int? index;

  @override
  Widget build(BuildContext context) {
    return Consumer<ReviewsAndRatingsProvider>(
        builder: (context, value, child) {
          if (index != null) {
            return Column(
              children: [
                ReusableWidgets.emptyBox(height: 8.h),
                InkWell(onTap: () {
                  Navigator.pushNamed(context,
                      RouteGenerator.routeProductDetails,
                      arguments:
                      RouteArguments(
                          sku: value.pendingReviewsList?[index??0].sku));
                },
                  child: Container(
                    padding: EdgeInsets.only(
                        top: 27.25.h,
                        bottom: 22.h,
                        right: context.isArabic ? 13.w : 54.w,
                        left: context.isArabic ? 54.w : 13.w),

                    color: HexColor("#FFFFFF"),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: context.isArabic
                                ? 0
                                : 12.w),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(
                                  8.r)),
                              child: CommonImageView(
                                height: 82.h,
                                width:  82.w,
                                image: value.pendingReviewsList?[index??0]
                                    .smallImage
                                    ?.url ??
                                    "",
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:EdgeInsets.only(
                                        left: context.isArabic ? 0 : 8.w),
                                    child: Text(
                                      value.pendingReviewsList?[index??0].sku ??
                                          "",
                                      overflow: TextOverflow.ellipsis,
                                      style: FontStyle.grey_696969_13Regular,
                                    ).avoidOverFlow(
                                        maxLine:  2),
                                  ),
                                  ReusableWidgets.emptyBox(
                                      height:  6.h),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context,
                                            RouteGenerator.routeReviewProduct,
                                            arguments: RouteArguments(
                                                reviewImageUrl:value
                                                    .pendingReviewsList?[index??0]
                                                    .smallImage?.url,
                                                reviewProductName:value
                                                    .pendingReviewsList?[index??0]
                                                    .name,sku: value
                                                .pendingReviewsList?[index??0].sku)).then((value) {
                                                  if(onComplete != null) onComplete!(true);
                                        });

                                        value.reviewStatus = "";
                                        value.ratingValue = 0;
                                      },
                                      child: Text(
                                        context.loc.writeReview,
                                      )),
                                ]),
                          )
                        ]),
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
