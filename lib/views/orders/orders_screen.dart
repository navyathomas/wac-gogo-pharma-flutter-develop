import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/generated/assets.dart';
import 'package:gogo_pharma/models/myordersmodel/orders_listing_model.dart';
import 'package:gogo_pharma/providers/orders_provider.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:gogo_pharma/views/orders/order_list_shimmer.dart';
import 'package:gogo_pharma/views/orders/orders_tab_bar_view.dart';
import 'package:gogo_pharma/views/orders/ordersbuyagaintab.dart';
import 'package:gogo_pharma/widgets/common_app_bar.dart';
import 'package:gogo_pharma/widgets/common_button.dart';
import 'package:gogo_pharma/widgets/custom_radio.dart';
import 'package:gogo_pharma/widgets/network_connectivity.dart';
import 'package:provider/provider.dart';
import '../../common/constants.dart';
import '../../common/route_generator.dart';
import '../../widgets/common_error_widget.dart';
import '../../widgets/reusable_widgets.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);

    _getData();

    super.initState();
  }

  void _handleTabSelection() {
    _tabController?.addListener(() {
      Future.microtask(() =>
          context.read<OrdersProvider>().getTabIndex(_tabController!.index));
    });
  }

  @override
  void dispose() {
    //controller should always dispose
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> _getData() async {
    //only one time It should be declared
    _handleTabSelection();
    Future.microtask(() {
      context.read<OrdersProvider>().pageInit();
      context.read<OrdersProvider>().getYourOrdersListData(enableLoader: true);
      context.read<OrdersProvider>().getOrdersBuyAgainListData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#F4F7F7'),
      appBar: CommonAppBar(
        pageTitle: context.loc.myOrder,
        elevationVal: 0,
        buildContext: context,
        disableWish: true,
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: 3.h),
          child: Consumer<OrdersProvider>(builder: (context, model, _) {
            final orderList = model.yourOrders?.items;
            return NetworkConnectivity(
              child: Column(
                children: [
                  _headerTopView(),
                  SizedBox(height: 8.h),
                  _headerBottomView(value: orderList, model: model)
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _headerBottomView(
      {List<YourOrderListing>? value, required OrdersProvider model}) {
    Widget _child = ReusableWidgets.emptyBox();
    switch (model.loaderState) {
      case LoaderState.loading:
        _child = !model.paginationLoader
            ? Expanded(
                child: TabBarView(
                    controller: _tabController,
                    children: [OrderListShimmer(), OrderListShimmer()]),
              )
            : Expanded(
                child: TabBarView(controller: _tabController, children: [
                  OrdersTabBarView(orderedList: value),
                  OrdersBuyAgainTab(
                      orderedBuyAgainList: model.yourBuyAgainOrders?.items)
                ]),
              );
        break;
      case LoaderState.loaded:
        _child = (model.yourOrders?.items == null)
            ? CommonErrorWidget(
                types: ErrorTypes.noOrders,
                buttonText: context.loc.continueShopping,
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, RouteGenerator.routeMain, (route) => false);
                })
            : Expanded(
                child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: [
                      (model.yourOrders?.items ?? []).isEmpty
                          ? Expanded(
                              child: CommonErrorWidget(
                                  types: ErrorTypes.noOrders,
                                  buttonText: context.loc.continueShopping,
                                  onTap: () {
                                    Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        RouteGenerator.routeMain,
                                        (route) => false);
                                  }),
                            )
                          : OrdersTabBarView(orderedList: value),
                      (model.yourBuyAgainOrders?.items ?? []).isEmpty
                          ? CommonErrorWidget(
                              types: ErrorTypes.noOrders,
                              buttonText: context.loc.continueShopping,
                              onTap: () {
                                Navigator.pushNamedAndRemoveUntil(context,
                                    RouteGenerator.routeMain, (route) => false);
                              })
                          : OrdersBuyAgainTab(
                              orderedBuyAgainList:
                                  model.yourBuyAgainOrders?.items)
                    ]),
              );
        break;
      case LoaderState.error:
        if (model.yourOrders?.items == null) {
          _child = Expanded(
            child: CommonErrorWidget(
              types: ErrorTypes.noDataFound,
              buttonText: context.loc.reload,
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, RouteGenerator.routeMain, (route) => false);
              },
            ),
          );
        }
        break;
      case LoaderState.networkErr:
        {
          _child = Expanded(
            child: CommonErrorWidget(
                types: ErrorTypes.networkErr,
                buttonText: context.loc.backToHome,
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, RouteGenerator.routeMain, (route) => false);
                }),
          );
        }
        break;

      default:
        _child = const SizedBox();
    }
    return _child;
  }

  Widget _headerTopView() {
    return Consumer<OrdersProvider>(
      builder: (context, value, child) => Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: HexColor('#F2F2F2'),
                  offset: const Offset(0, 1.0),
                  blurRadius: 3.0.h,
                )
              ],
              border: Border(
                  bottom:
                      BorderSide(color: HexColor('#C7C7CC'), width: 0.5.w))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15.w),
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: HexColor('#00CBC0'),
                  unselectedLabelColor: Colors.black,
                  indicatorWeight: 2,
                  indicatorColor: HexColor('#00CBC0'),
                  labelStyle: FontStyle.green14Medium,
                  unselectedLabelStyle: FontStyle.black14Medium,
                  onTap: (index) {},
                  tabs: [
                    Tab(
                      child: Text(context.loc.yourOrders,
                          style: value.tabControllerIndex == 0
                              ? FontStyle.primary14Medium
                              : FontStyle.black14Medium),
                    ),
                    Tab(child: Text(context.loc.buyAgain,style: value.tabControllerIndex == 1
                        ? FontStyle.primary14Medium
                        : FontStyle.black14Medium,)),
                  ],
                ),
              ),
              value.tabControllerIndex == 0
                  ? _filterButton(model: value)
                  : ReusableWidgets.emptyBox()
            ],
          )),
    );
  }

  Widget _filterButton({OrdersProvider? model}) {
    return Expanded(
      child: Align(
        alignment: Alignment.centerRight,
        child: InkWell(
          onTap: () {
            model?.filterLabelPassValue = null;
            model?.filterTimePassValue = null;
            showFilterList(
              context,
            );
          },
          child: Padding(
            padding: EdgeInsets.only(right: 25.w, left: 25.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  Assets.iconsFilter,
                  height: 9.h,
                  width: 16.w,
                ),
                SizedBox(
                  width: 6.w,
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: Text(
                    context.loc.filter,
                    overflow: TextOverflow.ellipsis,
                    style: FontStyle.grey14regular,
                  ).avoidOverFlow(maxLine: 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showFilterList(
    BuildContext context,
  ) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.r))),
        context: context,
        useRootNavigator: true,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        builder: (BuildContext context) {
          return SizedBox(
            height: context.sh(size: 0.7).h,
            child: Expanded(
              child: Consumer<OrdersProvider>(builder: (context, model, _) {
                if (model.orderFilterLabel == null) {
                  return ReusableWidgets.circularLoader();
                }
                return Column(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.only(top: 20.h, left: 15.w, right: 8.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            context.loc.filter,
                            style: FontStyle.black18SemiBold,
                          ),
                          const Spacer(),
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              color: HexColor('#000000'),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(context.loc.orderStatus,
                                  style: FontStyle.black15Regular),
                              ReusableWidgets.emptyBox(height: 10.h),
                              GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                        childAspectRatio: 9 / 2,
                                        maxCrossAxisExtent: 200.w),
                                shrinkWrap: true,
                                itemCount: model.orderFilterLabel
                                        ?.getOrderStatusFilterInput?.length ??
                                    0,
                                itemBuilder: (context, i) {
                                  var filterLabelData = model.orderFilterLabel
                                      ?.getOrderStatusFilterInput?[i];
                                  return InkWell(
                                    onTap: () {
                                      model.updateRadioSelectIndex(
                                          check: !model.orderFilterCheck,
                                          filterLabelPassVal: filterLabelData);
                                    },
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        CustomRadio(
                                            enable: filterLabelData ==
                                                model.filterLabelPassValue),
                                        SizedBox(width: 11.w),
                                        Expanded(
                                          child: Text(
                                            filterLabelData?.value ?? '',
                                            overflow: TextOverflow.ellipsis,
                                            style: FontStyle.black15Medium,
                                          ).avoidOverFlow(maxLine: 1),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 20.h),
                              Text(context.loc.orderTime,
                                  style: FontStyle.black15Regular),
                              ReusableWidgets.emptyBox(height: 10.h),
                              GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                        childAspectRatio: 9 / 2,
                                        maxCrossAxisExtent: 200.w),
                                shrinkWrap: true,
                                itemCount: model.orderFilterDate
                                        ?.getOrderDateFilterInput?.length ??
                                    0,
                                itemBuilder: (context, i) {
                                  var filterDateData = model.orderFilterDate
                                      ?.getOrderDateFilterInput?[i];
                                  return InkWell(
                                    onTap: () {
                                      model.updateRadioTimeIndex(
                                          filterTimePassVal: filterDateData,
                                          timeCheck:
                                              !model.orderFilterTimeCheck);
                                    },
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        CustomRadio(
                                            enable: filterDateData ==
                                                model.filterTimePassValue),
                                        SizedBox(width: 11.w),
                                        Expanded(
                                          child: Text(
                                            filterDateData?.label ?? '',
                                            overflow: TextOverflow.ellipsis,
                                            style: FontStyle.black15Medium,
                                          ).avoidOverFlow(maxLine: 1),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 23.h),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: 15.w, right: 15.w, bottom: 30.h, top: 10.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.r)),
                                  border: Border.all(
                                    width: 0.8.w,
                                    color: Colors.black,
                                  )),
                              child: CommonButton(
                                  buttonStyle: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    onSurface: HexColor("#DEDEDE"),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.r)),
                                    elevation: 0,
                                  ),
                                  buttonText: context.loc.clearFilters,
                                  fontStyle: FontStyle.black18Regular,
                                  onPressed: () {
                                    model.filterLabelPassValue = null;
                                    model.filterTimePassValue = null;
                                    model.getYourOrdersListData(
                                        enableLoader: true);
                                    Navigator.of(context).pop();
                                  }),
                            ),
                          ),
                          ReusableWidgets.emptyBox(width: 10.w),
                          Expanded(
                            child: CommonButton(
                                buttonText: context.loc.applyFilter,
                                fontStyle: FontStyle.white18Regular,
                                onPressed: () {
                                  model.getYourOrdersListData(
                                      enableLoader: true,
                                      labelVal:
                                          model.filterLabelPassValue?.value,
                                      timeValFrom:
                                          model.filterTimePassValue?.from,
                                      timeValTo: model.filterTimePassValue?.to);
                                  Navigator.of(context).pop();
                                }),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          );
        });
  }
}
