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
import 'package:gogo_pharma/providers/search_product_provider.dart';
import 'package:gogo_pharma/providers/search_provider.dart';
import 'package:gogo_pharma/services/helpers.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:gogo_pharma/widgets/common_app_bar.dart';
import 'package:gogo_pharma/widgets/common_error_widget.dart';
import 'package:gogo_pharma/widgets/common_product_card.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gogo_pharma/widgets/common_product_card_shimmer.dart';
import 'package:gogo_pharma/widgets/network_connectivity.dart';
import 'package:gogo_pharma/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../../models/route_arguments.dart';
import '../../widgets/common_listtile_side_radio_search.dart';

class SearchProductListing extends StatefulWidget {
  final List<String>? categoryID;
  final String? searchkey;
  final Map<String, dynamic>? filter;
  final Map<dynamic, dynamic>? sort;
  final String appbarTitle;

  const SearchProductListing(
      {Key? key,
      this.categoryID,
      this.appbarTitle = "",
      this.filter,
      this.sort,
      this.searchkey = ""})
      : super(key: key);

  @override
  State<SearchProductListing> createState() => _SearchProductListingState();
}

class _SearchProductListingState extends State<SearchProductListing> {
  // final ValueNotifier<int> pageNo = ValueNotifier<int>(1);
  ScrollController scrollController = ScrollController();
  int? totalLength;
  @override
  void initState() {
    _initialData();
    super.initState();
  }

  void _initialData() {
    final products = Provider.of<SearchProductProvider>(context, listen: false);
    _scrollListen(products);

    Future.microtask(() {
      products.storePreviousFilterData();
      context.read<SearchProductProvider>().clearFilter(); //test
      products.updateLoadedstate(LoaderState.loading);
      if (context.read<SearchProductProvider>().productFilter == null) {
        products.getProductFilters(context,
            widget.searchkey != "" ? widget.searchkey : products.searchKey);
      } else {
        context.read<SearchProductProvider>().refresh();
      }
      products.initProductList();
      products.setSearchKey(widget.searchkey != ""
          ? widget.searchkey
          : products.searchKey); //save search key
      products.getProductList(
        products.pageNumberCount,
        products.categoryIDs.isEmpty
            ? widget.categoryID!
            : products.categoryIDs,
        products.searchKey,
        widget.filter,
        widget.sort,
      );

      products.saveDefaultCategoryID(widget.categoryID!);
    });
  }

  @override
  Widget build(BuildContext context) {
    double textScale =
        Helpers.validateScale(MediaQuery.of(context).textScaleFactor) - 1;
    return Container(
      color: ColorPalette.bgColor,
      child: SafeArea(
        top: false,
        child: Scaffold(
            backgroundColor: ColorPalette.bgColor,
            appBar: CommonAppBar(
              pageTitle: widget.searchkey,
              enableNavBAck: true,
              buildContext: context,
            ),
            body: Consumer<SearchProductProvider>(
                builder: ((context, value, child) {
              if (value.productList != null) {
                totalLength = value.productList?.products?.totalCount ?? 0;
              }
              return NetworkConnectivity(
                  onTap: () => _initialData(),
                  child: value.isListEmpty
                      ? Center(
                          child: CommonErrorWidget(
                          types: ErrorTypes.noMatchFound,
                          buttonText: context.loc.searchAgain,
                          onTap: () {
                            context.read<SearchProvider>().onClearTap();
                            Navigator.pop(context);
                          },
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
                                                    padding: EdgeInsets.only(
                                                        top: 5.h)),
                                                SliverGrid(
                                                  delegate:
                                                      SliverChildBuilderDelegate(
                                                    (context, index) {
                                                      Item? item =
                                                          value.items?[index];
                                                      MaximumPrice?
                                                          maximumPrice = item
                                                              ?.priceRange
                                                              ?.maximumPrice;
                                                      if (item == null ||
                                                          maximumPrice ==
                                                              null) {
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
                                                                      sku: item
                                                                          .sku,
                                                                      item:
                                                                          item));
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
                                                                  .finalPrice!
                                                                  .value
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
                                                    childCount:
                                                        value.items!.length,
                                                  ),
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisSpacing: 5.w,
                                                          mainAxisExtent: 330
                                                                  .h +
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
                                ));
            })),
            bottomNavigationBar: bottomNavBar(
              context,
            )),
      ),
    );
  }

  _scrollListen(SearchProductProvider value) {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          (scrollController.position.maxScrollExtent / 2)) {
        if (value.productList!.products!.pageInfo!.totalPages! >
            value.pageNumberCount) {
          log("Pagination started");
          loadMore(context, value);
        }
      }
    });
  }

  loadMore(BuildContext context, SearchProductProvider value) async {
    if ((value.items!.length) < totalLength!) {
      value.pageNumberCount = value.pageNumberCount + 1;
      log("Now Page Number is : ${value.pageNumberCount}");
      await context.read<SearchProductProvider>().getProductList(
          value.pageNumberCount,
          context.read<SearchProductProvider>().categoryIDs.isEmpty
              ? widget.categoryID!
              : context.read<SearchProductProvider>().categoryIDs,
          value.searchKey,
          widget.filter,
          context.read<SearchProductProvider>().sort
          // widget.sort  -> it is replaced buy provider sort value on 27 sep 2022
          );
      log("scrolled automaticly ....");
    }
  }
}

Widget bottomNavBar(BuildContext context) {
  return Consumer<SearchProductProvider>(builder: ((_, providerValue, child) {
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
                            Navigator.pushNamed(context,
                                RouteGenerator.routeSearchProductFilter);
                            //  SearchProductListing(searchkey: "",categoryID: [],sort: {},);
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
                                            child: CommonListTileRadioRight(
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
