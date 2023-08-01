import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/color_palette.dart';
import '../../widgets/reusable_widgets.dart';
import '../../widgets/shimmer_tile.dart';

class ReviewListShimmer extends StatelessWidget {
  const ReviewListShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ReusableWidgets.emptyBox(height: 8.h),
        Container(
          padding: EdgeInsets.only(top: 27.25.h, right: 54.w, left: 13.w),
          height: 156.h,
          color: HexColor("#FFFFFF"),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
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
                ),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ShimmerLoader(
                          child: ShimmerTile(
                            height: 18.h,
                            width: double.maxFinite,
                          ),
                        ),
                        ReusableWidgets.emptyBox(height: 6.h),
                        ShimmerLoader(
                          child: ShimmerTile(
                            height: 18.h,
                            width: double.maxFinite,
                          ),
                        ),
                        ReusableWidgets.emptyBox(height: 16.h),
                        ShimmerLoader(
                          child: ShimmerTile(
                            height: 18.h,
                            width: 90.w,
                          ),
                        ),
                      ]),
                )
              ]),
        )
      ],
    );
  }
}
