import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/models/place_mark_suggestion_model.dart';
import 'package:gogo_pharma/utils/color_palette.dart';

class SearchSuggestionItemList extends StatelessWidget {
  final VoidCallback? onPlaceTap;
  final PlaceMarkSuggestion? placeMarkSuggestion;
  final int? index;
  final int? size;

  const SearchSuggestionItemList(
      {Key? key,
      this.onPlaceTap,
      this.placeMarkSuggestion,
      this.index,
      this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPlaceTap,
      child: Container(
          padding: EdgeInsets.all(10.w),
          margin: EdgeInsets.only(bottom: 10.h, top: 2.h),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: const Icon(
                      Icons.location_on_outlined,
                      color: Colors.grey,
                    ),
                    margin: EdgeInsets.only(bottom: 5.h),
                  ),
                ],
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      child: Text(
                        placeMarkSuggestion!.name ?? "",
                        style: FontStyle.black13Regular,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 15.h)
            ],
          )),
      splashColor: Colors.grey,
    );
  }
}

class SearchLoader extends StatelessWidget {
  const SearchLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: 10,
            itemBuilder: (context, index) {
              return Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Icon(
                                Icons.location_on_outlined,
                                color: HexColor("#BDBDBD"),
                              ),
                              margin: const EdgeInsets.only(bottom: 5),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 13,
                              margin: EdgeInsets.only(bottom: 5.w),
                              child: Container(
                                color: Colors.black26,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ));
            },
            shrinkWrap: true,
            physics: const ScrollPhysics(),
          ),
        ),
      ],
    );
  }
}
