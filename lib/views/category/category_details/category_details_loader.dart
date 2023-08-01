import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:gogo_pharma/widgets/shimmer_tile.dart';
import 'package:shimmer/shimmer.dart';

class CategoryDetailLoader extends StatelessWidget {
  const CategoryDetailLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShimmerLoader(
      child: LayoutBuilder(builder: (cxt, constraint) {
        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 22.h),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 13.h,
                  crossAxisSpacing: 24.w,
                  childAspectRatio:
                      constraint.maxWidth / (constraint.maxHeight / 1.6),
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return SizedBox(
                      height: double.maxFinite,
                      width: double.maxFinite,
                      child: Column(
                        children: [
                          Expanded(
                            child: ShimmerTile(
                              borderRadius: 11.r,
                              padding: EdgeInsets.all(8.r),
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          ShimmerTile(
                            height: 10.h,
                            borderRadius: 11.r,
                            margin: EdgeInsets.symmetric(horizontal: 10.w),
                          )
                        ],
                      ),
                    );
                  },
                  childCount: 6,
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 9.w),
              sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 4.5.h),
                  height: 135.h,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(11.r),
                    child: const ShimmerTile(),
                  ),
                );
              }, childCount: 2)),
            ),
          ],
        );
      }),
    );
  }
}
