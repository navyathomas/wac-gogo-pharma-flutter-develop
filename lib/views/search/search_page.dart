import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/providers/search_provider.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:gogo_pharma/views/search/initial_search_view.dart';
import 'package:gogo_pharma/views/search/search_product_view.dart';
import 'package:gogo_pharma/views/search/serach_loader.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      context.read<SearchProvider>().getRecentSearch();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HexColor('#F4F7F7'),
      child: Consumer<SearchProvider>(builder: (context, model, _) {
        return (model.searchValue.isEmpty
                ? InitialSearchView(
                    model: model,
                  )
                : model.loaderState == LoaderState.loading
                    ? const SearchLoader()
                    : SearchResponseView(
                        searchItemLength: model.searchItemLength,
                        searchOptionsLength: model.searchOptionsLength,
                        searchAggregations: model.searchAggregations,
                        searchItems: model.searchItems,
                        searchInput: model.searchInput,
                      ))
            .animatedSwitch();
      }),
    );
  }
}
