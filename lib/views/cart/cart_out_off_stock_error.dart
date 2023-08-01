import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';

import '../../common/constants.dart';
import '../../utils/color_palette.dart';

class CartOutOffStockTile extends StatelessWidget {
  final bool? isAllNotInStock;
  const CartOutOffStockTile({Key? key, this.isAllNotInStock}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: ((isAllNotInStock ?? false)
              ? Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
                  color: HexColor('#FF5353'),
                  width: double.maxFinite,
                  child: Text(context.loc.cartProductOutOfStockErr,
                      style: FontStyle.white13Regular),
                )
              : const SizedBox())
          .animatedSwitch(),
    );
  }
}
