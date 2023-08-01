import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:gogo_pharma/widgets/shimmer_tile.dart';

class HomeLoader extends StatelessWidget {
  const HomeLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HexColor('#F4F7F7'),
      child: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
              color: Colors.white,
              child: ShimmerLoader(
                child: ShimmerTile(
                  height: 8.h,
                  borderRadius: 30.r,
                  margin: EdgeInsets.only(right: context.sw(size: 0.4)),
                ),
              ),
            ),
          ),
          SliverPadding(padding: EdgeInsets.only(top: 2.h)),
          SliverToBoxAdapter(
            child: ShimmerLoader(
              child: ShimmerTile(
                height: 149.h,
              ),
            ),
          ),
          SliverPadding(padding: EdgeInsets.only(top: 3.h)),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              height: 242.h,
              child: Column(
                children: [
                  SizedBox(
                    height: 28.h,
                  ),
                  ShimmerLoader(
                    child: ShimmerTile(
                      height: 12.h,
                      borderRadius: 30.r,
                      margin: EdgeInsets.symmetric(
                          horizontal: context.sw(size: 0.37)),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Expanded(
                      child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
                    child: LayoutBuilder(builder: (context, constraints) {
                      return GridView.builder(
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 6,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 25.w,
                                  mainAxisSpacing: 25.h,
                                  childAspectRatio: constraints.maxWidth /
                                      (constraints.maxHeight / 0.68)),
                          itemBuilder: (_, __) {
                            return SizedBox(
                              height: double.maxFinite,
                              width: double.maxFinite,
                              child: Column(
                                children: [
                                  const Expanded(
                                      child: ShimmerLoader(
                                          child: ShimmerTile(
                                    isCircle: true,
                                  ))),
                                  SizedBox(
                                    height: 12.h,
                                  ),
                                  ShimmerLoader(
                                      child: ShimmerTile(
                                    height: 10.h,
                                    margin: EdgeInsets.symmetric(
                                        horizontal:
                                            constraints.maxWidth * 0.06),
                                    borderRadius: 30.r,
                                  ))
                                ],
                              ),
                            );
                          });
                    }),
                  ))
                ],
              ),
            ),
          ),
          SliverPadding(padding: EdgeInsets.only(top: 5.h)),
          SliverToBoxAdapter(
            child: Container(
              height: 269.h,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(
                    height: 28.h,
                  ),
                  ShimmerLoader(
                      child: Row(
                    children: [
                      ShimmerTile(
                        height: 12.h,
                        width: context.sw(size: 0.3),
                        borderRadius: 30.r,
                      ),
                      const Spacer(),
                      ShimmerTile(
                        height: 12.h,
                        width: context.sw(size: 0.15),
                        borderRadius: 30.r,
                      ),
                    ],
                  )),
                  SizedBox(
                    height: 28.h,
                  ),
                  ShimmerLoader(
                      child: Row(
                    children: [
                      ShimmerTile(
                        height: 12.h,
                        width: context.sw(size: 0.3),
                        borderRadius: 30.r,
                      ),
                      SizedBox(
                        width: 14.w,
                      ),
                      ShimmerTile(
                        height: 12.h,
                        width: context.sw(size: 0.25),
                        borderRadius: 30.r,
                      ),
                    ],
                  )),
                  SizedBox(
                    height: 20.h,
                  ),
                  Expanded(
                    child: ShimmerLoader(
                      child: Row(
                        children: [
                          Expanded(
                            child: ShimmerTile(
                              borderRadius: 10.r,
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Expanded(
                            child: ShimmerTile(
                              borderRadius: 10.r,
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Expanded(
                            child: ShimmerTile(
                              borderRadius: 10.r,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 27.h,
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(padding: EdgeInsets.only(top: 5.h)),
          SliverToBoxAdapter(
            child: Container(
              height: 461.h,
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 28.h),
              child: Column(
                children: [
                  ShimmerLoader(
                      child: Row(
                    children: [
                      ShimmerTile(
                        height: 12.h,
                        width: context.sw(size: 0.3),
                        borderRadius: 30.r,
                      ),
                      const Spacer(),
                      ShimmerTile(
                        height: 12.h,
                        width: context.sw(size: 0.15),
                        borderRadius: 30.r,
                      ),
                    ],
                  )),
                  SizedBox(
                    height: 20.h,
                  ),
                  Expanded(
                      child: LayoutBuilder(builder: (context, constraints) {
                    return GridView.builder(
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 11.w,
                          mainAxisSpacing: 11.h,
                          childAspectRatio: constraints.maxWidth /
                              (constraints.maxHeight / 1)),
                      itemBuilder: (cxt, index) {
                        return ShimmerLoader(
                          child: ShimmerTile(
                            borderRadius: 8.r,
                          ),
                        );
                      },
                      itemCount: 4,
                    );
                  }))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
