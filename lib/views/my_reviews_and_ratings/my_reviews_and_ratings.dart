import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/providers/reviews_and_ratings_provider.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:gogo_pharma/views/my_reviews_and_ratings/review_pending_list_loader.dart';
import 'package:gogo_pharma/views/my_reviews_and_ratings/reviews_publish_tile.dart';
import 'package:gogo_pharma/widgets/common_app_bar.dart';
import 'package:gogo_pharma/widgets/reusable_widgets.dart';
import 'package:gogo_pharma/views/my_reviews_and_ratings/reviews_and_ratings_tile.dart';
import 'package:provider/provider.dart';
import '../../common/constants.dart';
import '../../common/route_generator.dart';
import '../../widgets/common_error_widget.dart';

class MyReviewsAndRatings extends StatefulWidget {
  const MyReviewsAndRatings({Key? key}) : super(key: key);

  @override
  State<MyReviewsAndRatings> createState() => _MyReviewsAndRatingsState();
}

class _MyReviewsAndRatingsState extends State<MyReviewsAndRatings>
    with SingleTickerProviderStateMixin {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  void dispose() {
    pendPublishTabController?.dispose();
    super.dispose();
  }

  TabController? pendPublishTabController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: HexColor("#F4F7F7"),
      appBar: CommonAppBar(
        actionList: [ReusableWidgets.emptyBox()],
        pageTitle: context.loc.reviewsAndRatings,
      ),
      body:
          Consumer<ReviewsAndRatingsProvider>(builder: (context, value, child) {
        Widget _child = ReusableWidgets.emptyBox();
        switch (value.loaderState) {
          case LoaderState.loading:
            _child = !value.paginationLoader
                ? const ReviewPendingListLoader()

                ///change heading as well as view
                : Column(
                    children: [
                      Container(
                        color: HexColor("#FFFFFF"),
                        height: 44.h,
                        width: context.sw(),
                        child: TabBar(
                            indicatorSize: TabBarIndicatorSize.label,
                            controller: pendPublishTabController,
                            unselectedLabelColor: HexColor("#000000"),
                            unselectedLabelStyle: FontStyle.black13Medium,
                            labelStyle: FontStyle.primary13Medium,
                            isScrollable: true,
                            labelColor: HexColor("#00CBC0"),
                            tabs: [

                              Tab(
                                child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 3.w),
                                    child: Text(context.loc.submitted)),
                              ),
                              Tab(
                                child: Padding(
                                  padding:
                                  EdgeInsets.symmetric(horizontal: 3.w),
                                  child: Text(
                                    context.loc.yetToReview,
                                  ),
                                ),
                              ),
                            ]),
                      ),
                      Flexible(
                        child: TabBarView(
                          controller: pendPublishTabController,
                          children: [
                            value.reviewsList?.items != null &&
                                    value.reviewsList!.items!.isNotEmpty
                                ? CommonErrorWidget(
                                    types: ErrorTypes.emptyReviews,
                                    buttonText: context.loc.backToHome,
                                    onTap: () {
                                      Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          RouteGenerator.routeMain,
                                          (route) => false);
                                    })
                                : _mainPublishReviewList(value),
                            (value.pendingReviewsList ?? []).isEmpty
                                ? _mainReviewList(value)
                                : CommonErrorWidget(
                                    types: ErrorTypes.emptyReviews,
                                    buttonText: context.loc.backToHome,
                                    onTap: () {
                                      Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          RouteGenerator.routeMain,
                                          (route) => false);
                                    }),
                          ],
                        ),
                      ),
                    ],
                  );
            break;
          case LoaderState.loaded:
            _child = Column(
              children: [
                Container(
                  color: HexColor("#FFFFFF"),
                  height: 44.h,
                  width: context.sw(),
                  child: TabBar(
                      indicatorSize: TabBarIndicatorSize.label,
                      controller: pendPublishTabController,
                      unselectedLabelColor: HexColor("#000000"),
                      unselectedLabelStyle: FontStyle.black13Medium,
                      labelStyle: FontStyle.primary13Medium,
                      isScrollable: true,
                      labelColor: HexColor("#00CBC0"),
                      tabs: [
                        Tab(
                          child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 3.w),
                              child: Text(context.loc.submitted)),
                        ),
                        Tab(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 3.w),
                            child: Text(
                              context.loc.yetToReview,
                            ),
                          ),
                        ),
                      ]),
                ),

                ///change view
                Flexible(
                  child: TabBarView(
                    controller: pendPublishTabController,
                    children: [
                      (value.reviewsList?.items ?? []).isNotEmpty
                          ? _mainPublishReviewList(value)
                          : CommonErrorWidget(
                              types: ErrorTypes.emptyReviews,
                              buttonText: context.loc.backToHome,
                              onTap: () {
                                Navigator.pushNamedAndRemoveUntil(context,
                                    RouteGenerator.routeMain, (route) => false);
                              }),
                      (value.pendingReviewsList ?? []).isNotEmpty
                          ? _mainReviewList(value)
                          : CommonErrorWidget(
                              types: ErrorTypes.emptyReviews,
                              buttonText: context.loc.backToHome,
                              onTap: () {
                                Navigator.pushNamedAndRemoveUntil(context,
                                    RouteGenerator.routeMain, (route) => false);
                              }),
                    ],
                  ),
                ),
              ],
            );
            break;
          case LoaderState.error:
            {
              _child = Column(
                children: [
                  Container(
                    color: HexColor("#FFFFFF"),
                    height: 44.h,
                    width: context.sw(),
                    child: TabBar(
                        indicatorSize: TabBarIndicatorSize.label,
                        controller: pendPublishTabController,
                        unselectedLabelColor: HexColor("#000000"),
                        unselectedLabelStyle: FontStyle.black13Medium,
                        labelStyle: FontStyle.primary13Medium,
                        isScrollable: true,
                        labelColor: HexColor("#00CBC0"),
                        tabs: [
                          Tab(
                            child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 3.w),
                                child: Text(context.loc.submitted)),
                          ),
                          Tab(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 3.w),
                              child: Text(
                                context.loc.yetToReview,
                              ),
                            ),
                          ),
                        ]),
                  ),
                  Flexible(
                    child: TabBarView(
                      controller: pendPublishTabController,
                      children: [
                        CommonErrorWidget(
                          types: ErrorTypes.noDataFound,
                          buttonText: context.loc.reload,
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(context,
                                RouteGenerator.routeMain, (route) => false);
                          },
                        ),
                        CommonErrorWidget(
                          types: ErrorTypes.noDataFound,
                          buttonText: context.loc.reload,
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(context,
                                RouteGenerator.routeMain, (route) => false);
                          },
                        )
                      ],
                    ),
                  ),
                ],
              );
            }
            break;
          case LoaderState.networkErr:
            {
              ///change view and column
              _child = Column(
                children: [
                  Container(
                    color: HexColor("#FFFFFF"),
                    height: 44.h,
                    width: context.sw(),
                    child: TabBar(
                        indicatorSize: TabBarIndicatorSize.label,
                        controller: pendPublishTabController,
                        unselectedLabelColor: HexColor("#000000"),
                        unselectedLabelStyle: FontStyle.black13Medium,
                        labelStyle: FontStyle.primary13Medium,
                        isScrollable: true,
                        labelColor: HexColor("#00CBC0"),
                        tabs: [
                          Tab(
                            child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 3.w),
                                child: Text(context.loc.submitted)),
                          ),
                          Tab(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 3.w),
                              child: Text(
                                context.loc.yetToReview,
                              ),
                            ),
                          ),
                        ]),
                  ),
                  Flexible(
                    child: TabBarView(
                      controller: pendPublishTabController,
                      children: [
                        CommonErrorWidget(
                            types: ErrorTypes.networkErr,
                            buttonText: context.loc.backToHome,
                            onTap: () {
                              Navigator.pushNamedAndRemoveUntil(context,
                                  RouteGenerator.routeMain, (route) => false);
                            }),
                        CommonErrorWidget(
                            types: ErrorTypes.networkErr,
                            buttonText: context.loc.backToHome,
                            onTap: () {
                              Navigator.pushNamedAndRemoveUntil(context,
                                  RouteGenerator.routeMain, (route) => false);
                            })
                      ],
                    ),
                  ),
                ],
              );
            }
            break;

          default:
            _child = ReusableWidgets.emptyBox();
        }
        return _child;
      }),
    );
  }

  ///UI DESIGNED PAGE
  Widget _mainReviewList(ReviewsAndRatingsProvider value) {
    return CustomScrollView(
      shrinkWrap: true,
      controller: value.scrollController,
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
              (context, index) => ReviewsAndRatingTile(index: index, onComplete: (bool val){
                if(val){
                  pendPublishTabController?.animateTo(0);
                }
              },),
              childCount: value.pendingReviewsList?.length),
        ),
        SliverToBoxAdapter(
          child: ReusableWidgets.paginationLoader(value.paginationLoader),
        )
      ],
    );
  }

  Widget _mainPublishReviewList(ReviewsAndRatingsProvider value) {
    return CustomScrollView(
      controller: value.scrollController,
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
              (context, index) => ReviewsPublishTile(index: index, buildCxt: _scaffoldKey.currentContext,),
              childCount: value.reviewsList?.items?.length),
        ),
        SliverToBoxAdapter(
          child: ReusableWidgets.paginationLoader(value.paginationLoader),
        )
      ],
    );
  }

  Future<void> _getData() async {
    Future.microtask(() => context.read<ReviewsAndRatingsProvider>()
      ..pageInit()
      ..getPendingReviews(enableLoader: true));
    pendPublishTabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
  }
}
