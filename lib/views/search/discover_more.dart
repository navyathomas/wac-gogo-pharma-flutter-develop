import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/providers/product_provider.dart';
import 'package:gogo_pharma/providers/search_product_provider.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:provider/provider.dart';

import '../../common/constants.dart';
import '../../common/route_generator.dart';
import '../../models/discover_more_model.dart';
import '../../models/route_arguments.dart';
import '../../providers/search_product_provider.dart';

class DiscoverMoreWidget extends StatelessWidget {
  const DiscoverMoreWidget({Key? key, this.searchSuggestions})
      : super(key: key);
  final List<SearchSuggestions>? searchSuggestions;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: (searchSuggestions!.isEmpty
              ? const SizedBox()
              : Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(18.r),
                  width: double.maxFinite,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.loc.discoverMore,
                        style: FontStyle.grey_8E8E8E_13Regular,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 13.h,
                      ),
                      Wrap(
                        spacing: 9.w,
                        runSpacing: 9.h,
                        children: List.generate(
                            searchSuggestions?.length ?? 0,
                            (index) => GestureDetector(
                                  onTap: () async{
                                   await context.read<SearchProductProvider>().clearAll(context);
                                    Navigator.pushNamed(context,
                                      RouteGenerator.routeSearchProductListing,
                                      arguments: RouteArguments(
                                          id:
                                              '${searchSuggestions?[index].id ?? ''}',
                                          title:
                                              searchSuggestions?[index].text ??
                                                  ''));
                                  },

                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: HexColor('#F4F7F7'),
                                          border: Border.all(
                                              color: HexColor('#EAEFEF')),
                                          borderRadius:
                                              BorderRadius.circular(11.r)),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10.h, horizontal: 13.w),
                                      child: Text(
                                        searchSuggestions?[index].text ?? '',
                                        style: FontStyle.grey14Medium_464646,
                                      )),
                                )),
                      ),
                      SizedBox(
                        height: 7.h,
                      ),
                    ],
                  ),
                ))
          .animatedSwitch(),
    );
  }
}
