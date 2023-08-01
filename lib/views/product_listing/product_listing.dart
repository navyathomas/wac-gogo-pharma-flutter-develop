import 'dart:developer';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/common/route_generator.dart';
import 'package:gogo_pharma/generated/assets.dart';
import 'package:gogo_pharma/models/product_listing_model.dart';
import 'package:gogo_pharma/providers/product_provider.dart';
import 'package:gogo_pharma/services/helpers.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:gogo_pharma/widgets/common_app_bar.dart';
import 'package:gogo_pharma/widgets/common_error_widget.dart';
import 'package:gogo_pharma/widgets/common_listTile_radioRightside.dart';
import 'package:gogo_pharma/widgets/common_product_card.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gogo_pharma/widgets/common_product_card_shimmer.dart';
import 'package:gogo_pharma/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../../models/route_arguments.dart';

class ProductListing extends StatefulWidget {
  final List<String>? categoryID;
  final Map<String, dynamic>? filter;
  final Map<dynamic, dynamic>? sort;
  final String appbarTitle;
  final String? urlPath;

  const ProductListing(
      {Key? key,
      this.categoryID,
      this.appbarTitle = "",
      this.filter,
      this.sort,
      this.urlPath})
      : super(key: key);

  @override
  State<ProductListing> createState() => _ProductListingState();
}

