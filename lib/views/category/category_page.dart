import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/providers/category_provider.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:gogo_pharma/views/category/category_expansion_tile.dart';
import 'package:gogo_pharma/views/category/category_tile.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../models/category_model.dart';
import '../../widgets/common_error_widget.dart';
import '../../widgets/custom_expansion_tile.dart';
import '../../widgets/network_connectivity.dart';
import '../../widgets/reusable_widgets.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with SingleTickerProviderStateMixin {
  bool enable = false;
  late AnimationController _controller;
  late Animation<double> _iconTurns;
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: 0.5);

  @override
  void initState() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    _getData();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#f4f7f7'),
      body: NetworkConnectivity(
        onTap: () => _getData(),
        child: Consumer<CategoryProvider>(builder: (context, model, _) {
          if (model.loaderState == LoaderState.loading) {
            return ReusableWidgets.circularLoader();
          }
          List<CategoryList>? categoryList = model.categoryModel?.categoryList;
          if (categoryList == null ||
              categoryList.isEmpty ||
              categoryList.first.mainCategory == null) {
            return CommonErrorWidget(
              types: ErrorTypes.noDataFound,
              buttonText: context.loc.refresh,
              onTap: _getData,
            );
          }
          return ListView.separated(
              itemBuilder: (cxt, index) {
                return CategoryCustomExpansionTile(
                  mainCategory: categoryList.first.mainCategory![index],
                  title: categoryList.first.mainCategory![index].name,
                  image: categoryList.first.mainCategory![index].image,
                  iconTurns: _iconTurns,
                  controller: _controller,
                  index: index,
                  bgColor: HexColor(
                      categoryList.first.mainCategory![index].colorCode ??
                          '#FFE0E0'),
                );
              },
              separatorBuilder: (_, __) => Container(
                    height: 2.h,
                    color: Colors.white,
                  ),
              itemCount: categoryList.first.mainCategory?.length ?? 0);
        }),
      ),
    );
  }

  Future<void> _getData() async {
    Future.microtask(() => context.read<CategoryProvider>()
      ..categoryDetailInit()
      ..getCategoryList());
  }
}
