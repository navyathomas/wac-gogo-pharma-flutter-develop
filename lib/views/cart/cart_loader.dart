import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/widgets/shimmer_tile.dart';

import '../../utils/color_palette.dart';
import '../../widgets/reusable_widgets.dart';

class CartLoader extends StatelessWidget {
  const CartLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 3.h),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (cxt, index) => Container(
                color: Colors.white,
                margin: EdgeInsets.only(bottom: 8.h),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 9.h),
                              child: Column(
                                children: [
                                  ShimmerLoader(
                                    child: ShimmerTile(
                                      height: 10.h,
                                      borderRadius: 12.r,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  ShimmerLoader(
                                    child: ShimmerTile(
                                      height: 10.h,
                                      borderRadius: 12.r,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            ShimmerLoader(
                              child: ShimmerTile(
                                height: 15.h,
                                width: context.sw(size: 0.2),
                                borderRadius: 12.r,
                              ),
                            ),
                            SizedBox(
                              height: 9.h,
                            ),
                            ShimmerLoader(
                              child: ShimmerTile(
                                height: 10.h,
                                width: context.sw(size: 0.5),
                                borderRadius: 12.r,
                              ),
                            ),
                            SizedBox(
                              height: 5.h,
                            )
                          ],
                        )),
                        SizedBox(
                          width: 28.w,
                        ),
                        ClipRRect(
                            borderRadius: BorderRadius.circular(11.r),
                            child: ShimmerLoader(
                              child: ShimmerTile(
                                height: 90.w,
                                width: 90.w,
                              ),
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    LayoutBuilder(builder: (context, constraints) {
                      double _width = constraints.maxWidth;
                      return Row(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
                                  children: [
                                    ShimmerLoader(
                                      child: ShimmerTile(
                                        height: 10.h,
                                        width: context.sw(size: 0.2),
                                        borderRadius: 12.r,
                                      ),
                                    ),
                                    ReusableWidgets.verticalDivider(
                                      color: HexColor('#D9E3E3'),
                                      margin: EdgeInsets.only(
                                          left: (_width * 0.04),
                                          right: (_width * 0.03)),
                                    ),
                                    ShimmerLoader(
                                      child: ShimmerTile(
                                        height: 10.h,
                                        width: context.sw(size: 0.2),
                                        borderRadius: 12.r,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: _width * 0.02,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ShimmerLoader(
                              child: ShimmerTile(
                                borderRadius: 8.r,
                                height: 34.h,
                                width: _width * 0.35,
                              ),
                            ),
                          )
                        ],
                      );
                    })
                  ],
                ),
              ),
          itemCount: 10),
    );
  }
}