class _ProductListingState extends State<ProductListing> {
  // final ValueNotifier<int> pageNo = ValueNotifier<int>(1);
  ScrollController scrollController = ScrollController();
  int? totalLength;
  @override
  void initState() {
    final products = Provider.of<ProductProvider>(context, listen: false);
    _scrollListen(products);

    Future.microtask(() {
      products.storePreviousFilterData();
      context.read<ProductProvider>().clearFilter(); //test
      if (context.read<ProductProvider>().productFilter == null) {
        products.getProductFilters(context);
      } else {
        context.read<ProductProvider>().refresh();
      }
      products.initProductList();

      products.getProductList(
          products.pageNumberCount,
          products.categoryIDs.isEmpty
              ? widget.categoryID!
              : products.categoryIDs,
          widget.filter,
          widget.sort,
      name: widget.appbarTitle,
      urlPath: widget.urlPath);
      products.saveDefaultCategoryID(widget.categoryID!);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    totalLength;
    double textScale =
        Helpers.validateScale(MediaQuery.of(context).textScaleFactor) - 1;
    return Container(
      color: ColorPalette.bgColor,
      child: SafeArea(
        top: false,
        child: Scaffold(
            backgroundColor: ColorPalette.bgColor,
            appBar: CommonAppBar(
              pageTitle: widget.appbarTitle,
              enableNavBAck: true,
              buildContext: context,
            ),
            body: Consumer<ProductProvider>(builder: ((context, value, child) {
              if (value.productList != null) {
               
                totalLength = value.productList!.products!.totalCount;
              }
              return value.isListEmpty
                  ? const Center(
                      child: CommonErrorWidget(
                      types: ErrorTypes.noDataFound,
                    ))
                  : value.loaderState == LoaderState.error
                      ? const Center(
                          child: CommonErrorWidget(
                            types: ErrorTypes.serverError,
                          ),
                        )
                      : value.loaderState == LoaderState.networkErr
                          ? const Center(
                              child: CommonErrorWidget(
                                types: ErrorTypes.networkErr,
                              ),
                            )
                          : Column(
                              children: [
                                Expanded(
                                    child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.w),
                                  child: value.loaderState ==
                                              LoaderState.loading &&
                                          value.firstLoad == true
                                      ? AlignedGridView.count(
                                          itemCount: 4,
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 5.h,
                                          crossAxisSpacing: 5.h,
                                          itemBuilder: (context, index) {
                                            return const ProductCardShimmer();
                                          },
                                        )
                                      : CustomScrollView(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          controller: scrollController,
                                          slivers: [
                                            SliverPadding(
                                                padding:
                                                    EdgeInsets.only(top: 5.h)),
                                            SliverGrid(
                                              delegate:
                                                  SliverChildBuilderDelegate(
                                                (context, index) {
                                                  Item? item =
                                                      value.items?[index];
                                                  MaximumPrice? maximumPrice =
                                                      item?.priceRange
                                                          ?.maximumPrice;
                                                  if (item == null ||
                                                      maximumPrice == null) {
                                                    return const SizedBox();
                                                  }
                                                  return InkWell(
                                                    onTap: () {
                                                      Navigator.pushNamed(
                                                          context,
                                                          RouteGenerator
                                                              .routeProductDetails,
                                                          arguments:
                                                              RouteArguments(
                                                                  sku: item.sku,
                                                                  item: item));
                                                    },
                                                    child: ProductCard(
                                                      navFromState: NavFromState
                                                          .navFromProductList,
                                                      stockStatus:
                                                          item.stockStatus,
                                                      currency: maximumPrice
                                                          .finalPrice!
                                                          .currency!,
                                                      sku: item.sku ?? '',
                                                      productImage: item
                                                              .smallImage
                                                              ?.appImageUrl ??
                                                          '',
                                                      productName:
                                                          item.name ?? '',
                                                      quantityAndUnit:
                                                          item.weight ??
                                                              item.volumn ??
                                                              '',
                                                      rating: item.ratingData!
                                                                  .ratingAggregationValue
                                                                  .toString() ==
                                                              "0"
                                                          ? ""
                                                          : item.ratingData!
                                                              .ratingAggregationValue
                                                              .toString(),
                                                      actualPrice: maximumPrice
                                                                  .discount!
                                                                  .amountOff
                                                                  .toString() ==
                                                              "0"
                                                          ? ""
                                                          : maximumPrice
                                                              .regularPrice!
                                                              .value
                                                              .toString(),
                                                      offerPercentage: maximumPrice
                                                                  .discount!
                                                                  .percentOff
                                                                  .toString() ==
                                                              "0"
                                                          ? ""
                                                          : maximumPrice
                                                              .discount!
                                                              .percentOff
                                                              .toString(),
                                                      offerPrice: maximumPrice
                                                                  .finalPrice!
                                                                  .value
                                                                  .toString() ==
                                                              "0"
                                                          ? ""
                                                          : maximumPrice
                                                              .finalPrice!.value
                                                              .toString(),
                                                      offerTag: false,
                                                      // productName: "OstroVit Omega 3 500..",
                                                      // quantityAndUnit: "500 gm",
                                                      // quantityAndUnit: "كمية",
                                                      // rating: "3.9",
                                                      // actualPrice: "3.9",
                                                      // offerPercentage: "70%",
                                                      // offerPrice: "47.00",
                                                      // offerTag: true,
                                                    ),
                                                  );
                                                },
                                                childCount: value.items!.length,
                                              ),
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisSpacing: 5.w,
                                                      mainAxisExtent: 330.h +
                                                          (textScale * 150),
                                                      mainAxisSpacing: 5.h,
                                                      crossAxisCount: 2),
                                            ),
                                            SliverToBoxAdapter(
                                              child: ReusableWidgets
                                                  .paginationLoader(
                                                      value.loading),
                                            ),
                                            SliverPadding(
                                                padding: EdgeInsets.only(
                                                    top: 5.h, bottom: 5.h)),
                                          ],
                                        ),
                                ))
                              ],
                            );
            })),
            bottomNavigationBar: bottomNavBar(
              context,
            )),
      ),
    );
  }

  _scrollListen(ProductProvider value) {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          (scrollController.position.maxScrollExtent / 2)) {
        if (value.productList!.products!.pageInfo!.totalPages! > value.pageNumberCount) {
          log("Pagination started");
          loadMore(context, value);
        }
      }
    });
  }

  loadMore(BuildContext context, ProductProvider value) async {
    if ((value.items!.length) < totalLength!) {
      // pageNo.value = pageNo.value + 1;
      value.pageNumberCount=value.pageNumberCount+1;
      log("Now Page Number is : ${value.pageNumberCount+1}");
      await context.read<ProductProvider>().getProductList(
          value.pageNumberCount,
          context.read<ProductProvider>().categoryIDs.isEmpty
              ? // warning !!!
              widget.categoryID!
              : context.read<ProductProvider>().categoryIDs, // warning !!!
          widget.filter,
          // widget.sort
        context.read<ProductProvider>().sort
        // widget.sort  -> it is replaced buy provider sort value on 27 sep 2022
        );
      log("scrolled automaticly ....");
    }
  }
}

