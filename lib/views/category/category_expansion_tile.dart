import 'package:flutter/material.dart';
import 'package:gogo_pharma/views/category/category_tile.dart';
import 'package:gogo_pharma/views/category/sub_category_expansion_tile.dart';

import '../../models/category_model.dart';
import '../../utils/color_palette.dart';
import '../../widgets/custom_expansion_tile.dart';

class CategoryCustomExpansionTile extends StatelessWidget {
  CategoryCustomExpansionTile(
      {Key? key,
      required this.mainCategory,
      this.title,
      this.bgColor,
      this.image,
      this.index,
      required this.controller,
      required this.iconTurns})
      : super(key: key);

  final MainCategory mainCategory;
  final String? title;
  final String? image;
  final Color? bgColor;
  final AnimationController controller;
  final Animation<double> iconTurns;
  final int? index;
  final ValueNotifier<bool> valueNotifier = ValueNotifier(false);
  final ValueNotifier<int> indexNotifier = ValueNotifier(-1);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: valueNotifier,
        builder: (context, value, _) => ValueListenableBuilder<int>(
            valueListenable: indexNotifier,
            builder: (context, indexVal, _) {
              return CustomExpansionTile(
                headerChild: CategoryTile(
                  bgColor: bgColor ?? HexColor('#FFE0E0'),
                  title: title,
                  image: image,
                  enableAnimation: indexVal == (index ?? -1),
                  iconTurns: iconTurns,
                  subTitle: (mainCategory.subCategory != null &&
                          mainCategory.subCategory!.isNotEmpty)
                      ? mainCategory.subCategory!.map((e) => e.name).join(', ')
                      : '',
                  isExpanded: value,
                ),
                onHeaderTap: () {
                  if (mainCategory.subCategory != null &&
                      mainCategory.subCategory!.isNotEmpty) {
                    valueNotifier.value = !value;
                    indexNotifier.value = index ?? -1;
                    if (!value) {
                      controller.forward();
                    } else {
                      controller.reverse();
                    }
                  }
                },
                children: mainCategory.subCategory != null
                    ? List<Widget>.generate(
                        mainCategory.subCategory!.length,
                        (index) => SubCategoryExpansionTile(
                              subCategory: mainCategory.subCategory![index],
                            ))
                    : [],
              );
            }));
  }
}
