import 'package:flutter/material.dart';
import 'package:gogo_pharma/common/route_generator.dart';
import 'package:gogo_pharma/services/app_config.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../models/route_arguments.dart';
import '../../providers/location_provider.dart';
import '../../widgets/location_tile.dart';

class CartAddressTile extends StatefulWidget {
  const CartAddressTile({Key? key}) : super(key: key);

  @override
  State<CartAddressTile> createState() => _CartAddressTileState();
}

class _CartAddressTileState extends State<CartAddressTile> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer<LocationProvider>(builder: (context, model, _) {
        return LocationTile(
          title: model.savedUserLocation,
          onTap: () {
            AppData.navFromState = NavFromState.navFromCart;
            Navigator.pushNamed(
                context, RouteGenerator.routeSelectLocationScreen,
                arguments:
                RouteArguments(navFromState: NavFromState.navFromHome));
          },
        );
      }),
    );
  }
}
