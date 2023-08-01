import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/route_generator.dart';
import 'package:gogo_pharma/providers/wishlist_provider.dart';
import 'package:gogo_pharma/services/helpers.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:gogo_pharma/views/wishlist/wishlist_loader.dart';
import 'package:gogo_pharma/views/wishlist/wishlist_tile.dart';
import 'package:gogo_pharma/widgets/common_app_bar.dart';
import 'package:gogo_pharma/widgets/common_error_widget.dart';
import 'package:gogo_pharma/widgets/network_connectivity.dart';
import 'package:gogo_pharma/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

class WishListUIScreen extends StatefulWidget {
  const WishListUIScreen({Key? key}) : super(key: key);

  @override
  State<WishListUIScreen> createState() => _WishListUIScreenState();
}

class _WishListUIScreenState extends State<WishListUIScreen> {
  final ValueNotifier<int> pageNo = ValueNotifier<int>(1);
  late final ScrollController controller;

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: HexColor("#F4F7F4"),
        appBar: CommonAppBar(
          buildContext: context,
          pageTitle: context.loc.wishListItem(
              context.watch<WishListProvider>().wishListTotalItems ?? 0),
          disableWish: true,
          enableNavBAck: true,
        ),
        body: SafeArea(
            child: Consumer<WishListProvider>(builder: (context, value, child) {
          Widget _child = ReusableWidgets.emptyBox();
          switch (value.loaderState) {
            case LoaderState.loading:
              _child =
                  !value.paginationLoader && value.wishListItem?.items == null
                      ? const WishListLoader()
                      : mainWidget(value);
              break;
            case LoaderState.loaded:
              _child = (value.wishListItem?.items == null)
                  ? CommonErrorWidget(
                      types: ErrorTypes.emptyWishList,
                      buttonText: context.loc.exploreMore,
                      onTap: () {
                        Navigator.pushNamedAndRemoveUntil(context,
                            RouteGenerator.routeMain, (route) => false);
                      })
                  : value.wishListItem!.items!.isEmpty
                      ? CommonErrorWidget(
                          types: ErrorTypes.emptyWishList,
                          buttonText: context.loc.exploreMore,
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(context,
                                RouteGenerator.routeMain, (route) => false);
                          })
                      : mainWidget(value);
              break;
            case LoaderState.error:
              {
                if (value.wishListItem?.items == null) {
                  _child = CommonErrorWidget(
                    types: ErrorTypes.noDataFound,
                    buttonText: context.loc.reload,
                    onTap: () {
                      _getData();
                    },
                  );
                } else if ((value.wishListItem?.items ?? []).isNotEmpty) {
                  _child = mainWidget(value);
                }
              }
              break;
            case LoaderState.networkErr:
              {
                _child = CommonErrorWidget(
                    types: ErrorTypes.networkErr,
                    buttonText: context.loc.reload,
                    onTap: () {
                      _getData();
                    });
              }
              break;

            default:
              _child = const SizedBox();
          }
          return NetworkConnectivity(onTap: () => _getData(), child: _child);
        })));
  }

  Widget mainWidget(WishListProvider value) {
    double textScale =
        Helpers.validateScale(MediaQuery.of(context).textScaleFactor) - 1;
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      controller: value.scrollController,
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) => WishListTile(index: index),
              childCount: value.wishListItem?.items?.length,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 5.w,
                mainAxisExtent: 311.h + (textScale * 150),
                mainAxisSpacing: 5.h,
                crossAxisCount: 2),
          ),
        ),
        SliverToBoxAdapter(
          child: ReusableWidgets.paginationLoader(value.paginationLoader),
        )
      ],
    );
  }

  Future<void> _getData() async {
    Future.microtask(() => context.read<WishListProvider>().pageInit());
    Future.microtask(() {
      context.read<WishListProvider>().getWishListData(enableLoader: true);
    });
  }
}
