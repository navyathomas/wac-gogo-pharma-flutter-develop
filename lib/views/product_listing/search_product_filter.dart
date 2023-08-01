import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/generated/assets.dart';
import 'package:gogo_pharma/models/product_filter_model.dart';
import 'package:gogo_pharma/providers/search_product_provider.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:gogo_pharma/widgets/common_ListTile_checkbox_search.dart';
import 'package:gogo_pharma/widgets/common_app_bar.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/widgets/common_button.dart';
import 'package:gogo_pharma/widgets/common_listtile_radiolist_search.dart';
import 'package:gogo_pharma/widgets/common_textformfield.dart';
import 'package:gogo_pharma/widgets/custom_slider.dart';
import 'package:provider/provider.dart';

class SearchProductFilter extends StatefulWidget {
  const SearchProductFilter({Key? key}) : super(key: key);

  @override
  State<SearchProductFilter> createState() => _SearchProductFilterState();
}

class _SearchProductFilterState extends State<SearchProductFilter> {
  final FocusNode _searchFocus = FocusNode();
  ValueNotifier<int> clickIndex = ValueNotifier<int>(0);
  ValueNotifier<bool> isChecked = ValueNotifier<bool>(false);

  TextEditingController? controller = TextEditingController(text: "");

  late final ValueNotifier<RangeValues> _currentRangeValues =
      ValueNotifier<RangeValues>(RangeValues(minValue!, maxValue!));
//GLOBAL PRICE RANGE SECTION
  double? maxValue = 0.0;
  double? minValue = 0.0;

//GLOBAL PRICE RANGE SECTION CLOSE
  @override
  void initState() {
    initialdata();
    super.initState();
  }

  void initialdata() {
    Future.microtask(() => {
          if (context.read<SearchProductProvider>().productFilter == null)
            {context.read<SearchProductProvider>().getProductFilters(context,context.read<SearchProductProvider>().searchKey)}
          else
            {context.read<SearchProductProvider>().refresh()}
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonAppBar(
          pageTitle: "Filters",
          actionList: [
            InkWell(
              splashColor: Colors.white,
              highlightColor: Colors.white,
              hoverColor: Colors.white,
              onTap: () {
                maxValue = 0.0;
                minValue = 0.0;
                context.read<SearchProductProvider>().previousMaxValue = maxValue;
                context.read<SearchProductProvider>().previousMinValue = minValue;
                context.read<SearchProductProvider>().clearAll(context,clearSort: false,resetFilter: true);
              },
              child: SizedBox(
                child: Padding(
                  padding: EdgeInsets.only(right: 22.sp, left: 22.sp),
                  child: Center(
                      child: Text(
                    context.loc.clear,
                    style: FontStyle.primary14Regular,
                  )),
                ),
              ),
            )
          ],
        ),

//MAIN BODY
        body: Consumer<SearchProductProvider>(
            builder: ((context, providerValue, child) {
          if (providerValue.loaderStates == LoaderState.loaded) {
            if (minValue == 0.0 && maxValue == 0.0) {
              debugPrint("init min and max");
              minValue = providerValue.minValue!;
              maxValue = providerValue.maxValue!;
              _currentRangeValues.value = RangeValues(minValue!, maxValue!);
            } else {
              _currentRangeValues.value = RangeValues(
                  providerValue.previousMinValue == 0.0
                      ? minValue!
                      : providerValue.previousMinValue!,
                  providerValue.previousMaxValue == 0.0
                      ? maxValue!
                      : providerValue.previousMaxValue!);
            }
            return Stack(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        color: ColorPalette.bgColor,
                        width: 109.13.w,
                        height: context.sh(),
                        child: filterTiles(),
                      ),
                    ),
                    Expanded(
                        flex: 7,
                        child: SizedBox(
                            height: context.sh(),
                            child: Column(
                              children: [
                                Expanded(
                                  child: switching(providerValue),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom: 24.h, left: 15, right: 15),
                                  child: CommonButton(
                                    buttonText: "Show Results",
                                    onPressed: () => providerValue
                                        .storeToMapAndFilter(context),
                                  ),
                                )
                              ],
                            )))
                  ],
                ),
              ],
            );
          }
          if (providerValue.loaderStates == LoaderState.loading) {
            return const Center(child: CupertinoActivityIndicator());
          }
          return const Center(child: CupertinoActivityIndicator());
        })));
  }
//MAIN BODY CLOSE

//FILTER CATEGORY TILES
  Widget filterTiles() {
    return Consumer<SearchProductProvider>(builder: ((context, providerValue, child) {
      List<Aggregation>? _aggregations = providerValue.aggregations!;
      return ListView.builder(
          itemCount: _aggregations.length,
          shrinkWrap: true,
          itemBuilder: ((context, index) {
            return InkWell(
              onTap: () {
                providerValue.updateIndex(index);
              },
              child: Container(
                height: 57.9.h,
                padding: EdgeInsets.only(left: 15.r, right: 15.r),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: providerValue.selectedindex == index
                      ? Colors.white
                      : null,
                  border: Border(
                      bottom: BorderSide(
                    color: ColorPalette.borderGreenGrey,
                    width: 1.h,
                  )),
                ),
                child: Text(
                  _aggregations[index].label ?? '',
                  overflow: TextOverflow.ellipsis,
                  style: FontStyle.grey_556879_13Medium,
                ),
              ),
            );
          }));
    }));
    // });
  }
