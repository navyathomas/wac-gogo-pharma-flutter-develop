import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/generated/assets.dart';
import 'package:gogo_pharma/services/app_config.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:overlay_support/overlay_support.dart';

import '../../models/product_listing_model.dart';

class RatingIndicatorTile extends StatelessWidget {
  final Item? productItem;
  const RatingIndicatorTile({Key? key, this.productItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 4,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${productItem?.ratingAggregationValue}'
                            .cvtToAr(loc: context.myLocale),
                        style: FontStyle.black30Regular,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      SvgPicture.asset(
                        Assets.iconsStarBlack,
                        height: 17.r,
                        width: 17.r,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    '${productItem?.ratingData?.productReviewCount != null && productItem!.ratingData!.productReviewCount!.isNotEmpty ? (productItem?.ratingData?.productReviewCount ?? '').cvtToAr(loc: context.myLocale) : context.loc.zeroRatings} ${context.loc.and}\n${'${productItem?.productReviewCount ?? '0'}'.cvtToAr(loc: context.myLocale)} ${context.loc.reviews}',
                    textAlign: TextAlign.center,
                    style: FontStyle.grey13Medium_8A9CAC,
                  )
                ],
              ),
            )),
        Expanded(
            flex: 6,
            child: Container(
              decoration: BoxDecoration(
                  border: Border(left: BorderSide(color: HexColor('#DDE2E2')))),
              child: Column(
                children: List.generate(
                    productItem?.ratingSummaryData != null &&
                            productItem!.ratingSummaryData!.isNotEmpty
                        ? productItem!.ratingSummaryData!.length
                        : 5,
                    (index) => _ratingTile(
                        ratingSummary: productItem?.ratingSummaryData,
                        index: index,
                        totalCount: productItem?.productReviewCount ?? 1)),
              ),
            ))
      ],
    );
  }

  Widget _ratingTile(
      {List<RatingSummary>? ratingSummary, int index = 0, int totalCount = 1}) {
    RatingSummary? _ratingSummary =
        ratingSummary != null && ratingSummary.isNotEmpty
            ? ratingSummary[index]
            : null;
    return Padding(
      padding: EdgeInsets.only(
          bottom: index == (ratingSummary?.length ?? 1) - 1 ? 0 : 13.w),
      child: Row(
        children: [
          SizedBox(
            width: 27.w,
          ),
          SvgPicture.asset(
            Assets.iconsStar,
            height: 13.r,
            width: 13.r,
          ),
          SizedBox(
            width: 8.7.w,
          ),
          Text(
            '${_ratingSummary?.ratingValue ?? index + 1}',
            style: FontStyle.grey12Medium_556879,
          ),
          Expanded(
              child: Stack(
            children: [
              Container(
                height: 5.h,
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: BoxDecoration(
                    color: HexColor('#F5F5F6'),
                    borderRadius: BorderRadius.circular(2.r)),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: FractionallySizedBox(
                  widthFactor: getPercentValue(
                      _ratingSummary?.ratingCount ?? 0, totalCount),
                  child: Container(
                    height: 5.h,
                    decoration: BoxDecoration(
                        color: getIndicatorColor(index),
                        borderRadius: BorderRadius.circular(2.r)),
                  ),
                ),
              ),
            ],
          )),
          Text(
            resetRatingText('${_ratingSummary?.ratingCount ?? 0}'),
            style: FontStyle.grey12Regular_8A9CAC,
          )
        ],
      ),
    );
  }

  double getPercentValue(
    int count,
    int ratingAggregationValue,
  ) {
    double value = 0.0;
    int totalCount = ratingAggregationValue <= 0 ? 1 : ratingAggregationValue;
    value = (count / totalCount).toDouble();
    double _value = value <= 0.0
        ? 0.0
        : value > 1.0
            ? 1.0
            : value;
    return _value;
  }

  Color getIndicatorColor(int index) {
    Color _color = HexColor('#F5F5F6');
    switch (index) {
      case 0:
        _color = HexColor('#15958F');
        break;
      case 1:
        _color = HexColor('#15958F');
        break;
      case 2:
        _color = HexColor('#15958F');
        break;
      case 3:
        _color = HexColor('#FFC462');
        break;
      case 4:
        _color = HexColor('#F16665');
        break;
    }
    return _color;
  }

  String resetRatingText(String val) {
    String res = val.trim();
    switch (res.length) {
      case 1:
        res = '$res\t\t';
        break;
      case 2:
        res = '$res\t';
        break;
      case 3:
        res = res;
        break;
      default:
        res = '${res.substring(0, 1)}k\t';
    }
    return res;
  }

  Color getRatingIndicator(int value) {
    Color color = HexColor('#F5F5F6');
    return color;
  }
}

class RatingTile extends StatelessWidget {
  final ReviewsItem? reviewsItem;
  final bool disableBorder;
  const RatingTile(
      {Key? key, required this.reviewsItem, this.disableBorder = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
      decoration: BoxDecoration(
          color: Colors.white,
          border: disableBorder
              ? null
              : Border(top: BorderSide(color: HexColor('#E3E3E3')))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
                decoration: BoxDecoration(
                    border: Border.all(color: HexColor('#D9D9D9')),
                    borderRadius: BorderRadius.circular(13.r)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${reviewsItem?.ratingValue ?? 0}'
                          .cvtToAr(loc: AppData.appLocale),
                      style: FontStyle.grey12Regular_556879,
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    SvgPicture.asset(
                      Assets.iconsStarBlue,
                      height: 9.r,
                      width: 9.r,
                    )
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Text(
                    reviewsItem?.summary ?? '',
                    style: FontStyle.black13SemiBold_393939,
                  ).avoidOverFlow(),
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Text(
              reviewsItem?.text ?? '',
              style: FontStyle.grey13Regular_393939,
            ),
          ),
          Text(
            '${reviewsItem?.nickName ?? ''}. ${reviewsItem?.createdAt ?? ''}',
            style: FontStyle.grey12Light_556879,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            height: 5.h,
          )
        ],
      ),
    );
  }
}
