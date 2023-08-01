import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/font_style.dart';

import '../../common/route_generator.dart';
import '../../models/category_model.dart';
import '../../models/route_arguments.dart';
import '../../utils/color_palette.dart';
import '../../widgets/custom_expansion_tile.dart';

class SubCategoryExpansionTile extends StatelessWidget {
  SubCategoryExpansionTile({Key? key, this.subCategory}) : super(key: key);

  final SubCategory? subCategory;

  final ValueNotifier<bool> valueNotifier = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(
        dividerColor: HexColor('#f4f7f7'),
        unselectedWidgetColor: Colors.black.withOpacity(0.4));
    return ValueListenableBuilder<bool>(
        valueListenable: valueNotifier,
        builder: (context, value, _) => Theme(
              data: theme,
              child: CustomExpansionTile(
                collapsedBackgroundColor: HexColor('#f4f7f7'),
                backgroundColor: HexColor('#f4f7f7'),
                iconColor: Colors.black.withOpacity(0.4),
                onExpansionChanged: (bool val) {
                  valueNotifier.value = val;
                },
                title: Text(
                  subCategory?.name ?? '',
                  textAlign: TextAlign.start,
                  style: value
                      ? FontStyle.black14Medium
                      : FontStyle.black14Regular,
                ),
                children: subCategory?.subChildCategory != null
                    ? List<Widget>.generate(
                        subCategory!.subChildCategory!.length,
                        (_index) => _subCategoryTile(context,
                            index: _index,
                            id: subCategory!.subChildCategory?[_index].uid ??
                                '',
                            title: subCategory!.subChildCategory?[_index].name,
                            totalLength: subCategory!.subChildCategory!.length,
                            urlPath:
                                subCategory!.subChildCategory?[_index].urlPath))
                    : [],
              ),
            ));
  }
}

Widget _subCategoryTile(BuildContext context,
    {String? title,
    required int index,
    required String id,
    required int totalLength,
    String? urlPath}) {
  return InkWell(
    onTap: () => Navigator.pushNamed(
        context, RouteGenerator.routeProductListing,
        arguments: RouteArguments(id: id, title: title, param: urlPath)),
    child: Container(
      width: double.maxFinite,
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(0, index == 0 ? 24.h : 13.h, 0,
          (totalLength - 1) == index ? 24.h : 13.h),
      child: Row(
        children: [
          SizedBox(
            width: 38.w,
          ),
          Expanded(
            child: Text(
              title ?? '',
              style: FontStyle.black13Regular,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            width: 10.w,
          )
        ],
      ),
    ),
  );
}