//FILTER CATEGORY TILES CLOSE

//SWITHING FOR CATEGORY RESULT
  switching(SearchProductProvider _provider) {
    if (_provider.loaderStates == LoaderState.loaded) {
      var model = _provider.aggregations![_provider.selectedindex];
      switch (model.attributeCode) {
        case "price":
          return price(_provider);
        case "category_id":
          return category(model.options!, 'category_id');
        case "brand":
          return brand(_provider.brand!, 'brand');
        case "discount":
          return discount(_provider.discount!);
        case "availability":
          return availability(model.options!, 'availability');
        default:
          return defaultList(model.options!, '');
      }
    }
  }
//SWITHING FOR CATEGORY RESULT CLOSE

//

// ----------------RIGHT SIDE FILTER RESULT ----------------
// DEFAULT LIST VIEW
  Widget defaultList(List<Option> list, type) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.87.w),
      child: CommonListResult(
        list: list,
        needTrailing: true,
        type: type,
      ),
    );
  }
// DEFAULT LIST VIEW CLOSE

//CATEGORY SECTION
  Widget category(List<Option> list, String type) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.87.w),
      child: CommonListResult(
        list: list,
        needTrailing: true,
        type: type,
      ),
    );
  }
//CATEGORY SECTION CLOSE

//DISCOUNT SECTION
  Widget discount(List<Option> list) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 12.87.w),
        child: CommonListTileRadioListSearch(
          list: list,
          needTrailing: true,
        ));
  }
//DISCOUNT SECTION CLOSE

//AVAILABILITY SECTION
  Widget availability(List<Option> list, String type) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.87.w),
      child: CommonListResult(
        list: list,
        needTrailing: true,
        type: type,
      ),
    );
  }
//AVAILABILITY SECTION CLOSE

//BRAND SECTION
  Widget brand(List<Option> list, String type) {
    return Container(
      height: context.sh(),
      width: context.sw(),
      padding: EdgeInsets.symmetric(horizontal: 13.w),
      child: Column(
        children: [
          SizedBox(
            height: 14.h,
          ),
          SizedBox(
            height: 39.h,
            child: CommonTextFormField(
                onChanged: (searchkey) {
                  context.read<SearchProductProvider>().filterdata(searchkey);
                },
                controller: controller,
                prefixIconWidth: 32,
                maxLines: 1,
                hintText: "Search Brands",
                hintFontStyle: FontStyle.grey14Regular_8A9CAC,
                contentPadding: EdgeInsets.only(
                  top: 11.h,
                  bottom: 10.h,
                ),
                focusNode: _searchFocus,
                prefixIcon: Container(
                  transform: Matrix4.translationValues(2.w, 0.0, -10.0),
                  child: IconButton(
                    icon: SvgPicture.asset(Assets.iconsSearchIcon),
                    iconSize: 17.17,
                    onPressed: null,
                  ),
                )),
          ),
          Expanded(
              child: CommonListResult(
            list: list,
            needTrailing: true,
            type: type,
          ))
        ],
      ),
    );
  }
//BRAND SECTION CLOSE

// PRICE SECTION
  Widget price(SearchProductProvider _provider) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.87.w, vertical: 22.67.h),
        child: ValueListenableBuilder<RangeValues>(
            valueListenable: _currentRangeValues,
            builder: (BuildContext context, RangeValues value, Widget? child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Selected Price range",
                    style: FontStyle.grey12Regular_6969,
                  ),
                  SizedBox(
                    height: 9.88.h,
                  ),
                  Text(
                    "AED " +
                        value.start.round().toString() +
                        " - " +
                        "AED " +
                        value.end.round().toString(),
                    style: FontStyle.black14Medium,
                  ),
                  SizedBox(
                    height: 25.45.h,
                  ),
                  CustomSlider(
                    maxValue: maxValue!,
                    minValue: minValue!,
                    rangeValues: value,
                    onChanged: (rangeValues) {
                      Future.delayed(const Duration(milliseconds: 10))
                          .then((value1) {
                        _currentRangeValues.value = rangeValues;
                        _provider.updatePriceVariables(
                            _currentRangeValues.value.start,
                            _currentRangeValues.value.end);
                      });
                    },
                  ),
                ],
              );
            }));
  }

  //PRICE SECTION CLOSE

// ----------------RIGHT SIDE FILTER RESULT CLOSE----------------
}

//
//---------------------------------------------------------------
//COMMON LISTVIEW GENERATOR
class CommonListResult extends StatelessWidget {
  final List<Option> list;
  final String type;
  final bool needTrailing;
  final String trailString;
  const CommonListResult(
      {Key? key,
      required this.list,
      required this.needTrailing,
      this.trailString = "0",
      required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: ((context, index) {
          return Container(
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                  color: ColorPalette.borderGreenGrey,
                  width: 1.h,
                )),
              ),
              child: CommonListTileCheckBoxSearch(
                list: list,
                type: type,
                index: index,
                needTrailing: needTrailing,
              ));
        }));
  }
}
