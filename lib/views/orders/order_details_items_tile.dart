import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/const.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/common/route_generator.dart';
import 'package:gogo_pharma/models/myordersmodel/orderdetailsmodel.dart';
import 'package:gogo_pharma/models/route_arguments.dart';
import 'package:gogo_pharma/providers/orders_provider.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:gogo_pharma/views/orders/cancel_order_screen.dart';
import 'package:gogo_pharma/widgets/common_image_view.dart';
import 'package:gogo_pharma/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

class OrderDetailsItemsTile extends StatelessWidget {
  const OrderDetailsItemsTile({
    Key? key,
    this.items,
  }) : super(key: key);
  final OrderDetailsItems? items;

  @override
  Widget build(BuildContext buildContext) {
    return Consumer<OrdersProvider>(
      builder: (context, modelValue, child) {
        return ListView.separated(
          itemCount: items?.items?.length ?? 0,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.pushNamed(context, RouteGenerator.routeProductDetails,
                    arguments: RouteArguments(sku: items?.items?[index].productSku));
              },
              child: Container(
                color: Colors.white,
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 10.w),
                          child: Column(children: [
                            CommonImageView(
                              height: 61.24.h,
                              width: 61.24.w,
                              image: items?.items?[index].productImageApp ?? '',
                            ),
                            ReusableWidgets.emptyBox(
                              height: 17.h,
                            )
                          ]),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: Padding(
                                          padding:
                                              EdgeInsets.only(right: 36.5.w),
                                          child: _productName(
                                              items: items, index: index))),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    //this column is for order status in order tile
                                    children: [
                                      Text(
                                        items?.items?[index].itemCurrentStatus?.label??"",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 11.sp, fontWeight: FontWeight.w600, color:HexColor("${items?.items?[index].itemCurrentStatus?.color}"))
                                      ),
                                      Text(
                                        items?.items?[index].itemCurrentStatus?.date ??
                                            "",
                                        overflow: TextOverflow.ellipsis,
                                        style: FontStyle.grey11Medium_556879,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5.h, bottom: 8.h),
                                child: Text(
                                  " ${items?.items?[index].productSalePrice?.currency ?? ""}"
                                  " ${items?.items?[index].productSalePrice?.value.toString()}",
                                  overflow: TextOverflow.ellipsis,
                                  style: FontStyle.black13bold,
                                ).avoidOverFlow(maxLine: 3),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "QTY  ${items?.items?[index].quantityOrdered}",
                                    overflow: TextOverflow.ellipsis,
                                    style: FontStyle.grey12Medium_556879,
                                  ).avoidOverFlow(maxLine: 3),
                                  (items?.items?[index].isItemCanCancel == true)
                                      ? InkWell(
                                          onTap: () async {
                                            modelValue.getCancellationReasons(
                                              ctx: buildContext,
                                              itemIndex: index,items: items
                                            );
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                bottom: 4.h, top: 4.h),
                                            child: Text(
                                              Const.cancelItem,
                                              overflow: TextOverflow.ellipsis,
                                              style: FontStyle.regular11RedFF5,
                                            ).avoidOverFlow(maxLine: 3),
                                          ),
                                        )
                                      : ReusableWidgets.emptyBox()
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return ReusableWidgets.emptyBox(height: 8.h);
          },
        );
      },
    );
  }

  Widget _productName({OrderDetailsItems? items, int? index}) {
    return Text(
      items?.items?[index ?? 0].productName ?? "",
      overflow: TextOverflow.ellipsis,
      maxLines: 3,
      style: FontStyle.black13Medium,
    );
  }
}
