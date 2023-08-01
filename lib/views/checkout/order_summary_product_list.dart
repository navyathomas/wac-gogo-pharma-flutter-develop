import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/models/product_filter_model.dart';
import 'package:gogo_pharma/services/helpers.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:gogo_pharma/widgets/common_image_view.dart';
import 'package:provider/provider.dart';

import '../../models/cart_model.dart';
import '../../providers/cart_provider.dart';
import '../../utils/dashed_line_painter.dart';

class OrderSummaryProductList extends StatelessWidget {
  const OrderSummaryProductList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Consumer<CartProvider>(builder: (context, model, _) {
        return ListView.separated(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 11.w),
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (cxt, index) {
            CartItems? item = model.cartModel?.items?[index];
            if (item == null) return const SizedBox();
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 62.w,
                  width: 62.w,
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                      border: Border.all(color: HexColor('#DDE5E5')),
                      borderRadius: BorderRadius.circular(8.r)),
                  child: CommonImageView(
                    image: item.quoteThumbnailUrl ?? '',
                  ),
                ),
                SizedBox(
                  width: 13.5.w,
                ),
                Expanded(
                    child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.product?.name ?? '',
                            style: FontStyle.regular13_696969
                                .copyWith(color: Colors.black, height: 1.5),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          SizedBox(
                            height: 9.h,
                          ),
                          Text(
                            '${context.loc.qty} ${item.quantity ?? 1}',
                            style: FontStyle.grey11Medium
                                .copyWith(color: HexColor('#696969')),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 15.w,
                    ),
                    Text(
                      Helpers.alignPrice(
                          item.prices?.customRowTotalPriceApp?.maximumPrice
                              ?.finalPrice?.currency,
                          item.prices?.customRowTotalPriceApp?.maximumPrice
                              ?.finalPrice),
                      style: FontStyle.black13Medium,
                    )
                  ],
                ))
              ],
            );
          },
          shrinkWrap: true,
          itemCount: model.cartModel?.items?.length ?? 0,
          separatorBuilder: (_, __) {
            return Padding(
              padding: EdgeInsets.only(top: 14.h, bottom: 23.h),
              child: CustomPaint(
                size: const Size.fromHeight(1),
                painter: DashedLinePainter(dashColor: HexColor('#D9E3E3')),
              ),
            );
          },
        );
      }),
    );
  }
}
