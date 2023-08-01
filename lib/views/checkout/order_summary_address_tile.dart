import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../providers/address_provider.dart';
import '../../services/helpers.dart';
import '../../utils/color_palette.dart';

class OrderSummaryAddressTile extends StatelessWidget {
  final VoidCallback? onAddressTap;
  const OrderSummaryAddressTile({Key? key, this.onAddressTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Consumer<AddressProvider>(builder: (_, model, __) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  model.address?.name ?? '',
                  style: FontStyle.black13SemiBold_393939,
                ).avoidOverFlow(),
                SizedBox(
                  width: 8.w,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 2.h),
                  decoration: BoxDecoration(
                      border: Border.all(color: HexColor('#2680EB')),
                      borderRadius: BorderRadius.circular(10.r)),
                  child: Text(
                    model.address?.typeOfAddress == 0
                        ? context.loc.home
                        : context.loc.office,
                    style: FontStyle.white10Regular
                        .copyWith(color: HexColor('#2680EB')),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 3.h,
            ),
            Text(Helpers.removeBracket(model.address?.street ?? []),
                style: FontStyle.regular13_696969
                    .copyWith(color: HexColor('#393939'), height: 1.5)),
            SizedBox(
              height: 3.h,
            ),
            Text(
              '${context.loc.mob}: ${model.address?.telephone ?? ''}',
              style: FontStyle.regular13_696969.copyWith(color: Colors.black),
            ).avoidOverFlow(),
            SizedBox(
              height: 14.h,
            ),
            SizedBox(
              width: double.maxFinite,
              child: OutlinedButton(
                  onPressed: onAddressTap,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(width: 1.0, color: HexColor('#00CBC0')),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    context.loc.changeOrAddAddress,
                    style: FontStyle.black15Medium
                        .copyWith(color: HexColor('#00CBC0')),
                  )),
            )
          ],
        );
      }),
    );
  }
}
