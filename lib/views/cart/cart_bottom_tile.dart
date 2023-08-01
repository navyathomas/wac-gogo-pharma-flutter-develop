import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/common/route_generator.dart';
import 'package:gogo_pharma/models/product_listing_model.dart';
import 'package:gogo_pharma/services/helpers.dart';
import 'package:gogo_pharma/widgets/common_button.dart';

import '../../utils/color_palette.dart';

class CartBottomTile extends StatelessWidget {
  final Price? grandTotal;
  final String? btnText;
  final VoidCallback? onTap;
  const CartBottomTile({Key? key, this.grandTotal, this.btnText, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75.h,
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: HexColor('#00000029'),
            blurRadius: 5.r,
            offset: const Offset(0.0, 1.0),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Padding(
              padding: EdgeInsets.only(left: context.isArabic ? 0 : 14.w, right: context.isArabic ? 14.w : 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    context.loc.total,
                    style: FontStyle.black13Medium,
                  ).avoidOverFlow(),
                  SizedBox(
                    height: 3.h,
                  ),
                  Expanded(
                    child: Align(
                      alignment: context.isArabic ? Alignment.centerRight : Alignment.centerLeft,
                      child: Text(
                              Helpers.alignPrice(grandTotal?.currency, grandTotal),
                              textAlign: TextAlign.center,
                              style: FontStyle.black16SemiBold)
                          .avoidOverFlow(),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: CommonButton(
              buttonText: btnText ?? context.loc.continueTxt,
              onPressed: onTap,
            ),
          )
        ],
      ),
    );
  }
}
