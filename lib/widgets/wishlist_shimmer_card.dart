import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:gogo_pharma/widgets/reusable_widgets.dart';
import 'package:gogo_pharma/widgets/shimmer_tile.dart';
import 'package:shimmer/shimmer.dart';

class WishListCardShimmer extends StatefulWidget {
  const WishListCardShimmer({Key? key}) : super(key: key);

  @override
  State<WishListCardShimmer> createState() => _WishListCardShimmerState();
}

class _WishListCardShimmerState extends State<WishListCardShimmer> {
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReusableWidgets.emptyBox(
                  height: 5.h,
                ),
                //PRODUCT IMAGE

                Expanded(
                  child: ShimmerLoader(
                    child: ShimmerTile(
                      height: 128.h,
                      margin: EdgeInsets.symmetric(horizontal: 16.w),
                    ),
                  ),
                ),


                ReusableWidgets.emptyBox(
                  height: 9.85.h,
                ),

                //PRODUCT DETAILS
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ShimmerLoader(
                        child: ShimmerTile(
                          height: 16.h,
                          width: 148.h,
                        ),
                      ),
                      ReusableWidgets.emptyBox(
                        height: 1.9.h,
                      ),
                      ShimmerLoader(
                        child: ShimmerTile(
                          height: 14.h,
                          width: 40.h,
                        ),
                      ),
                      ReusableWidgets.emptyBox(
                        height: 10.16.h,
                      ),

                      ShimmerLoader(
                        child: ShimmerTile(
                          height: 14.h,
                          width: 41.h,
                        ),
                      ),
                      ReusableWidgets.emptyBox(
                        height: 8.56.h,
                      ),
                      ShimmerLoader(
                        child: ShimmerTile(
                          height: 16.h,
                          width: 67.h,
                        ),
                      ),
                      SizedBox(
                        height: 8.56.h,
                      ),
                      ShimmerLoader(
                          child: ShimmerTile(
                            height: 38.11.h,
                            width: context.sw(),
                          )),
                      SizedBox(
                        height: 11.h,
                      ),
                    ],
                  ),
                ),

                //PRODUCT DETAILS CLOSE
              ],
            )),
      ],
    );
  }
}
