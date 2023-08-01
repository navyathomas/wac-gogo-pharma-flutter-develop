import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/models/cms_data_model.dart';
import 'package:gogo_pharma/providers/product_detail_provider.dart';
import 'package:gogo_pharma/utils/tuple.dart';
import 'package:gogo_pharma/widgets/common_error_widget.dart';
import 'package:gogo_pharma/widgets/network_connectivity.dart';
import 'package:provider/provider.dart';
import '../../widgets/common_app_bar.dart';

class ProductDetailWebView extends StatefulWidget {
  final String? identifier;
  final bool hideActions;

  const ProductDetailWebView(
      {Key? key, required this.identifier, this.hideActions = false})
      : super(key: key);

  @override
  State<ProductDetailWebView> createState() => _ProductDetailWebViewState();
}

class _ProductDetailWebViewState extends State<ProductDetailWebView> {
  Widget _mainWidget(CmsDataModel? cmsData, LoaderState loaderState) {
    Widget _child = const SizedBox();
    switch (loaderState) {
      case LoaderState.loading:
        _child = cmsData?.cmsBlocks == null
            ? const SizedBox()
            : ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.r),
                    child: HtmlWidget(
                      cmsData?.cmsBlocks?.content ?? '',
                      renderMode: RenderMode.column,
                      textStyle:
                          const TextStyle(fontFamily: FontStyle.themeFont),
                    ),
                  ),
                  14.verticalSpace
                ],
              );
        break;
      case LoaderState.loaded:
        _child = cmsData?.cmsBlocks == null
            ? CommonErrorWidget(
                types: ErrorTypes.noDataFound,
                buttonText: context.loc.reload,
                onTap: () {
                  _getData();
                },
              )
            : ListView(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(top: 16.sp, left: 10.sp, right: 10.sp),
                    child: Text(cmsData?.cmsBlocks?.title ?? "",
                        style: FontStyle.black18Bold.copyWith(fontSize: 20)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.r),
                    child: HtmlWidget(
                      cmsData?.cmsBlocks?.content ?? '',
                      renderMode: RenderMode.column,
                      textStyle:
                          const TextStyle(fontFamily: FontStyle.themeFont),
                    ),
                  ),
                  14.verticalSpace
                ],
              );
        break;

      case LoaderState.error:
        _child = CommonErrorWidget(
          types: ErrorTypes.noDataFound,
          buttonText: context.loc.reload,
          onTap: () {
            _getData();
          },
        );
        break;
      case LoaderState.networkErr:
        _child = _child = CommonErrorWidget(
          types: ErrorTypes.networkErr,
          buttonText: context.loc.reload,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        pageTitle: '',
        elevationVal: 0.5,
        buildContext: context,
        actionList: widget.hideActions ? [] : null,
      ),
      body: SafeArea(
          child: Selector<ProductDetailProvider,
                  Tuple2<CmsDataModel?, LoaderState>>(
              selector: (context, provider) =>
                  Tuple2(provider.cmsDataModel, provider.loaderState),
              builder: (context, value, child) {
                return NetworkConnectivity(
                  inAsyncCall: value.item2 == LoaderState.loading,
                  onTap: () => _getData(),
                  child: _mainWidget(value.item1, value.item2),
                );
              })),
    );
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  Future<void> _getData() async {
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      context.read<ProductDetailProvider>()
        ..webViewInit()
        ..getCmsBlocksData(widget.identifier ?? '');
    });
  }
}
