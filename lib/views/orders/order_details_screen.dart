import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/const.dart';
import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/common/route_generator.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:gogo_pharma/views/orders/order_details_items_tile.dart';
import 'package:gogo_pharma/widgets/common_app_bar.dart';
import 'package:gogo_pharma/widgets/common_error_widget.dart';
import 'package:gogo_pharma/widgets/custom_linear_percent_indicator.dart';
import 'package:gogo_pharma/widgets/network_connectivity.dart';
import 'package:gogo_pharma/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';
import 'package:gogo_pharma/models/myordersmodel/orderdetailsmodel.dart';
import 'package:gogo_pharma/providers/orders_provider.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen(
      {Key? key, required this.index, required this.incrementId})
      : super(key: key);
  final int index;
  final String incrementId;

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  void initState() {
    Future.microtask(() {
      context.read<OrdersProvider>()
        ..clearData()
        ..getYourOrdersDetailsListData(
            incrementID: widget.incrementId, enableLoader: true)
        ..getUserEmail();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HexColor('#F4F7F7'),
        appBar: CommonAppBar(
          pageTitle: context.loc.orderDetails,
          elevationVal: 0,
        ),
        bottomNavigationBar: Selector<OrdersProvider, OrdersDetails?>(
            selector: (context, provider) => provider.yourOrdersDetails,
            builder: (context, data, _) {
              bool orderCanCancel =
                  data?.items?[widget.index].isOrderCanCancel ?? false;
              if (data?.items == null || !orderCanCancel) {
                return ReusableWidgets.emptyBox();
              }
              return InkWell(
                onTap: () {
                  context.read<OrdersProvider>().getCancellationReasons(
                      ctx: context,
                      items: data?.items?[widget.index]);
                },
                child: Container(
                  height: 54.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: HexColor(('#00000017')),
                        spreadRadius: 2,
                        offset: const Offset(0, 1.0),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  child: Text(context.loc.cancelOrder,
                      style: FontStyle.red14medium),
                ),
              );
            }),
        body: SafeArea(
            child: Container(
                margin: EdgeInsets.only(top: 3.h),
                child: Consumer<OrdersProvider>(builder: (context, model, _) {
                  return NetworkConnectivity(
                      inAsyncCall: LoaderState.loading == model.loaderState,
                      child: _mainWidget(model));
                }))));
  }

  Widget commonContainerWhite(
      {Widget? child, EdgeInsetsGeometry? margin, bool needBoxShadow = false}) {
    return Container(
      width: double.maxFinite,
      margin: margin,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: needBoxShadow
              ? [
                  BoxShadow(
                    color: HexColor('#F2F2F2'),
                    offset: const Offset(0, 1),
                    blurRadius: 3,
                    spreadRadius: 1,
                  )
                ]
              : []),
      child: child,
    );
  }

  Widget orderContainer(
      {String? startTitle,
      String? endTitle,
      String? startSubTitle,
      String? endSubTitle}) {
    return commonContainerWhite(
      needBoxShadow: true,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 15.h, 16.w, 15.h),
        child: Row(
          children: [
            Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      startTitle!,
                      overflow: TextOverflow.ellipsis,
                      style: FontStyle.regular12_6E6E6E,
                    ).avoidOverFlow(maxLine: 1),
                    SizedBox(height: 6.h),
                    Text(
                      startSubTitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: FontStyle.black14Medium,
                    ).avoidOverFlow(maxLine: 1)
                  ],
                )),
            if (endSubTitle != null)
              Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        endTitle!,
                        overflow: TextOverflow.ellipsis,
                        style: FontStyle.regular12_6E6E6E,
                      ).avoidOverFlow(maxLine: 1),
                      SizedBox(height: 6.h),
                      Text(
                        endSubTitle,
                        overflow: TextOverflow.ellipsis,
                        style: FontStyle.black16Medium,
                      ).avoidOverFlow(maxLine: 1)
                    ],
                  ))
          ],
        ),
      ),
    );
  }

  Widget _mainWidget(OrdersProvider model) {
    var currency = model
        .yourOrdersDetails?.items?[widget.index].total?.grandTotal?.currency;
    var totalAmt =
        model.yourOrdersDetails?.items?[widget.index].total?.grandTotal?.value;
    Widget _child = ReusableWidgets.emptyBox();
    switch (model.loaderState) {
      case LoaderState.loading:
        _child = model.yourOrdersDetails?.items == null
            ? ReusableWidgets.emptyBox()
            : loadedMainWidget(
                model: model, currency: currency, totalAmt: totalAmt);
        break;
      case LoaderState.loaded:
        _child = (model.yourOrdersDetails?.items != null &&
                model.yourOrdersDetails!.items!.isNotEmpty)
            ? loadedMainWidget(
                model: model, currency: currency, totalAmt: totalAmt)
            : CommonErrorWidget(
                types: ErrorTypes.noProductFound,
                buttonText: context.loc.reload,
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, RouteGenerator.routeMain, (route) => false);
                },
              );
        break;
      case LoaderState.error:
        _child = CommonErrorWidget(
          types: ErrorTypes.noDataFound,
          buttonText: context.loc.reload,
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(
                context, RouteGenerator.routeMain, (route) => false);
          },
        );
        break;
      case LoaderState.networkErr:
        {
          _child = CommonErrorWidget(
              types: ErrorTypes.networkErr,
              buttonText: context.loc.backToHome,
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, RouteGenerator.routeMain, (route) => false);
              });
        }
        break;

      default:
        _child = const SizedBox();
    }
    return _child;
  }

  Widget shippingAddressContainer({OrderDetailsItems? items}) {
    var addressStreet = items?.shippingAddress?.street != null
        ? '${items?.shippingAddress?.street?.first}'
        : '';
    var addressArea = items?.shippingAddress?.area != null
        ? ',\t${items?.shippingAddress?.area}'
        : '';
    var addressCity = items?.shippingAddress?.city != null
        ? ',\t${items?.shippingAddress?.city}'
        : '';
    return commonContainerWhite(
      child: Padding(
        padding:
            EdgeInsets.only(left: 16.w, top: 14.h, right: 18.w, bottom: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.loc.shippingAddress,
              textAlign: TextAlign.start,
              style: FontStyle.black15Medium_2B,
            ),
            SizedBox(height: 19.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(items?.shippingAddress?.firstname ?? '',
                    style: FontStyle.black13Medium),
                SizedBox(width: 6.w),
                Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: HexColor('#E1D0F4')),
                        borderRadius: BorderRadius.circular(10.r)),
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                    child: Text(
                      items?.shippingAddress?.typeOfAddress == 1
                          ? 'Office'
                          : 'Home',
                      style: FontStyle.regular10Purple,
                    ))
              ],
            ),
            SizedBox(height: 6.h),
            Wrap(
              children: [
                Text(
                  addressStreet,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  style: FontStyle.regular13_696969,
                ).avoidOverFlow(maxLine: 2),
                Text(
                  addressArea,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  style: FontStyle.regular13_696969,
                ).avoidOverFlow(maxLine: 2),
                Text(
                  addressCity,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  style: FontStyle.regular13_696969,
                ).avoidOverFlow(maxLine: 2),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Text(
                  items?.shippingAddress?.telephone ?? "",
                  textAlign: TextAlign.start,
                  style: FontStyle.grey_696969_13Regular,
                ).avoidOverFlow(maxLine: 1),
                SizedBox(width: 7.w),
                Container(
                  height: 4.h,
                  width: 4.w,
                  decoration: ShapeDecoration(
                    shape: const CircleBorder(),
                    color: HexColor('#8A9CAC'),
                  ),
                ),
                SizedBox(width: 7.w),
                Expanded(
                  child: Text(
                    'Email : ${context.read<OrdersProvider>().user}',
                    textAlign: TextAlign.start,
                    style: FontStyle.grey_696969_13Regular,
                  ).avoidOverFlow(maxLine: 1),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget paymentMethod({OrderDetailsItems? items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 14.w, left: 16.w),
          child: Text(
            context.loc.paymentMethod,
            textAlign: TextAlign.start,
            style: FontStyle.black15Medium_2B,
          ),
        ),
        SizedBox(height: 3.h),
        Padding(
          padding: EdgeInsets.only(bottom: 15.h, left: 16.w),
          child: Text(
            items?.orderPaymentTitle ?? '',
            textAlign: TextAlign.start,
            style: FontStyle.grey12Regular_6969,
          ),
        )
      ],
    );
  }

  Widget loadedMainWidget(
      {required OrdersProvider model, String? currency, double? totalAmt}) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                orderContainer(
                    startTitle: Const.orderID,
                    startSubTitle: model.yourOrdersDetails?.items?[widget.index]
                            .incrementId ??
                        "",
                    endTitle: Const.totalAmount,
                    endSubTitle: "${currency ?? ""} ${totalAmt ?? ""}"),
                ReusableWidgets.divider(height: 1.h),
                orderContainer(
                    startTitle: Const.orderPlacedOn,
                    startSubTitle: model.yourOrdersDetails?.items?[widget.index]
                            .orderPlaced?.date ??
                        ''),
                SizedBox(height: 8.h),
                StatusIndicator(
                    items: model.yourOrdersDetails?.items?[widget.index]),
                SizedBox(height: 8.h),
                OrderDetailsItemsTile(
                  items: model.yourOrdersDetails?.items?[widget.index],
                ),
                SizedBox(height: 8.h),
                shippingAddressContainer(
                    items: model.yourOrdersDetails?.items?[widget.index]),
                SizedBox(height: 8.h),
                commonContainerWhite(
                    child: paymentMethod(
                        items: model.yourOrdersDetails?.items?[widget.index])),
                SizedBox(height: 8.h),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class StatusIndicator extends StatelessWidget {
  final OrderDetailsItems? items;

  const StatusIndicator({
    Key? key,
    this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // String orderStatus = getOrderStatus(items?.orderTimeline);
    final valueProvider =
        Provider.of<OrdersProvider>(context, listen: false).statusCompleted;
    if (!valueProvider) {
      Future.microtask(() => Provider.of<OrdersProvider>(context, listen: false)
          .updateYourOrdersDetails(items));
    }
    return Container(
      color: Colors.white,
      child: Padding(
        padding:
            EdgeInsets.only(left: 16.w, top: 17.h, right: 16.w, bottom: 14.h),
        child: Consumer<OrdersProvider>(builder: (context, snapshot, _) {
          return Column(
            children: [
              SizedBox(height: 15.h),
              Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10.w, right: 5.w),
                        child: CustomLinearPercentIndicator(
                          width: MediaQuery.of(context).size.width - 90,
                          lineHeight: 2,
                          animation: true,
                          padding: const EdgeInsets.all(0),
                          percent: snapshot.statusPercentage,
                          animationDuration: 1000,
                          leading: snapshot.statusPercentage == 0.0
                              ? _currentStatusCircularIndicator(
                                  cancelRed:
                                      (items?.orderTimeline?.length ?? 0) == 2)
                              : _circularIndicator(
                                  snapshot.statusPercentage >= 0.0,
                                  cancelRed:
                                      (items?.orderTimeline?.length ?? 0) == 2),
                          trailing: snapshot.statusPercentage == 1.0
                              ? _currentStatusCircularIndicator(
                                  cancelRed:
                                      (items?.orderTimeline?.length ?? 0) == 2)
                              : _circularIndicator(
                                  snapshot.statusPercentage == 1.0,
                                  cancelRed:
                                      (items?.orderTimeline?.length ?? 0) == 2),
                          progressColor:
                              (items?.orderTimeline?.length ?? 0) != 2
                                  ? HexColor('#00CBC0')
                                  : HexColor('#FC5F5F'),
                        ),
                      ),
                    ],
                  ),
                  items?.orderTimeline?.length == 2
                      ? ReusableWidgets.emptyBox()
                      : snapshot.statusPercentage == 0.5
                          ? _currentStatusCircularIndicator(
                              cancelRed:
                                  (items?.orderTimeline?.length ?? 0) == 2)
                          : _circularIndicator(snapshot.statusPercentage >= 0.5)
                ],
              ),
              SizedBox(height: 10.h),
              items?.orderTimeline?.length == 3
                  ? Row(
                      children: List.generate(
                          items?.orderTimeline?.length ?? 0,
                          (index) => Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Column(
                                  crossAxisAlignment: index == 0
                                      ? CrossAxisAlignment.start
                                      : index == 1
                                          ? CrossAxisAlignment.center
                                          : CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      index == 0
                                          ? Const.ordered
                                          : index == 1
                                              ? Const.dispatched
                                              : Const.delivery,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.start,
                                      style: FontStyle.black13Medium,
                                    ).avoidOverFlow(maxLine: 1),
                                    Text(
                                      items?.orderTimeline != null &&
                                              items!.orderTimeline!.isNotEmpty
                                          ? items?.orderTimeline![index].date ??
                                              ''
                                          : "-/--/----",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: index == 0
                                          ? TextAlign.start
                                          : index == 1
                                              ? TextAlign.center
                                              : TextAlign.end,
                                      style: FontStyle.regular11_6E,
                                    ).avoidOverFlow(maxLine: 1),
                                  ],
                                ),
                              )),
                    )
                  : Row(
                      children: List.generate(
                          items?.orderTimeline?.length ?? 0,
                          (index) => Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: Column(
                                  crossAxisAlignment: index == 0
                                      ? CrossAxisAlignment.start
                                      : index == 1
                                          ? CrossAxisAlignment.end
                                          : CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      index == 0
                                          ? items?.orderTimeline![index]
                                                  .label ??
                                              ""
                                          : items?.orderTimeline![index]
                                                  .label ??
                                              "",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.start,
                                      style: FontStyle.black13Medium,
                                    ).avoidOverFlow(maxLine: 1),
                                    Text(
                                      items?.orderTimeline != null &&
                                              items!.orderTimeline!.isNotEmpty
                                          ? items?.orderTimeline![index].date ??
                                              ''
                                          : "-/--/----",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: index == 0
                                          ? TextAlign.start
                                          : index == 1
                                              ? TextAlign.center
                                              : TextAlign.end,
                                      style: FontStyle.regular11_6E,
                                    ).avoidOverFlow(maxLine: 1),
                                  ],
                                ),
                              )),
                    )
            ],
          );
        }),
      ),
    );
  }

  // getOrderStatus(List<OrderTimeline>? orderTimeline) {
  //   List<bool> orderStatus = [];
  //   if (orderTimeline != null && orderTimeline.isNotEmpty) {
  //     //  for (var i = 0; i < orderTimeline.length; i++) {
  //     orderStatus = List.generate(orderTimeline.length, (index) => false);
  //
  //     for (var i = 0; i < orderTimeline.length; i++) {
  //       print(orderTimeline[i].currentStatus);
  //       print(i);
  //     }
  //     return orderTimeline[0].currentStatus;
  //   }
  // }

  Widget _currentStatusCircularIndicator({bool cancelRed = false}) {
    return Container(
      height: 16.h,
      width: 16.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: HexColor(cancelRed ? '#FC5F5F' : '#00CBC0'),
          width: 2.0.w,
        ),
      ),
      child: Center(
        child: Container(
          height: 9.h,
          width: 9.w,
          decoration: ShapeDecoration(
            shape: const CircleBorder(),
            color: HexColor(cancelRed ? '#FC5F5F' : '#00CBC0'),
          ),
        ),
      ),
    );
  }

  Widget _circularIndicator(bool status, {bool cancelRed = false}) {
    return Container(
      height: 10,
      width: 10,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: HexColor(status
              ? cancelRed
                  ? '#FC5F5F'
                  : '#00CBC0'
              : '#D9E3E3')),
    );
  }
}
