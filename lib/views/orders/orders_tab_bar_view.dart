import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gogo_pharma/common/const.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/common/route_generator.dart';
import 'package:gogo_pharma/generated/assets.dart';
import 'package:gogo_pharma/models/myordersmodel/orders_listing_model.dart';
import 'package:gogo_pharma/models/route_arguments.dart';
import 'package:gogo_pharma/providers/orders_provider.dart';
import 'package:gogo_pharma/services/helpers.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:gogo_pharma/widgets/common_button.dart';
import 'package:gogo_pharma/widgets/custom_radio.dart';
import 'package:gogo_pharma/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';
import '../../widgets/common_image_view.dart';

class OrdersTabBarView extends StatelessWidget {
  final List<YourOrderListing>? orderedList;

  const OrdersTabBarView({
    Key? key,
    this.orderedList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<OrdersProvider>(
      builder: (context, value, child) {
        YourOrderListing? yourOrder;
        return CustomScrollView(controller: value.scrollController, slivers: [
          SliverList(
              delegate: SliverChildBuilderDelegate((context, mainIndex) {
            return InkWell(
              onTap: () {
                yourOrder = orderedList?[mainIndex];
                if (yourOrder?.incrementId != null &&
                    yourOrder!.incrementId!.isNotEmpty) {
                  Navigator.pushNamed(context, RouteGenerator.routeOrderDetails,
                      arguments:
                          RouteArguments(incrementId: yourOrder?.incrementId));
                }
              },
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(
                        top: 27.h, bottom: 15.h, right: 13.w, left: 13.w),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _imageView(
                              imageUrl: orderedList?[mainIndex]
                                  .items![0]
                                  .productImageApp),
                          SizedBox(width: 15.w),
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  _buildCurrentStatus(
                                      value: orderedList?[mainIndex]
                                          .currentStatus),
                                  ReusableWidgets.emptyBox(height: 14.h),
                                  Padding(
                                    padding: EdgeInsets.only(right: 53.5.w),
                                    child: _buildProductName(
                                        orderListingTextName:
                                            orderedList?[mainIndex].items !=
                                                        null &&
                                                    orderedList![mainIndex]
                                                        .items!
                                                        .isNotEmpty
                                                ? orderedList![mainIndex]
                                                    .items!
                                                    .map((e) => e.productName)
                                                    .join(',')
                                                : ""),
                                  ),
                                  ReusableWidgets.emptyBox(height: 14.h),
                                  Visibility(
                                    visible:true,
                                    // (orderedList?[mainIndex]
                                    //             .currentStatus
                                    //             ?.label ??
                                    //         "")
                                    //     .contains("Delivered"),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ReusableWidgets.emptyBox(height: 8.h),
                                        TextButton(
                                            onPressed: () {
                                              value.selectRadioIndexProducts =
                                                  -1;
                                              showProductList(
                                                  context: context,
                                                  yourOrder:
                                                      orderedList?[mainIndex]);
                                            },
                                            child: Text(
                                              context.loc.writeReview,
                                            )),
                                      ],
                                    ),
                                  )
                                ]),
                          ),
                        ]),
                  ),
                  ReusableWidgets.verticalDivider(height: 8.h)
                ],
              ),
            );
          }, childCount: orderedList?.length ?? 0)),
          SliverToBoxAdapter(
            child: ReusableWidgets.paginationLoader(value.paginationLoader),
          )
        ]);
      },
    );
  }

  Widget _imageView({String? imageUrl}) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(8.r)),
      child: CommonImageView(
        height: 82.h,
        width: 82.w,
        image: imageUrl ?? "",
      ),
    );
  }

  ///ProductListFor Review
  void showProductList(
      {required BuildContext context, YourOrderListing? yourOrder}) {
    showModalBottomSheet(
        // shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.vertical(top: Radius.circular(25.r))),
        context: context,
        useRootNavigator: true,isDismissible: false,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Consumer<OrdersProvider>(
            builder: (context, model, child) {
              return Container(
                margin: EdgeInsets.all(15.r),decoration: BoxDecoration(borderRadius:  BorderRadius.circular(16.r), color: Colors.white),
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding:
                              EdgeInsets.fromLTRB(16.w, 8.h, 8.w, 5.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                Const.orderedProducts,
                                style: FontStyle.black17Regular,
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    color: HexColor('#000000'),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  })
                            ],
                          ),
                        ),

                        Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 30.h),
                              child: ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  if (yourOrder?.items?[index]
                                          .isProductAvailableForReview !=
                                      null) {
                                    bool? productReviewAvail = yourOrder!
                                        .items![index]
                                        .isProductAvailableForReview;
                                    return productReviewAvail!
                                        ? InkWell(
                                            onTap: () {
                                              model.updateRadioSelectIndexProduct(
                                                  index,
                                                  reviewId:
                                                      yourOrder.items?[index].id);
                                            },
                                            child: Container(
                                              color: Colors.white,
                                              width: double.maxFinite,
                                              padding: EdgeInsets.only(
                                                  top: 20.h,
                                                  right: 16.w,left: 16.w,
                                                  bottom: 10.h),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  // Column(
                                                  //   crossAxisAlignment:
                                                  //       CrossAxisAlignment.start,
                                                  //   children: [
                                                  //     // Radio(
                                                  //     //   value: index,
                                                  //     //   focusColor:
                                                  //     //       HexColor('#C5C5C5'),
                                                  //     //   groupValue: model
                                                  //     //       .selectRadioIndexProducts,
                                                  //     //   activeColor: ColorPalette
                                                  //     //       .primaryColor,
                                                  //     //   onChanged: (int? val) {
                                                  //     //     model.updateRadioSelectIndexProduct(
                                                  //     //         val,
                                                  //     //         reviewId: yourOrder
                                                  //     //             .items?[index]
                                                  //     //             .id);
                                                  //     //   },
                                                  //     // ),
                                                  //
                                                  //     SizedBox(
                                                  //       height: 10.h,
                                                  //     )
                                                  //   ],
                                                  // ),
                                                  Padding(
                                                    padding:EdgeInsets.only(top:5.h),
                                                    child: CustomRadio(enable: model.selectRadioIndexProducts==index,heightWidth: 16.r),
                                                  ),
                                                  13.horizontalSpace,
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        _productName(
                                                            yourOrder: yourOrder,
                                                            index: index),
                                                        10.verticalSpace,
                                                        Text(
                                                          "${yourOrder.items?[index].productSalePrice?.currency} "
                                                          "${yourOrder.items?[index].productSalePrice?.value} ",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: FontStyle
                                                              .black14RegularW500,
                                                        ).avoidOverFlow(
                                                            maxLine: 3),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(width: 20.h),
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(8.r)),
                                                    child: CommonImageView(
                                                      height: 82.h,
                                                      width: 82.w,
                                                      image: yourOrder
                                                              .items?[index]
                                                              .productImageApp ??
                                                          '',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : const SizedBox();
                                  } else {
                                    return const SizedBox();
                                  }
                                },
                                itemCount: yourOrder?.items?.length ?? 0,
                                shrinkWrap: true,
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const Divider(
                                    thickness: 0.8,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 53.h),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 15.w, right: 15.w, bottom: 20.h),
                        child: CommonButton(
                            buttonText: Const.proceed,
                            fontStyle: FontStyle.white18Regular,
                            onPressed: () {
                              if (model.selectRadioIndexProducts == -1) {
                                Helpers.errorToast(
                                    "Please select an item to review");
                              } else {
                                Navigator.of(context).pop();
                                if (yourOrder?.incrementId != null &&
                                    (yourOrder?.incrementId ?? "").isNotEmpty) {
                                  Navigator.pushNamed(
                                      context, RouteGenerator.routeReviewProduct,
                                      arguments: RouteArguments(
                                          reviewImageUrl: yourOrder
                                              ?.items?[
                                                  model.selectRadioIndexProducts]
                                              .productImageApp,
                                          reviewProductName: yourOrder
                                              ?.items?[
                                                  model.selectRadioIndexProducts]
                                              .productName,
                                          sku: yourOrder
                                              ?.items?[
                                                  model.selectRadioIndexProducts]
                                              .productSku,
                                          isFromOrders: true));
                                }
                              }
                            }),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  Widget _buildCurrentStatus({
    CurrentStatus? value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            "${value?.label} " "${value?.date}",
            overflow: TextOverflow.ellipsis,
            style: FontStyle.black14Medium,
          ).avoidOverFlow(maxLine: 1),
        ),
        Padding(
          padding: EdgeInsets.only(right: 10.w, left: 10.w),
          child: SvgPicture.asset(
            Assets.iconsIconFeatherChevronRight,
            width: 5.75.w,
            height: 7.75.h,
            color: HexColor("#696969"),
          ),
        ),
      ],
    );
  }

  Widget _buildProductName({String? orderListingTextName}) {
    return Text(
      orderListingTextName ?? '',
      overflow: TextOverflow.ellipsis,
      style: FontStyle.regular13_696969,
    ).avoidOverFlow(maxLine: 2);
  }

  Widget _productName({YourOrderListing? yourOrder, int? index}) {
    return Text(
      yourOrder?.items?[index ?? 0].productName ?? "",
      overflow: TextOverflow.ellipsis,maxLines: 3,
      style: FontStyle.black14RegularW500,
    );
  }
}
