import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/common/route_generator.dart';
import 'package:gogo_pharma/models/myordersmodel/orders_buyagain_model.dart';
import 'package:gogo_pharma/models/route_arguments.dart';
import 'package:gogo_pharma/providers/orders_provider.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:gogo_pharma/widgets/common_button.dart';
import 'package:gogo_pharma/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';
import '../../common/update_data.dart';
import '../../widgets/common_image_view.dart';

class OrdersBuyAgainTab extends StatelessWidget {
  List<ItemsBuyAgain>? orderedBuyAgainList;
  ItemsBuyAgain? yourOrderBuyAgain;

  OrdersBuyAgainTab({Key? key, this.orderedBuyAgainList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<OrdersProvider>(
      builder: (context, value, child) {
        return CustomScrollView(
            controller: value.scrollControllerBuyAgain,
            slivers: [
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, mainIndex) {
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                        context, RouteGenerator.routeProductDetails,
                        arguments: RouteArguments(
                            sku: orderedBuyAgainList?[mainIndex].sku));
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
                              Stack(
                                children: [
                                  ReusableWidgets.emptyBox(
                                    width: 105.w,
                                    childWidget: _imageView(
                                        imageUrl:
                                            orderedBuyAgainList?[mainIndex]
                                                .smallImage
                                                ?.appImageUrl),
                                  ),
                                  orderedBuyAgainList?[mainIndex].stockStatus ==
                                          "OUT_OF_STOCK"
                                      ? Positioned(
                                          top: 25.h,
                                          child: ReusableWidgets.outOfStockTag(
                                              context))
                                      : ReusableWidgets.emptyBox(),
                                ],
                              ),
                              SizedBox(width: 15.w),
                              Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 8.h),
                                        child: _buildProductName(
                                            orderListingTextName:
                                                orderedBuyAgainList?[mainIndex]
                                                                .name !=
                                                            null &&
                                                        (orderedBuyAgainList?[
                                                                        mainIndex]
                                                                    .name ??
                                                                "")
                                                            .isNotEmpty
                                                    ? orderedBuyAgainList![
                                                            mainIndex]
                                                        .name
                                                    : ""),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 25.h),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.r)),
                                            border: Border.all(
                                              width: 1.w,
                                              color: HexColor("#DEDEDE"),
                                            )),
                                        child: _BuyAgainButton(
                                          onPressed: orderedBuyAgainList?[
                                                          mainIndex]
                                                      .stockStatus ==
                                                  "Out Of Stock"
                                              ? null
                                              : () {
                                                  if (orderedBuyAgainList?[
                                                              mainIndex]
                                                          .sTypename ==
                                                      "SimpleProduct") {
                                                    UpdateData.addProductToCart(
                                                      sku:
                                                          "${orderedBuyAgainList?[mainIndex].sku}",
                                                      context: context,
                                                      qty: 1,
                                                    );
                                                    print(context.loc.buyAgain);
                                                  } else {
                                                    Navigator.pushNamed(
                                                        context,
                                                        RouteGenerator
                                                            .routeProductDetails,
                                                        arguments: RouteArguments(
                                                            sku: orderedBuyAgainList?[
                                                                    mainIndex]
                                                                .sku));

                                                    print(context.loc.buyAgain);
                                                  }
                                                },
                                          fontStyle:
                                              orderedBuyAgainList?[mainIndex]
                                                          .stockStatus !=
                                                      "OUT_OF_STOCK"
                                                  ? FontStyle
                                                      .black14Medium
                                                      .copyWith(height: 1.2.h)
                                                  : FontStyle
                                                      .disable14TextMedium
                                                      .copyWith(height: 1.2.h),
                                          buttonText:
                                              orderedBuyAgainList?[mainIndex]
                                                          .sTypename ==
                                                      "SimpleProduct"
                                                  ? context.loc.buyAgain
                                                  : context.loc.viewProduct,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                    ]),
                              ),
                            ]),
                      ),
                      ReusableWidgets.verticalDivider(height: 8.h)
                    ],
                  ),
                );
              }, childCount: orderedBuyAgainList?.length ?? 0)),
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

  Widget _buildProductName({String? orderListingTextName}) {
    return Text(
      orderListingTextName ?? '',
      overflow: TextOverflow.ellipsis,
      style: FontStyle.black15Regular,
    ).avoidOverFlow(maxLine: 2);
  }
}

class _BuyAgainButton extends StatelessWidget {
  const _BuyAgainButton(
      {Key? key, this.fontStyle, this.buttonText, this.onPressed})
      : super(key: key);
  final TextStyle? fontStyle;
  final String? buttonText;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: Colors.white,
          onSurface: HexColor("#DEDEDE"),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Text(
          buttonText ?? '',
          maxLines: 1,
          textAlign: TextAlign.center,
          style: fontStyle ?? FontStyle.white15Medium,
        ),
      ),
    );
  }
}
