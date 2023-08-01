import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/models/route_arguments.dart';
import 'package:gogo_pharma/widgets/reusable_widgets.dart';
import '../../common/route_generator.dart';
import '../../models/home_model.dart';
import '../../widgets/common_image_view.dart';

class HomeWidgets {
  static HomeWidgets? _instance;
  static HomeWidgets get instance {
    _instance ??= HomeWidgets();
    return _instance!;
  }

  List<Widget> topCategory(BuildContext context, Content? content) {
    return content == null
        ? []
        : [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10.w, 25.h, 10.w, 15.h),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    content.title ?? '',
                    style: FontStyle.black15Bold,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index) {
                  ContentData? contentData = content.contentData?[index];
                  return GestureDetector(
                    onTap: () => Navigator.pushNamed(
                        context, RouteGenerator.routeCategoryDetails,
                        arguments: RouteArguments(
                            id: contentData?.linkId ?? '',
                            title: contentData?.name)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: CommonImageView(
                            image: contentData?.imageUrl ?? '',
                            height: double.maxFinite,
                            width: double.maxFinite,
                            boxFit: BoxFit.contain,
                            enableLoader: false,
                          ),
                        ),
                        Text(
                          contentData?.name ?? '',
                          style: FontStyle.black12Medium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  );
                }, childCount: content.contentData?.length ?? 0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 10.h,
                  childAspectRatio: context.sw() / ((context.sh() / 2.7)),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: ReusableWidgets.divider(),
            )
          ];
  }
}
