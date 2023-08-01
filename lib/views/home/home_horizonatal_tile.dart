import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:gogo_pharma/views/home/home_widgets.dart';

import '../../generated/assets.dart';
import '../../widgets/reusable_widgets.dart';

class HomeHorizontalTile extends StatelessWidget {
  const HomeHorizontalTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          SizedBox(
            height: 267.h,
            width: double.maxFinite,
            child: Stack(
              children: [
                Image.asset(
                  Assets.tempBg2,
                  height: 267.h,
                  width: double.maxFinite,
                  fit: BoxFit.cover,
                ),
                Container(
                  height: 267.h,
                  width: double.maxFinite,
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: Column(
                    children: [
                      ReusableWidgets.headTileRow(context, title: 'Super Deals'),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.5.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Flash Sale Ends In',
                              style: FontStyle.grey_345457_13Regular,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              width: 9.w,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: HexColor('#FF6262'),
                                  borderRadius: BorderRadius.circular(4.r)),
                              padding: EdgeInsets.symmetric(
                                  vertical: 2.h, horizontal: 6.w),
                              child: Text(
                                '05h : 01m : 40s',
                                style: FontStyle.white13Regular,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.5.w),
                        child: LayoutBuilder(builder: (context, constraints) {
                          return GridView.builder(
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 10.w,
                                    mainAxisSpacing: 10.h,
                                    mainAxisExtent: constraints.maxHeight),
                            itemBuilder: (cxt, index) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      Assets.tempGrid2,
                                      fit: BoxFit.fill,
                                    )),
                              );
                            },
                            itemCount: 3,
                          );
                        }),
                      )),
                      SizedBox(
                        height: 5.h,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          ReusableWidgets.divider(height: 8.h),
        ],
      ),
    );
  }
}
