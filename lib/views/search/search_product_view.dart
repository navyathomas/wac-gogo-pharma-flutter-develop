import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/common/route_generator.dart';
import 'dart:math' as math;
import 'package:gogo_pharma/generated/assets.dart';
import 'package:gogo_pharma/models/route_arguments.dart';
import 'package:gogo_pharma/providers/search_provider.dart';
import 'package:gogo_pharma/services/helpers.dart';
import 'package:gogo_pharma/widgets/common_image_view.dart';
import 'package:gogo_pharma/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../models/search_list_model.dart';
import '../../utils/color_palette.dart';
import '../../widgets/common_error_widget.dart';

class SearchResponseView extends StatelessWidget {
  final SearchAggregations? searchAggregations;
  final List<SearchListItems>? searchItems;
  final int searchItemLength;
  final int searchOptionsLength;
  final String? searchInput;
  const SearchResponseView(
      {Key? key,
      this.searchAggregations,
      this.searchItems,
      this.searchInput,
      this.searchItemLength = 0,
      this.searchOptionsLength = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: double.maxFinite,
      width: double.maxFinite,
      margin: EdgeInsets.only(top: 3.h),
      alignment: Alignment.center,
      child: (searchAggregations?.options ?? []).isEmpty &&
              (searchItems ?? []).isEmpty
          ? const SingleChildScrollView(
              child: CommonErrorWidget(
                types: ErrorTypes.noMatchFound,
              ),
            )
          : CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final int itemIndex = index ~/ 2;
                    SearchListItems? item = searchItems?[itemIndex];
                    if (item == null) return const SizedBox();
                    if (index.isEven) {
                      return SearchProductTile(
                        image: item.smallImage?.appImageUrl ?? '',
                        title: item.name ?? '',
                        subTitle: item.categoryName ?? '',
                        textChanging: searchInput ?? '',
                        onTap: () {
                          Navigator.pushNamed(
                              context, RouteGenerator.routeProductDetails,
                              arguments: RouteArguments(sku: item.sku));
                        },
                      );
                    }
                    return ReusableWidgets.divider(
                        height: 1.0,
                        color: HexColor('#EAF2F2'),
                        marginWidth: 10.w);
                  },
                  semanticIndexCallback: (Widget widget, int localIndex) {
                    if (localIndex.isEven) {
                      return localIndex ~/ 2;
                    }
                    return null;
                  },
                  childCount: searchItemLength != 0
                      ? math.max(0, searchItemLength * 2 - 1)
                      : 0,
                )),
                SliverToBoxAdapter(
                  child: ReusableWidgets.divider(
                      height: 1.0,
                      color: HexColor('#EAF2F2'),
                      marginWidth: 10.w),
                ),
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final int itemIndex = index ~/ 2;
                    SearchOptions? options =
                        searchAggregations?.options?[itemIndex];
                    if (options == null) return const SizedBox();
                    if (index.isEven) {
                      return SearchProductTileWithoutImage(
                        title: options.label ?? '',
                        leadText: searchInput ?? '',
                        onTap: () {
                          Navigator.pushNamed(
                              context, RouteGenerator.routeProductListing,
                              arguments: RouteArguments(
                                  title: options.label ?? '',
                                  id: options.value));
                        },
                      );
                    }
                    return ReusableWidgets.divider(
                        height: 1.0,
                        color: HexColor('#EAF2F2'),
                        marginWidth: 10.w);
                  },
                  semanticIndexCallback: (Widget widget, int localIndex) {
                    if (localIndex.isEven) {
                      return localIndex ~/ 2;
                    }
                    return null;
                  },
                  childCount: searchOptionsLength != 0
                      ? math.max(0, searchOptionsLength * 2 - 1)
                      : 0,
                ))
              ],
            ),
    );
  }
}

class SearchProductTile extends StatelessWidget {
  final String image;
  final String? title;
  final String? textChanging;
  final String? subTitle;
  final Function? onTap;
  const SearchProductTile(
      {Key? key,
      this.image = '',
      this.title,
      this.subTitle,
      this.textChanging = '',
      this.onTap})
      : super(key: key);

