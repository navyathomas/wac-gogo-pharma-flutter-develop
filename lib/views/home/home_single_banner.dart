import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/nav_routes.dart';
import 'package:gogo_pharma/views/home/home_widgets.dart';
import 'package:gogo_pharma/widgets/common_image_view.dart';

import '../../generated/assets.dart';
import '../../models/home_model.dart';
import '../../widgets/reusable_widgets.dart';

class HomeSingleBanner extends StatelessWidget {
  const HomeSingleBanner({Key? key, this.contentData}) : super(key: key);

  final ContentData? contentData;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          GestureDetector(
            onTap: () => NavRoutes.navByType(context,
                type: contentData?.linkType ?? '',
                id: '${contentData?.id ?? ''}',
                title: contentData?.name ?? ''),
            child: Container(
              height: 149.h,
              width: double.maxFinite,
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 8.5.w, vertical: 7.h),
              child: CommonImageView(
                  image: contentData?.imageUrl ?? '',
                  height: double.maxFinite,
                  enableLoader: false,
                  width: double.maxFinite,
                  boxFit: BoxFit.fill),
            ),
          ),
          ReusableWidgets.divider(height: 8.h),
        ],
      ),
    );
  }
}
