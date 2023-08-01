import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/widgets/reusable_widgets.dart';

import '../../utils/color_palette.dart';
import '../../widgets/common_error_widget.dart';
import '../../widgets/shimmer_tile.dart';


class OrderListShimmer extends StatelessWidget {
  ScrollController orderListShimmerScroll = ScrollController();

  OrderListShimmer({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemCount: 10,itemBuilder: (context, index) =>  Column(
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
                Padding(
                  padding: EdgeInsets.only(left: 130.w,top: 32.h),
                  child:    ShimmerLoader(
                    child: ShimmerTile(
                      height: 18.h,
                      width: 108.w,
                    ),
                  ),
                ),

                ReusableWidgets.emptyBox(height: 17.h),

              ],
            ),
          )
        ],
      ),
    );












    Container(color: Colors.white,
      child: CustomScrollView(controller: orderListShimmerScroll, slivers: [
        SliverList(
            delegate: SliverChildBuilderDelegate((context, mainIndex) {
              return Column(
                children: [
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(
                        top: 27.h, bottom: 15.h, right: 13.w, left: 13.w),
                    child: Row(
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

                          SizedBox(width: 15.w),
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [

                                  ReusableWidgets.emptyBox(height: 14.h),
                                  Padding(
                                      padding: EdgeInsets.only(right: 53.5.w),
                                      child: SizedBox()
                                  ),
                                  ReusableWidgets.emptyBox(height: 14.h),
                                  ShimmerTile(),
                                ]),
                          ),
                        ]),
                  ),
                  ReusableWidgets.verticalDivider(height: 8.h)
                ],
              );
            }, childCount:8)),

      ]),
    );
  }
}
