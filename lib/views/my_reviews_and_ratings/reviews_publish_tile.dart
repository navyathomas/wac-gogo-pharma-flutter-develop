import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/generated/assets.dart';
import 'package:gogo_pharma/providers/reviews_and_ratings_provider.dart';

import 'package:gogo_pharma/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../../common/route_generator.dart';
import '../../models/reviews_and_ratings_models/customer_publish_review_model.dart';
import '../../models/route_arguments.dart';
import '../../utils/color_palette.dart';
import '../../widgets/common_image_view.dart';
import 'package:readmore/readmore.dart';

class ReviewsPublishTile extends StatelessWidget {
  final BuildContext? buildCxt;
  const ReviewsPublishTile({
    Key? key,
    this.index,
    this.buildCxt
  }) : super(key: key);

  final int? index;

  @override
  Widget build(BuildContext context) {
    return Consumer<ReviewsAndRatingsProvider>(
        builder: (ctx, value, child) {
      double? _ratingValue;
      Items? reviewPublishList = value.reviewsList?.items?.elementAt(index!);
      return Column(
        children: [
          ReusableWidgets.emptyBox(height: 8.h),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, RouteGenerator.routeProductDetails,
                  arguments: RouteArguments(
                      sku: value.reviewsList?.items?[index ?? 0].product?.sku));
            },
            child: Container(
              padding: EdgeInsets.only(
                top: 27.h,
                left: 13.w,
                right: 13.w,
              ),
              color: HexColor("#FFFFFF"),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 12.w),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.r)),
                            child: CommonImageView(
                              height: 82.h,
                              width: 82.w,
                              image:
                                  reviewPublishList?.product?.smallImage?.url ??
                                      '',
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 4.w, right: 37.w),
                                  child: Text(
                                    reviewPublishList?.product?.name ?? "",
                                    overflow: TextOverflow.ellipsis,
                                    style: FontStyle.grey_696969_13Regular,
                                  ).avoidOverFlow(maxLine: 1),
                                ),
                                ReusableWidgets.emptyBox(height: 7.h),
                                reviewPublishList?.summary != null &&
                                        reviewPublishList?.summary != ""
                                    ? Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 4.w),
                                            child: Text(
                                              reviewPublishList?.summary ?? "",
                                              overflow: TextOverflow.ellipsis,
                                              style: FontStyle.black13Medium,
                                            ).avoidOverFlow(maxLine: 1),
                                          ),
                                          ReusableWidgets.emptyBox(
                                              height: 14.44.h),
                                        ],
                                      )
                                    : SizedBox(),
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    RatingBar(
                                        glow: false,
                                        ignoreGestures: true,
                                        itemPadding: EdgeInsets.zero,
                                        initialRating: reviewPublishList
                                                ?.ratingValue
                                                ?.ceilToDouble() ??
                                            0,
                                        wrapAlignment: WrapAlignment.center,
                                        itemSize: 27,
                                        direction: Axis.horizontal,
                                        itemCount: 5,
                                        ratingWidget: RatingWidget(
                                            full: Icon(
                                              Icons.star_rounded,
                                              color: HexColor("#FEC462"),
                                            ),
                                            half: const Icon(
                                              Icons.star_half_rounded,
                                              color: Colors.orange,
                                            ),
                                            empty: Icon(
                                              Icons.star_border_rounded,
                                              color: HexColor("#EAEAEA"),
                                            )),
                                        onRatingUpdate: (value) {
                                          _ratingValue = value;
                                        }),
                                    ReusableWidgets.emptyBox(width: 20.17.w),
                                    Text(
                                      reviewPublishList?.createdAt ?? "",
                                      style: FontStyle.grey_696969_10Regular,
                                    )
                                  ],
                                ),
                              ]),
                        )
                      ]),
                  if ((reviewPublishList?.text ?? '').isNotEmpty) ...[
                    ReusableWidgets.emptyBox(height: 17.22.h),
                    ReadMoreText(
                      reviewPublishList?.text ?? "",
                      textAlign: TextAlign.left,
                      style: FontStyle.black13Medium_212121,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: " Read More",
                      trimLines: 3,
                      trimExpandedText: " Read Less",
                    ),
                  ],
                  ReusableWidgets.emptyBox(height: 19.5.h),
                  Divider(color: HexColor("#D9E3E3"), thickness: 1, height: 1),
                  SizedBox(
                    height: 49.h,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: InkWell(
                          onTap: () async{

                           await value.deleteEditReview(buildCxt ?? context,
                                reviewID: reviewPublishList?.id);


                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(Assets.iconsDelete),
                                Padding(
                                  padding: EdgeInsets.only(left: 7.w),
                                  child: Text(context.loc.remove,
                                      style: FontStyle.grey12Regular_6969),
                                ),
                              ],
                            ),
                          ),
                        )),

                        ///edit will be needed
                        // ReusableWidgets.emptyBox(
                        //     height: 13.56.h,
                        //     width: 2.w,
                        //     childWidget: VerticalDivider(
                        //       color: HexColor("#D9E3E3"),
                        //       thickness: 1,
                        //     )),
                        // Expanded(
                        //     child: InkWell(
                        //   onTap: () {
                        //     value.updateEditReview(context,
                        //         summary: reviewPublishList?.text,
                        //         text: reviewPublishList?.summary,value:reviewPublishList
                        //             ?.ratingValue ,productSku: reviewPublishList?.product?.sku,reviewID: reviewPublishList?.id);
                        //   },
                        //   child: Container(
                        //     padding: EdgeInsets.symmetric(vertical: 15.h),
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       children: [
                        //         SvgPicture.asset(Assets.iconsEdit),
                        //         Padding(
                        //           padding: EdgeInsets.only(left: 7.w),
                        //           child: Text(context.loc.edit,
                        //               style: FontStyle.grey12Regular_6969),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // )),
                        ///
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
