import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/views/cart/cart_tile.dart';

import '../../models/cart_model.dart';

class CartTileList extends StatelessWidget {
  final CartModel? cartModel;
  const CartTileList({Key? key, this.cartModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate((cxt, index) {
          if(cartModel?.items?[index] == null){
            return const SizedBox();
          }
      return CartTile(
        cartItems: cartModel?.items?[index],
      );
    }, childCount: cartModel?.items?.length ?? 0));
  }
}
