import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/widgets/shimmer_tile.dart';

import '../../utils/color_palette.dart';

class AllReviewLoader extends StatelessWidget {
  const AllReviewLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemBuilder: (cxt, index) {
          return Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
              color: Colors.white, child: ShimmerLoader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ShimmerTile(
                      height: 21.h,
                      width: context.sw(size: 0.1),
                      borderRadius: 13.r,
                    ),
                    SizedBox(width: 10.w,),
                    ShimmerTile(
                      height: 16.h,
                      width: context.sw(size: 0.3),
                      borderRadius: 13.r,
                    )
                  ],
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 12.h), child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  ShimmerTile(
                    height: 12.h,
                    width: context.sw(size: 0.9),
                    borderRadius: 13.r,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: ShimmerTile(
                      height: 12.h,
                      width: context.sw(size: 0.9),
                      borderRadius: 13.r,
                    ),
                  ),
                  ShimmerTile(
                    height: 12.h,
                    width: context.sw(size: 0.6),
                    borderRadius: 13.r,
                  ),
                ],),),
                Row(
                  children: [
                    ShimmerTile(
                      height: 12.h,
                      width: context.sw(size: 0.15),
                      borderRadius: 13.r,
                    ),
                    SizedBox(width: 10.w,),
                    ShimmerTile(
                      height: 12.h,
                      width: context.sw(size: 0.3),
                      borderRadius: 13.r,
                    )
                  ],
                ),
                SizedBox(height: 5.h,)
              ],
            ),
          ));
        },
        separatorBuilder: (_, __) => Container(
              height: 1.h,
              color: HexColor('#E3E3E3'),
            ),
        itemCount: 10);
  }
}
