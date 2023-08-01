import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/common/nav_routes.dart';
import 'package:gogo_pharma/common/route_generator.dart';
import 'package:gogo_pharma/models/route_arguments.dart';
import 'package:gogo_pharma/views/home/home_widgets.dart';
import 'package:gogo_pharma/widgets/common_image_view.dart';

import '../../generated/assets.dart';
import '../../models/home_model.dart';
import '../../widgets/reusable_widgets.dart';

class HomeGridTile extends StatelessWidget {
  const HomeGridTile({Key? key, this.content}) : super(key: key);

  final Content? content;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: content?.contentData != null && content!.contentData!.isNotEmpty
          ? Column(
              children: [
                SizedBox(
                  height: 458.h,
                  width: double.maxFinite,
                  child: Stack(
                    children: [
                      CommonImageView(
                        image: content?.backgroundImage ?? '',
                        height: 458.h,
                        width: double.maxFinite,
                        boxFit: BoxFit.cover,
                        enableLoader: false,
                      ),
                      Container(
                        height: 458.h,
                        width: double.maxFinite,
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: Column(
                          children: [
                            ReusableWidgets.headTileRow(context,
                                title: content?.title ?? '',
                                trailingText: context.loc.shopAll,
                                onTap: () => Navigator.pushNamed(
                                    context, RouteGenerator.routeProductListing,
                                    arguments: RouteArguments(
                                        title: content?.title ?? '',
                                        id: content?.linkId))),
                            SizedBox(
                              height: 10.h,
                            ),
                            Expanded(
                                child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 3.5.w),
                              child: LayoutBuilder(
                                  builder: (context, constraints) {
                                return GridView.builder(
                                  padding: EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 5.w,
                                          mainAxisSpacing: 5.h,
                                          childAspectRatio:
                                              constraints.maxWidth /
                                                  (constraints.maxHeight / 1)),
                                  itemBuilder: (cxt, index) {
                                    ContentData? _data =
                                        content?.contentData?[index];
                                    if (_data == null) return const SizedBox();
                                    return GestureDetector(
                                      onTap: () => NavRoutes.navByType(context,
                                          title: _data.name ?? '',
                                          type: _data.linkType ?? '',
                                          id: _data.linkId ?? ''),
                                      child: Container(
                                        margin: EdgeInsets.all(5.r),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                              color: Colors.transparent),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.transparent,
                                              offset: Offset(0, 2),
                                              blurRadius: 2,
                                              spreadRadius: 1,
                                            )
                                          ],
                                        ),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: CommonImageView(
                                              image: _data.imageUrl ?? '',
                                              height: double.maxFinite,
                                              width: double.maxFinite,
                                              boxFit: BoxFit.fill,
                                            )),
                                      ),
                                    );
                                  },
                                  itemCount: content?.contentData?.length ?? 0,
                                );
                              }),
                            ))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                ReusableWidgets.divider(height: 8.h),
              ],
            )
          : const SizedBox(),
    );
  }
}
