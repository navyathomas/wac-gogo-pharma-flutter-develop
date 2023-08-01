import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/nav_routes.dart';
import 'package:gogo_pharma/models/home_model.dart';
import 'package:gogo_pharma/widgets/common_image_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../widgets/reusable_widgets.dart';

class HomeHeaderBanner extends StatefulWidget {
  final List<ContentData>? contentData;
  const HomeHeaderBanner({Key? key, this.contentData}) : super(key: key);

  @override
  State<HomeHeaderBanner> createState() => _HomeHeaderBannerState();
}

class _HomeHeaderBannerState extends State<HomeHeaderBanner> {
  late final PageController controller;

  @override
  void initState() {
    controller = PageController();
    WidgetsBinding.instance!.addPostFrameCallback((_) => _animateSlider());
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _animateSlider() {
    Future.delayed(const Duration(milliseconds: 300)).then((_) {
      if (controller.hasClients) {
        int nextPage = controller.page!.round() + 1;
        /* if (nextPage == (widget.contentData?.length ?? 0)) {
          nextPage = 0;
        }*/
        Future.delayed(const Duration(seconds: 3)).then((value) => controller
            .animateToPage(nextPage,
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear)
            .then((_) => _animateSlider()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: widget.contentData != null
          ? Column(
              children: [
                Container(
                    height: 149.h,
                    color: Colors.grey,
                    width: double.maxFinite,
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        PageView.builder(
                            controller: controller,
                            itemBuilder: (context, _index) {
                              int index =
                                  _index % (widget.contentData?.length ?? 0);
                              return GestureDetector(
                                onTap: () => NavRoutes.navByType(context,
                                    title:
                                        widget.contentData?[index].name ?? '',
                                    id: '${widget.contentData?[index].linkId}',
                                    type: widget.contentData?[index].linkType ??
                                        ''),
                                child: CommonImageView(
                                  image:
                                      widget.contentData?[index].imageUrl ?? '',
                                  height: 149.h,
                                  width: double.maxFinite,
                                  boxFit: BoxFit.cover,
                                ),
                              );
                            }),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            padding: EdgeInsets.all(3.r),
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(6.0)),
                            margin: EdgeInsets.only(bottom: 9.h),
                            child: SmoothPageIndicator(
                              controller: controller,
                              count: (widget.contentData?.length ?? 0),
                              effect: ExpandingDotsEffect(
                                  paintStyle: PaintingStyle.fill,
                                  activeDotColor:
                                      Colors.white.withOpacity(0.35),
                                  dotColor: Colors.white.withOpacity(0.35),
                                  dotHeight: 7.0,
                                  dotWidth: 7.0),
                            ),
                          ),
                        )
                      ],
                    )),
                ReusableWidgets.divider(height: 3.h),
              ],
            )
          : const SizedBox(),
    );
  }
}
