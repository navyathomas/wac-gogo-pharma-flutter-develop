import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/color_palette.dart';
import '../../widgets/reusable_widgets.dart';
import '../../widgets/shimmer_tile.dart';

class ReviewPublishShimmer extends StatelessWidget {
  const ReviewPublishShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ReusableWidgets.emptyBox(height: 8.h),
        Container(
          padding: EdgeInsets.only(
            top: 27.h,
            left: 13.w,
            right: 13.w,
          ),

          color: HexColor("#FFFFFF"),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 12.w),
                      child: ShimmerLoader(
                        child: ShimmerTile(
                          height: 82.h,
                          borderRadius: 8.r,
                          width: 82.w,
                          margin: EdgeInsets.symmetric(horizontal: 16.w),
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
                              child:   ShimmerLoader(
                                child: ShimmerTile(
                                  height: 18.h,
                                  width: double.maxFinite,
                                ),
                              ),
                            ),
                            ReusableWidgets.emptyBox(height: 7.h),
                            Padding(
                              padding: EdgeInsets.only(left: 4.w),
                              child:    ShimmerLoader(
                                child: ShimmerTile(
                                  height: 18.h,
                                  width: 108.w,
                                ),
                              ),
                            ),
                            ReusableWidgets.emptyBox(height: 14.44.h),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                ShimmerLoader(
                                  child: ShimmerTile(
                                    height: 17.h,
                                    width: double.maxFinite,
                                  ),
                                ),
                                ReusableWidgets.emptyBox(width: 20.17.w),
                                ShimmerLoader(
                                  child: ShimmerTile(
                                    height: 13.h,
                                    width: double.maxFinite,
                                  ),
                                ),
                              ],
                            ),
                          ]),
                    )
                  ]),
              ReusableWidgets.emptyBox(height: 17.22.h),
              Padding(
                  padding: EdgeInsets.only(right: 24.w),
                  child:   ShimmerLoader(
                    child: ShimmerTile(
                      height: 18.h,
                      width: double.maxFinite,
                    ),
                  ),),
              ReusableWidgets.emptyBox(height: 12.78.h),
              Divider(color: HexColor("#D9E3E3"), thickness: 1, height: 1),
              SizedBox(
                height: 49.h,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ShimmerLoader(
                      child: ShimmerTile(
                        height: 16.h,
                        width: double.maxFinite,
                      ),
                    ),
                    ReusableWidgets.emptyBox(
                        height: 13.56.h,
                        width: 2.w,
                        childWidget: VerticalDivider(
                          color: HexColor("#D9E3E3"),
                          thickness: 1,
                        )),
                    ShimmerLoader(
                      child: ShimmerTile(
                        height: 16.h,
                        width: double.maxFinite,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
