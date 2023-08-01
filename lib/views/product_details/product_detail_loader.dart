import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/extensions.dart';

import '../../utils/color_palette.dart';
import '../../utils/dashed_line_painter.dart';
import '../../widgets/reusable_widgets.dart';
import '../../widgets/shimmer_tile.dart';

class ProductDetailLoader extends StatelessWidget {
  const ProductDetailLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  const SizedBox(
                    height: 361,
                    width: double.maxFinite,
                  ),
                  Positioned(
                      top: 22.h,
                      right: 5.w,
                      child: Column(
                        children: [
                          ShimmerLoader(
                              child: ShimmerTile(
                            height: 45.r,
                            width: 45.r,
                            isCircle: true,
                          )),
                          SizedBox(
                            height: 10.h,
                          ),
                          ShimmerLoader(
                              child: ShimmerTile(
                            height: 45.r,
                            width: 45.r,
                            isCircle: true,
                          )),
                        ],
                      ))
                ],
              ),
              ShimmerLoader(
                  child: ShimmerTile(
                height: 21.h,
                width: context.sw(size: 0.8),
                borderRadius: 30.r,
              )),
              SizedBox(
                height: 8.h,
              ),
              ShimmerLoader(
                  child: ShimmerTile(
                height: 16.h,
                width: context.sw(size: 0.4),
                borderRadius: 30.r,
              )),
              SizedBox(
                height: 8.h,
              ),
              ShimmerLoader(
                  child: ShimmerTile(
                height: 23.h,
                width: context.sw(size: 0.65),
                borderRadius: 30.r,
              )),
              SizedBox(
                height: 8.h,
              ),
              ShimmerLoader(
                  child: ShimmerTile(
                height: 16.h,
                width: context.sw(size: 0.2),
                borderRadius: 30.r,
              )),
              SizedBox(
                height: 10.h,
              ),
              Row(
                children: [
                  ShimmerLoader(
                      child: ShimmerTile(
                    height: 15.h,
                    width: 15.h,
                  )),
                  SizedBox(
                    width: 10.w,
                  ),
                  ShimmerLoader(
                      child: ShimmerTile(
                    height: 15.h,
                    width: context.sw(size: 0.5),
                    borderRadius: 30.r,
                  )),
                ],
              ),
              SizedBox(
                height: 19.h,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 8.h,
        ),
        const ProductLoaderBottom(),
      ],
    );
  }
}

class ProductLoaderBottom extends StatelessWidget {
  const ProductLoaderBottom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 8.h,
        ),
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 19.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerLoader(
                  child: ShimmerTile(
                    height: 20.h,
                    width: context.sw(size: 0.4),
                    borderRadius: 30.r,
                  )),
              SizedBox(
                height: 15.h,
              ),
              DottedBorder(
                dashPattern: [3.w, 3.w],
                padding: EdgeInsets.symmetric(
                  horizontal: 13.w,
                  vertical: 9.h,
                ),
                color: ColorPalette.shimmerHighlightColor,
                radius: Radius.circular(12.r),
                borderType: BorderType.RRect,
                child: SizedBox(
                    width: double.maxFinite,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerLoader(
                            child: ShimmerTile(
                              height: 10.h,
                              width: double.maxFinite,
                              borderRadius: 30.r,
                              margin: EdgeInsets.only(bottom: 5.h),
                            )),
                        ShimmerLoader(
                            child: ShimmerTile(
                              height: 10.h,
                              width: context.sw(size: 0.5),
                              borderRadius: 30.r,
                            )),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: CustomPaint(
                            size: const Size.fromHeight(1),
                            painter: DashedLinePainter(
                                dashColor:
                                ColorPalette.shimmerHighlightColor),
                          ),
                        ),
                        ShimmerLoader(
                            child: ShimmerTile(
                              height: 10.h,
                              width: double.maxFinite,
                              borderRadius: 30.r,
                              margin: EdgeInsets.only(bottom: 5.h),
                            )),
                        ShimmerLoader(
                            child: ShimmerTile(
                              height: 10.h,
                              width: context.sw(size: 0.5),
                              borderRadius: 30.r,
                            )),
                      ],
                    )),
              ),
              SizedBox(
                height: 19.h,
              ),
              Row(
                children: [
                  ShimmerLoader(
                      child: ShimmerTile(
                        height: 25.r,
                        width: 25.r,
                        isCircle: true,
                      )),
                  SizedBox(
                    width: 10.w,
                  ),
                  ShimmerLoader(
                      child: ShimmerTile(
                        height: 25.r,
                        width: context.sw(size: 0.3),
                        borderRadius: 30.r,
                      )),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 8.h,
        ),
        ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, __) {
              return Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(
                      vertical: 14.5.h, horizontal: 17.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShimmerLoader(
                          child: ShimmerTile(
                            height: 18.r,
                            width: context.sw(size: 0.6),
                            borderRadius: 30.r,
                          )),
                      ShimmerLoader(
                          child: ShimmerTile(
                            height: 15.r,
                            width: 15.r,
                            borderRadius: 30.r,
                          )),
                    ],
                  ));
            },
            separatorBuilder: (_, __) => ReusableWidgets.divider(height: 1.0),
            itemCount: 3)
      ],
    );
  }
}

