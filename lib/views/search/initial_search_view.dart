import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/providers/search_provider.dart';
import 'package:gogo_pharma/views/search/discover_more.dart';
import 'package:gogo_pharma/views/search/recent_search_widget.dart';

class InitialSearchView extends StatelessWidget {
  final SearchProvider? model;
  const InitialSearchView({Key? key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(padding: EdgeInsets.only(top: 3.h)),
        RecentSearchWidget(
          recentList: model?.recentSearchItems ?? [],
        ),
        SliverPadding(padding: EdgeInsets.only(top: 8.h)),
        DiscoverMoreWidget(
          searchSuggestions: model?.discoverMoreModel?.searchSuggestions ?? [],
        )
      ],
    );
  }
}
