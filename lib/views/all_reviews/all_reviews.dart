import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/providers/review_provider.dart';
import 'package:gogo_pharma/views/all_reviews/all_review_loader.dart';
import 'package:gogo_pharma/views/product_details/product_detail_rating_tile.dart';
import 'package:gogo_pharma/widgets/network_connectivity.dart';
import 'package:gogo_pharma/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../../utils/color_palette.dart';
import '../../widgets/common_app_bar.dart';

class AllReviews extends StatefulWidget {
  final String? sku;
  const AllReviews({Key? key, this.sku}) : super(key: key);

  @override
  State<AllReviews> createState() => _AllReviewsState();
}

class _AllReviewsState extends State<AllReviews> {
  @override
  void initState() {
    _getData(clear: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#F4F7F7'),
      appBar: CommonAppBar(
        pageTitle: context.loc.allReviews,
        elevationVal: 0,
        buildContext: context,
      ),
      body: SafeArea(
          child: RefreshIndicator(
        onRefresh: _getData,
        child: Consumer<ReviewProvider>(builder: (context, model, _) {
          return NetworkConnectivity(
            inAsyncCall: model.loaderState == LoaderState.loading &&
                !model.paginationLoader &&
                model.reviews != null,
            onTap: () => _getData(clear: true),
            child: Container(
                margin: EdgeInsets.only(top: 3.h),
                child: model.loaderState == LoaderState.loading &&
                        !model.paginationLoader &&
                        model.reviews == null
                    ? const AllReviewLoader()
                    : CustomScrollView(
                        physics: const BouncingScrollPhysics(),
                        controller: model.scrollController,
                        slivers: [
                          SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  (cxt, index) => RatingTile(
                                        disableBorder:
                                            index == 0 ? true : false,
                                        reviewsItem:
                                            model.reviews?.items?[index],
                                      ),
                                  childCount:
                                      model.reviews?.items?.length ?? 0)),
                          SliverToBoxAdapter(
                            child: ReusableWidgets.paginationLoader(
                                model.paginationLoader),
                          )
                        ],
                      )),
          );
        }),
      )),
    );
  }

  Future<void> _getData({bool clear = false}) async {
    Future.microtask(() {
      if (clear) context.read<ReviewProvider>().pageInit();
      context.read<ReviewProvider>().getAllReviews(sku: widget.sku ?? '');
    });
  }
}