  TextSpan searchMatch(String match) {
    if (textChanging == null || textChanging == "") {
      return TextSpan(text: match, style: FontStyle.black14SemiBold);
    }
    var refinedMatch = match.toLowerCase();
    var refinedSearch = textChanging!.toLowerCase();
    if (refinedMatch.contains(refinedSearch)) {
      if (refinedMatch.substring(0, refinedSearch.length) == refinedSearch) {
        return TextSpan(
          style: FontStyle.grey14Regular_6E6E,
          text: match.substring(0, refinedSearch.length),
          children: [
            /*TextSpan(
                text: match.substring(refinedSearch.length, match.length),
                style: FontStyle.black14SemiBold),*/
            searchMatch(
              match.substring(
                refinedSearch.length,
              ),
            ),
          ],
        );
      } else if (refinedMatch.length == refinedSearch.length) {
        return TextSpan(
          text: match,
          style: FontStyle.grey14Regular_6E6E,
        );
      } else {
        return TextSpan(
          style: FontStyle.black14SemiBold,
          text: match.substring(
            0,
            refinedMatch.indexOf(refinedSearch),
          ),
          children: [
            searchMatch(
              match.substring(
                refinedMatch.indexOf(refinedSearch),
              ),
            ),
          ],
        );
      }
    } else if (!refinedMatch.contains(refinedSearch)) {
      return TextSpan(text: match, style: FontStyle.black14SemiBold);
    }
    return TextSpan(
      text: match.substring(0, refinedMatch.indexOf(refinedSearch)),
      style: FontStyle.black14SemiBold,
      children: [
        searchMatch(match.substring(refinedMatch.indexOf(refinedSearch)))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) onTap!();
        context.read<SearchProvider>().addToRecentSearch(title ?? '');
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        alignment: Alignment.center,
        child: Row(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: image.isNotEmpty
                  ? CommonImageView(
                      image: image,
                      height: 41.h,
                      width: 27.w,
                      boxFit: BoxFit.contain,
                    )
                  : SizedBox(
                      height: 41.h,
                      width: 27.w,
                      child: Center(
                        child: SvgPicture.asset(
                          Assets.iconsSearchGrey,
                          height: 17.w,
                          width: 17.w,
                        ),
                      ),
                    ),
            ),
            SizedBox(
              width: 11.w,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: searchMatch(title ?? ''),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if ((subTitle ?? '').isNotEmpty)
                    Text(
                      subTitle ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: FontStyle.blue11Medium_7787FF,
                      strutStyle: const StrutStyle(height: 0.8),
                    ),
                ],
              ),
            ),
            SvgPicture.asset(
              Assets.iconsArrowDiagonal,
              height: 12.5.h,
              width: 12.w,
            ),
            SizedBox(
              width: 8.w,
            )
          ],
        ),
      ),
    );
  }
}

class SearchProductTileWithoutImage extends StatelessWidget {
  final String? title;
  final String? leadText;
  final Function? onTap;
  const SearchProductTileWithoutImage(
      {Key? key, this.title, this.leadText = '', this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) onTap!();
        context.read<SearchProvider>().addToRecentSearch(title ?? '');
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        alignment: Alignment.center,
        child: Row(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: SizedBox(
                height: 41.h,
                width: 27.w,
                child: Center(
                  child: SvgPicture.asset(
                    Assets.iconsSearchGrey,
                    height: 17.w,
                    width: 17.w,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 11.w,
            ),
            Expanded(
              child: Row(
                children: [
                  Text(
                    leadText ?? '',
                    style: FontStyle.grey14Regular_6E6E,
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Expanded(
                      child: Text(
                    title ?? '',
                    style: FontStyle.black14SemiBold,
                  ))
                ],
              ),
            ),
            SvgPicture.asset(
              Assets.iconsArrowDiagonal,
              height: 12.5.h,
              width: 12.w,
            ),
            SizedBox(
              width: 8.w,
            )
          ],
        ),
      ),
    );
  }
}
