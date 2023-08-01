import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:gogo_pharma/views/home/home_widgets.dart';
import 'package:gogo_pharma/widgets/shimmer_tile.dart';

import '../../widgets/reusable_widgets.dart';

class SearchLoader extends StatelessWidget {
  const SearchLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.separated(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (_, __) => ShimmerLoader(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      ShimmerTile(
                        height: 41.h,
                        width: 27.w,
                      ),
                      SizedBox(
                        width: 11.w,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerTile(
                              height: 17.h,
                              width: context.sw(size: 0.4),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            ShimmerTile(
                              height: 12.h,
                              width: context.sw(size: 0.25),
                            ),
                          ],
                        ),
                      ),
                      ShimmerTile(
                        height: 12.5.h,
                        width: 12.w,
                      ),
                      SizedBox(
                        width: 8.w,
                      )
                    ],
                  ),
                ),
              ),
          separatorBuilder: (_, __) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.5.w),
                child: ReusableWidgets.divider(
                  height: 1.0,
                  color: HexColor('#EAF2F2'),
                ),
              ),
          itemCount: 5),
    );
  }
}
