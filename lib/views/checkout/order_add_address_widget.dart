import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/models/route_arguments.dart';
import 'package:gogo_pharma/widgets/location_tile.dart';

import '../address/add_address_screen.dart';

class OrderAddAddress extends StatelessWidget {
  final RouteArguments? addAddressArgument;
  const OrderAddAddress({Key? key, this.addAddressArgument}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (addAddressArgument?.apartmentSelectedFromLocation != null &&
            !(addAddressArgument?.isEditAddress ?? false))
          Padding(
            padding: EdgeInsets.only(top: 3.h),
            child: LocationTile(
              title: addAddressArgument?.apartmentSelectedFromLocation,
            ),
          ),
        Expanded(
          child: Container(
            color: Colors.white,
            child: AddAddressScreen(
                isEditAddress: addAddressArgument?.isEditAddress ?? false,
                addresses: addAddressArgument?.addresses,
                apartment:
                    addAddressArgument?.apartmentSelectedFromLocation ?? '',
                latitude: addAddressArgument?.addresses?.latitude,
                longitude: addAddressArgument?.addresses?.longitude,
                navFromState: addAddressArgument?.navFromState ??
                    NavFromState.navFromAccount),
          ),
        ),
      ],
    );
  }
}
