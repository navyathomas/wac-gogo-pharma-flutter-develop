import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/generated/assets.dart';
import 'package:gogo_pharma/providers/search_provider.dart';
import 'package:provider/provider.dart';
import 'package:gogo_pharma/common/extensions.dart';

class RecentSearchWidget extends StatelessWidget {
  final List<String>? recentList;

  const RecentSearchWidget({
    Key? key,
    this.recentList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: recentList!.isNotEmpty
            ? Container(
                color: Colors.white,
                padding: EdgeInsets.all(18.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.loc.recentSearches,
                      style: FontStyle.grey_8E8E8E_13Regular,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 23.h,
                    ),
                    ListView.separated(
                        shrinkWrap: true,
                        reverse: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () => context
                                .read<SearchProvider>()
                                .updateControllerText(recentList?[index] ?? ''),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  Assets.iconsReload,
                                  height: 14.r,
                                  width: 14.r,
                                ),
                                SizedBox(
                                  width: 7.5.w,
                                ),
                                Expanded(
                                    child: Text(
                                  recentList?[index] ?? '',
                                  style: FontStyle.grey14Regular_464646,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ))
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (_, __) => SizedBox(
                              height: 26.h,
                            ),
                        itemCount: recentList!.length),
                    SizedBox(
                      height: 7.h,
                    ),
                  ],
                ),
              )
            : const SizedBox(),
      ),
    );
  }
}
