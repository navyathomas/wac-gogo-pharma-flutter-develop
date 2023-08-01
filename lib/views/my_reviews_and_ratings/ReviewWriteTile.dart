import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/providers/reviews_and_ratings_provider.dart';
import 'package:gogo_pharma/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../../utils/color_palette.dart';
import '../../widgets/common_image_view.dart';

class ReviewWriteTile extends StatelessWidget {
  const ReviewWriteTile(
      {Key? key,
      this.reviewImageUrl,
      this.reviewProductName,})
      : super(key: key);
  final String? reviewImageUrl;
 final  String? reviewProductName;


  @override
  Widget build(BuildContext context) {
    return Consumer<ReviewsAndRatingsProvider>(
        builder: (context, value, child) {
      return Column(
        children: [
          ReusableWidgets.emptyBox(height: 8.h),
          Container(
            padding: EdgeInsets.only(
                top: 17.h,
                right: context.isArabic ? 15.w : 53.w,
                left: context.isArabic ? 53.w : 15.w),
            height: 108.h,
            color: HexColor("#FFFFFF"),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(right: context.isArabic ? 0 : 16.w),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(8.r)),
                      child: CommonImageView(
                        height: 72.h,
                        width: 72.w,
                        image: reviewImageUrl ?? "",
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: context.isArabic ? 0 : 4.w),
                            child: Text(
                              reviewProductName ?? "",
                              overflow: TextOverflow.ellipsis,
                              style: FontStyle.black13Medium,
                            ).avoidOverFlow(maxLine: 1),
                          ),
                          ReusableWidgets.emptyBox(height: 7.35.h),
                          RatingBar(
                            glow: false,
                            itemPadding: EdgeInsets.zero,
                            initialRating: 0,
                            wrapAlignment: WrapAlignment.center,
                            itemSize: 25,
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
                            onRatingUpdate: (val) {
                              value.ratingValue = val;
                              value.ratingReviews(val);
                            },
                          ),
                          ReusableWidgets.emptyBox(height: 7.35.h),
                          Padding(
                            padding: EdgeInsets.only(
                                left: context.isArabic ? 0 : 4.w),
                            child: Text(
                              value.reviewStatus ?? "",
                              style: value.reviewTextStyle,
                            ),
                          )
                        ]),
                  )
                ]),
          ),
        ],
      );
    });
  }
}
