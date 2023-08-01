import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';

import '../../models/address_model.dart';
import '../../services/helpers.dart';
import '../../utils/color_palette.dart';

class AddressTile extends StatelessWidget {
  final Addresses? addresses;
  final bool isAddressSelected;
  const AddressTile({Key? key, this.addresses, this.isAddressSelected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                  '${Helpers.capitaliseFirstLetter(addresses?.firstname ?? '')}'
                  '\t ${addresses?.lastname ?? ''}',
                  style: FontStyle.black13Medium),
              SizedBox(width: 9.w),
              Container(
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                      color: isAddressSelected
                          ? HexColor('#7BADF0')
                          : Colors.white,
                      border: !isAddressSelected
                          ? Border.all(color: HexColor('#D9E3E3'))
                          : null,
                      borderRadius: BorderRadius.circular(10.r)),
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  child: Text(
                    (addresses?.typeOfAddress ?? -1) == 1
                        ? context.loc.office
                        : context.loc.home,
                    style: isAddressSelected
                        ? FontStyle.white10Regular.copyWith(height: 1.2.h)
                        : FontStyle.regular10_8A9CAC.copyWith(height: 1.2.h),
                  ))
            ],
          ),
          SizedBox(height: 10.h),
          Text(Helpers.removeBracket(addresses?.street ?? []),
              style: FontStyle.regular13_696969),
          SizedBox(height: 13.h),
          Text('Mob: ${addresses?.telephone ?? ''}',
              style: FontStyle.regular13_696969),
        ]);
  }
}
