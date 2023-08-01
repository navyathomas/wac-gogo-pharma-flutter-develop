import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/common/nav_routes.dart';
import 'package:gogo_pharma/common/route_generator.dart';
import 'package:gogo_pharma/models/route_arguments.dart';
import 'package:gogo_pharma/models/select_category_model.dart';
import 'package:gogo_pharma/providers/category_provider.dart';
import 'package:gogo_pharma/providers/product_provider.dart';
import 'package:gogo_pharma/views/category/category_details/category_details_loader.dart';
import 'package:gogo_pharma/widgets/common_app_bar.dart';
import 'package:gogo_pharma/widgets/common_image_view.dart';
import 'package:provider/provider.dart';

import '../../../common/constants.dart';
import '../../../generated/assets.dart';
import '../../../models/category_details_model.dart';
import '../../../widgets/common_error_widget.dart';
import '../../../widgets/network_connectivity.dart';
import '../../../widgets/reusable_widgets.dart';

class CategoryDetails extends StatefulWidget {
  final String id;
  final String? title;
  const CategoryDetails({Key? key, required this.id, this.title})
      : super(key: key);

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  @override
  void initState() {
    _getData();
    super.initState();
  }

  Widget _bannerListWidget(GetSelectCategoryPage? getSelectCategoryPage) {
    return getSelectCategoryPage?.content != null &&
            getSelectCategoryPage!.content!.isNotEmpty
        ? SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
            if (getSelectCategoryPage.content?[index] == null) {
              return const SizedBox();
            }
            return InkWell(
              onTap: () => NavRoutes.navByType(context,
                  type: getSelectCategoryPage.content?[index].linkType ?? '',
                  id: getSelectCategoryPage.content?[index].linkId ?? ''),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 9.w),
                height: 135.h,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(11.r),
                  child: CommonImageView(
                    height: double.maxFinite,
                    width: double.maxFinite,
                    image: getSelectCategoryPage.content?[index].imageUrl ?? '',
                  ),
                ),
              ),
            );
          }, childCount: getSelectCategoryPage.content?.length ?? 0))
        : const SliverToBoxAdapter(
            child: SizedBox(),
          );
  }

  Widget _categoryGrid(
      List<GetShopByCategory>? getShopByCategory, BoxConstraints constraints) {
    return getShopByCategory != null && getShopByCategory.isNotEmpty
        ? SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 22.h),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 13.h,
                crossAxisSpacing: 24.w,
                childAspectRatio:
                    constraints.maxWidth / (constraints.maxHeight / 1.5),
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  GetShopByCategory? _data = getShopByCategory[index];
                  return GestureDetector(
                    onTap: () {
                      Future.microtask(() {
                        context.read<ProductProvider>().clearAll(context);
                      });
                      Navigator.pushNamed(
                          context, RouteGenerator.routeProductListing,
                          arguments: RouteArguments(
                              id: _data.categoryId, title: _data.name ?? ''));
                    },
                    child: SizedBox(
                      height: double.maxFinite,
                      width: double.maxFinite,
                      child: Column(
                        children: [
                          Expanded(
                              child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.r),
                                child: CommonImageView(
                                  image: _data.imageUrl ?? '',
                                  boxFit: BoxFit.contain,
                                  width: double.maxFinite,
                                  enableLoader: false,
                                  height: double.maxFinite,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(11.r),
                                  color: Colors.black.withOpacity(0.04),
                                ),
                              )
                            ],
                          )),
                          /*Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(11.r),
                                color: Colors.black.withOpacity(0.04),
                              ),
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(8.r),
                              child: CommonImageView(
                                image: _data.imageUrl ?? '',
                                boxFit: BoxFit.contain,
                                width: double.maxFinite,
                                enableLoader: false,
                                height: double.maxFinite,
                              ),
                            ),
                          ),*/
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            (_data.name ?? '') + '\n',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: FontStyle.black12Medium,
                          )
                        ],
                      ),
                    ),
                  );
                },
                childCount: getShopByCategory.length,
              ),
            ),
          )
        : const SliverToBoxAdapter(child: SizedBox());
  }

  Widget mainWidget(CategoryProvider model) {
    return LayoutBuilder(builder: (cxt, constraint) {
      return CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _categoryGrid(
              model.categoryDetailsModel?.getShopByCategory, constraint),
          _bannerListWidget(model.selectCategoryModel?.getSelectCategoryPage),
          SliverPadding(padding: EdgeInsets.only(top: 30.h))
        ],
      );
    });
  }

  Widget switcherWidget(CategoryProvider model) {
    Widget _child = const SizedBox();
    switch (model.loaderState) {
      case LoaderState.loading:
        _child = model.categoryDetailsModel?.getShopByCategory == null ||
                model.selectCategoryModel?.getSelectCategoryPage == null
            ? const CategoryDetailLoader()
            : mainWidget(model);
        break;
      case LoaderState.loaded:
        _child = mainWidget(model);
        break;
      case LoaderState.error:
        _child = CommonErrorWidget(
          types: ErrorTypes.serverError,
          buttonText: context.loc.refresh,
          onTap: () {
            _getData();
          },
        );
        break;
      case LoaderState.networkErr:
        _child = const CommonErrorWidget(
          types: ErrorTypes.networkErr,
        );
        break;

      default:
        _child = const SizedBox();
    }
    return _child;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        pageTitle: widget.title ?? '',
        buildContext: context,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<CategoryProvider>(builder: (context, model, _) {
          return NetworkConnectivity(
            onTap: () => _getData(),
            inAsyncCall: model.loaderState == LoaderState.loading &&
                (model.categoryDetailsModel?.getShopByCategory != null &&
                    model.selectCategoryModel?.getSelectCategoryPage != null),
            child: switcherWidget(model),
          );
        }),
      ),
    );
  }

  Future<void> _getData() async {
    Future.microtask(() {
      context.read<CategoryProvider>()
        ..categoryDetailInit()
        ..getCategoryById(widget.id);
    });
  }
}