Widget bottomNavBar(BuildContext context) {
  return Consumer<ProductProvider>(builder: ((_, providerValue, child) {
    return providerValue.aggregations!.isEmpty &&
            providerValue.sortFieldOptions!.isEmpty
        ? const SizedBox()
        : Container(
            width: context.sw(),
            height: 49.h,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    top: BorderSide(
                  color: ColorPalette.bgColor,
                ))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                providerValue.aggregations!.isEmpty
                    ? Flexible(
                        flex: 1,
                        child: Opacity(
                          opacity: 0.3,
                          child: SizedBox(
                            height: 49.h,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(Assets.iconsFilterIcon),
                                SizedBox(
                                  width: 12.w,
                                ),
                                Text(
                                  context.loc.filterTxt,
                                  style: FontStyle.black13Regular,
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    : Flexible(
                        flex: 1,
                        child: InkWell(
                          onTap: () async {
                            log("filter");
                            Navigator.pushNamed(
                                context, RouteGenerator.routeProductFilter);
                          },
                          child: SizedBox(
                            height: 49.h,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(Assets.iconsFilterIcon),
                                SizedBox(
                                  width: 12.w,
                                ),
                                Text(
                                  context.loc.filterTxt,
                                  style: FontStyle.black13Regular,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                Container(
                  height: 32.h,
                  width: 1,
                  color: ColorPalette.grey,
                ),
                providerValue.sortFieldOptions!.isEmpty
                    ? Flexible(
                        flex: 1,
                        child: Opacity(
                          opacity: 0.3,
                          child: SizedBox(
                            height: 49.h,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(Assets.iconsFilterUpDown),
                                SizedBox(
                                  width: 12.w,
                                ),
                                Text(
                                  context.loc.sortTxt,
                                  style: FontStyle.black13Regular,
                                )
                              ],
                            ),
                          ),
                        ))
                    : Flexible(
                        flex: 1,
                        child: InkWell(
                          onTap: (() async {
                            showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return SizedBox(
                                  height: 65.h *
                                      providerValue.sortFieldOptions!.length,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        //SORT
                                        Container(
                                            padding: EdgeInsets.only(
                                              top: 14.h,
                                              left: 12.w,
                                              right: 12.w,
                                            ),
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              context.loc.sortBy,
                                              style:
                                                  FontStyle.mildBlack15Medium,
                                            )),
                                        Container(
                                          margin: EdgeInsets.only(top: 14.h),
                                          height: 1,
                                          width: context.sw(),
                                          color: ColorPalette.grey,
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.only(
                                              left: 12.w,
                                              right: 12.w,
                                            ),
                                            child: CommonListTileRadioListRight(
                                                sortFieldOptionsList:
                                                    providerValue
                                                        .sortFieldOptions),
                                          ),
                                        ),
                                        //SORT CLOSE
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                            log("sort");
                          }),
                          child: SizedBox(
                            height: 49.h,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(Assets.iconsFilterUpDown),
                                SizedBox(
                                  width: 12.w,
                                ),
                                Text(
                                  context.loc.sortTxt,
                                  style: FontStyle.black13Regular,
                                )
                              ],
                            ),
                          ),
                        ),
                      )
              ],
            ),
          );
  }));
}
