import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:shimmer/shimmer.dart';

class ProductCardShimmer extends StatefulWidget {
  const ProductCardShimmer({Key? key}) : super(key: key);

  @override
  State<ProductCardShimmer> createState() => _ProductCardShimmerState();
}

class _ProductCardShimmerState extends State<ProductCardShimmer> {
  @override
  Widget build(BuildContext context) {
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
                //FAVOURATE ICON

                Shimmer.fromColors(
                    baseColor: ColorPalette.shimmerBaseColor,
                    highlightColor: ColorPalette.shimmerHighlightColor,
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: context.isArabic ? 0.0 : 13.w,
                          left: context.isArabic ? 13.w : 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 14.h,
                            width: 17.h,
                            child: Icon(
                              Icons.favorite,
                              color: ColorPalette.shimmerBaseColor,
                            ),
                          ),
                        ],
                      ),
                    )),

                //FAVOURATE ICON CLOSE

                SizedBox(
                  height: 9.27.h,
                ),

                //PRODUCT IMAGE

                Shimmer.fromColors(
                  baseColor: ColorPalette.shimmerBaseColor,
                  highlightColor: ColorPalette.shimmerHighlightColor,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 26.w),
                    child: Container(
                      height: 128.h,
                      width: 128.w,
                      color: Colors.white,
                    ),
                  ),
                ),

                //PRODUCT IMAGE CLOSE

                SizedBox(
                  height: 11.85.h,
                ),

                //PRODUCT DETAILS
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Shimmer.fromColors(
                        baseColor: ColorPalette.shimmerBaseColor,
                        highlightColor: ColorPalette.shimmerHighlightColor,
                        child: Container(
                          color: Colors.white,
                          height: 16.h,
                          width: 148.h,
                        ),
                      ),
                      SizedBox(
                        height: 1.9.h,
                      ),
                      Shimmer.fromColors(
                        baseColor: ColorPalette.shimmerBaseColor,
                        highlightColor: ColorPalette.shimmerHighlightColor,
                        child: Container(
                          color: Colors.white,
                          height: 14.h,
                          width: 40.h,
                        ),
                      ),
                      SizedBox(
                        height: 3.71.h,
                      ),
                      Row(
                        children: [
                          Shimmer.fromColors(
                            baseColor: ColorPalette.shimmerBaseColor,
                            highlightColor: ColorPalette.shimmerHighlightColor,
                            child: Container(
                              color: Colors.white,
                              height: 14.h,
                              width: 14.h,
                            ),
                          ),
                          SizedBox(
                            width: 3.32.w,
                          ),
                          Shimmer.fromColors(
                            baseColor: ColorPalette.shimmerBaseColor,
                            highlightColor: ColorPalette.shimmerHighlightColor,
                            child: Container(
                              color: Colors.white,
                              height: 14.h,
                              width: 14.h,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8.13.h,
                      ),
                      Row(
                        children: [
                          Shimmer.fromColors(
                            baseColor: ColorPalette.shimmerBaseColor,
                            highlightColor: ColorPalette.shimmerHighlightColor,
                            child: Container(
                              color: Colors.white,
                              height: 14.h,
                              width: 54.h,
                            ),
                          ),
                          SizedBox(
                            width: 3.5.w,
                          ),
                          Shimmer.fromColors(
                            baseColor: ColorPalette.shimmerBaseColor,
                            highlightColor: ColorPalette.shimmerHighlightColor,
                            child: Container(
                              color: Colors.white,
                              height: 14.h,
                              width: 41.h,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 3.63.h,
                      ),
                      Shimmer.fromColors(
                        baseColor: ColorPalette.shimmerBaseColor,
                        highlightColor: ColorPalette.shimmerHighlightColor,
                        child: Container(
                          color: Colors.white,
                          height: 16.h,
                          width: 67.h,
                        ),
                      ),
                      SizedBox(
                        height: 16.56.h,
                      ),
                      Shimmer.fromColors(
                          baseColor: ColorPalette.shimmerBaseColor,
                          highlightColor: ColorPalette.shimmerHighlightColor,
                          child: Container(
                            height: 35.h,
                            width: context.sw(),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15.22.h,
                )
                //PRODUCT DETAILS CLOSE
              ],
            )),
      ],
    );
  }
}
