import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/models/product_listing_model.dart';
import 'package:gogo_pharma/models/route_arguments.dart';
import 'package:gogo_pharma/providers/product_detail_provider.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:gogo_pharma/views/product_details/product_detail_loader.dart';
import 'package:gogo_pharma/views/product_details/product_detail_main_view.dart';
import 'package:gogo_pharma/views/product_details/product_detail_main_with_loader.dart';
import 'package:gogo_pharma/widgets/common_app_bar.dart';
import 'package:provider/provider.dart';

import '../../widgets/common_error_widget.dart';
import '../../widgets/network_connectivity.dart';

class ProductDetailScreen extends StatefulWidget {
  final RouteArguments? routeArguments;
  const ProductDetailScreen({Key? key, this.routeArguments}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late final PageController controller;

  @override
  void initState() {
    controller = PageController();
    _getData();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _animateSlider(Item? item) {
    Future.delayed(const Duration(seconds: 1)).then((_) {
      if (controller.hasClients) {
        int nextPage = (controller.page ?? 0).round() + 1;
        if (nextPage != (item?.mediaGallery?.length ?? 0)) {
          controller
              .animateToPage(nextPage,
                  duration: const Duration(seconds: 1), curve: Curves.linear)
              .then((_) => _animateSlider(item));
        } else {
          controller.animateToPage(0,
              duration: const Duration(seconds: 1), curve: Curves.linear);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#F4F7F7'),
      appBar: CommonAppBar(
        pageTitle: '',
        elevationVal: 0,
        buildContext: context,
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: 3.h),
          child: Consumer<ProductDetailProvider>(builder: (context, model, _) {
            return NetworkConnectivity(
              onTap: () => _getData(),
              child: switcherWidget(model),
            );
          }),
        ),
      ),
    );
  }

  Widget switcherWidget(ProductDetailProvider model) {
    Widget _child = const SizedBox();
    switch (model.loaderState) {
      case LoaderState.loading:
        _child = widget.routeArguments?.item != null
            ? ProductDetailMainWithLoader(
                item: widget.routeArguments!.item!,
                controller: controller,
                model: model,
                onCall: () => _getData())
            : model.productDetailData == null
                ? const ProductDetailLoader()
                : ProductDetailMainView(
                    model: model,
                    controller: controller,
                    onCall: () => _getData(),
                  );
        break;
      case LoaderState.loaded:
        _child = model.productDetailData == null
            ? CommonErrorWidget(
                types: ErrorTypes.noDataFound,
                onTap: () {
                  _getData();
                },
              )
            : widget.routeArguments?.item != null
                ? ProductDetailMainWithLoader(
                    item: widget.routeArguments!.item!,
                    controller: controller,
                    model: model,
                    onCall: () => _getData())
                : ProductDetailMainView(
                    model: model,
                    controller: controller,
                    onCall: () => _getData(),
                  );
        break;
      case LoaderState.error:
        _child = CommonErrorWidget(
          types: ErrorTypes.noDataFound,
          onTap: () {
            _getData();
          },
        );
        break;
      case LoaderState.networkErr:
        _child = CommonErrorWidget(
          types: ErrorTypes.networkErr,
          onTap: () {
            _getData();
          },
        );
        break;

      default:
        _child = const SizedBox();
    }
    return _child;
  }

  Future<void> _getData() async {
    Future.microtask(() => context.read<ProductDetailProvider>()
      ..pageInit()
      ..getProductDetailData(widget.routeArguments?.sku ?? '',
          onSuccess: (item) {
        if (item?.mediaGallery != null) {
          WidgetsBinding.instance!
              .addPostFrameCallback((_) => _animateSlider(item));
        }
      })
      ..getBankOffersByProductSku(widget.routeArguments?.sku ?? '')
      ..getSimilarProductData(widget.routeArguments?.sku ?? ''));
  }
}
