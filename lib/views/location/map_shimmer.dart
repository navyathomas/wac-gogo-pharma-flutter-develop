import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/generated/assets.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:gogo_pharma/widgets/common_button.dart';
import 'package:gogo_pharma/widgets/shimmer_tile.dart';
import 'package:shimmer/shimmer.dart';

class MapBottomShimmer extends StatelessWidget {
  const MapBottomShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShimmerLoader(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 22.h,
              margin: EdgeInsets.only(
                  left: 15.w, right: 15.w, bottom: 17.h, top: 35.h),
              child: Container(
                color: Colors.white,
                width: context.sw(size: 0.2),
                height: 22.h,
                margin: EdgeInsets.fromLTRB(15.w, 15.h, 15.w, 0),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.w, bottom: 25.h),
                  child: SvgPicture.asset(
                    Assets.iconsSearch,
                    height: 22.w,
                    width: 22.w,
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 22.h,
                    margin: EdgeInsets.only(left: 8.w, bottom: 25.h),
                    child: Container(
                      color: Colors.white,
                      width: context.sw(size: 0.5),
                      height: 22.h,
                      margin: EdgeInsets.fromLTRB(15.w, 15.h, 15.w, 0),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // context.read<LocationProvider>().showChangeLocation(false);
                  },
                  child: Container(
                    height: 22.h,
                    margin:
                        EdgeInsets.only(left: 8.w, bottom: 25.h, right: 20.w),
                    padding: const EdgeInsets.all(2),
                    child: Container(
                      color: Colors.white,
                      height: 22.h,
                      margin: EdgeInsets.fromLTRB(15.w, 15.h, 15.w, 0),
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.05,
                ),
                Expanded(
                  child: CommonButton(
                    width: MediaQuery.of(context).size.width,
                    buttonText: "",
                    onPressed: () {},
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.05,
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width * 0.08,
            ),
          ],
        ));
  }
}
