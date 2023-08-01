import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/route_generator.dart';
import 'package:gogo_pharma/providers/address_provider.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:gogo_pharma/widgets/network_connectivity.dart';
import 'package:gogo_pharma/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../../widgets/common_app_bar.dart';
import 'select_address_main_widget.dart';

class SelectAddressScreen extends StatefulWidget {
  const SelectAddressScreen({Key? key}) : super(key: key);

  @override
  State<SelectAddressScreen> createState() => _SelectAddressScreenState();
}

class _SelectAddressScreenState extends State<SelectAddressScreen> {
  @override
  void initState() {
    initialState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#F4F7F7'),
      appBar: CommonAppBar(
        pageTitle: context.loc.selectAddress,
        actionList: const [],
      ),
      body: Column(
        children: [
          ReusableWidgets.divider(height: 3.h),
          Expanded(
            child: Consumer<AddressProvider>(builder: (_, model, __) {
              return NetworkConnectivity(
                inAsyncCall: (model.loaderState == LoaderState.loading ||
                    model.fetchAddress == null),
                onTap: initialState,
                child: SelectAddressMainWidget(
                  addresses: model.fetchAddress?.addresses ?? [],
                  defaultAddress: model.address,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  void initialState() {
    Future.microtask(() {
      context.read<AddressProvider>().getAddressList(context, noAddress: (val) {
        if (val) {
          Navigator.pushNamed(
              context, RouteGenerator.routeSelectLocationScreen);
        }
      }, initial: true);
    });
  }
}
