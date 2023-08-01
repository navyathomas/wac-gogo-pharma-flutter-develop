import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/views/checkout/order_summary_address_tile.dart';
import 'package:gogo_pharma/views/checkout/order_summary_product_list.dart';
import 'package:provider/provider.dart';

import '../../common/route_generator.dart';
import '../../providers/cart_provider.dart';
import '../cart/cart_bottom_detail_tile.dart';
import '../cart/cart_bottom_tile.dart';

class OrderSummary extends StatefulWidget {
  final VoidCallback? onAddressTap;
  const OrderSummary({Key? key, this.onAddressTap}) : super(key: key);

  @override
  State<OrderSummary> createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          height: 8.h,
        ),
        OrderSummaryAddressTile(
          onAddressTap: widget.onAddressTap,
        ),
        SizedBox(
          height: 5.h,
        ),
        const OrderSummaryProductList(),
        SizedBox(
          height: 7.h,
        ),
        Consumer<CartProvider>(builder: (context, model, _) {
          return CartBottomDetailTile(
            cartModel: model.cartModel,
            fromCartPage: false,
          );
        })
      ],
    );
  }
}
