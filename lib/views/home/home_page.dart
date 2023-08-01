import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/providers/home_provider.dart';
import 'package:gogo_pharma/providers/payment_provider.dart';
import 'package:gogo_pharma/providers/product_provider.dart';
import 'package:gogo_pharma/services/app_config.dart';
import 'package:gogo_pharma/views/home/home_loader.dart';
import 'package:gogo_pharma/views/home/location_tile.dart';
import 'package:provider/provider.dart';
import '../../widgets/common_error_widget.dart';
import '../../widgets/network_connectivity.dart';
import '../../widgets/reusable_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool show = true;
  @override
  void initState() {
    _getData(clearData: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _getData,
          child: Consumer<HomeProvider>(builder: (context, model, _) {
            return NetworkConnectivity(
              onTap: () => _getData(),
              inAsyncCall: model.loaderState == LoaderState.loading &&
                  model.homeModel?.content != null,
              child: switcherWidget(model),
            );
          }),
        ),
      ),
    );
  }

  Widget switcherWidget(HomeProvider model) {
    Widget _child = const SizedBox();
    switch (model.loaderState) {
      case LoaderState.loading:
        _child = model.homeModel?.content == null
            ? const HomeLoader()
            : mainWidget(model);
        break;
      case LoaderState.loaded:
        _child = mainWidget(model);
        break;
      case LoaderState.error:
        _child = CommonErrorWidget(
          types: ErrorTypes.serverError,
          buttonText: context.loc.refresh,
          onTap: () {
            _getData();
          },
        );
        break;
      case LoaderState.networkErr:
        _child = const CommonErrorWidget(
          types: ErrorTypes.networkErr,
        );
        break;

      default:
        _child = const SizedBox();
    }
    return _child;
  }

  Widget mainWidget(HomeProvider model) {
    return Column(
      children: [
        const HomeLocationTile(),
        ReusableWidgets.divider(height: 2.h),
        Expanded(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [...model.widgetList],
          ),
        ),
      ],
    );
  }

  Future<void> _getData({bool clearData = false}) async {
    if (clearData) {
      Future.microtask(() => context.read<HomeProvider>().pageInit());
    }
    Future.microtask(() => context.read<HomeProvider>().getHomeData(context));
    if (AppData.accessToken.isNotEmpty) {
      Future.microtask(
          () => context.read<PaymentProvider>().checkOrderStatus(context));
    }
    Future.microtask(() {
      context.read<ProductProvider>().clearAll(context);
    });
  }
}
