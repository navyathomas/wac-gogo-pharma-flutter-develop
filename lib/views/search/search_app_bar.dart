import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/generated/assets.dart';
import 'package:gogo_pharma/providers/search_provider.dart';
import 'package:provider/provider.dart';

import '../../common/route_generator.dart';
import '../../models/route_arguments.dart';
import '../../utils/color_palette.dart';

class SearchAppBar extends AppBar {
  final FocusNode focusNode;
  final VoidCallback onTap;
  SearchAppBar({Key? key, required this.focusNode, required this.onTap})
      : super(
          key: key,
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
          elevation: 0.5,
          shadowColor: HexColor('#D9E3E3'),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          leading: IconButton(
              onPressed: () {
                if (focusNode.hasFocus) {
                  focusNode.unfocus();
                } else {
                  onTap();
                }
              },
              icon: const Icon(Icons.arrow_back)),
          titleSpacing: 0,
          title: Consumer<SearchProvider>(builder: (context, model, _) {
            return Row(
              children: [
                Expanded(
                  child: TextField(
                    autofocus: true,
                    focusNode: focusNode,
                    controller: model.searchController,
                    cursorColor: ColorPalette.primaryColor,
                    style: FontStyle.grey14Regular_464646,
                    //onChanged: model.onItemChanged,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (val) {
                      if (val.isNotEmpty) {
                        Navigator.pushNamed(
                            context, RouteGenerator.routeSearchProductListing,
                            arguments: RouteArguments(
                                categoriesIDs: [], sort: {}, searchKey: val));
                      }
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: context.loc.searchHintMsg,
                        hintStyle: FontStyle.grey14Regular_464646,
                        contentPadding: EdgeInsets.only(right: 15.w)),
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: model.searchController.text.isNotEmpty
                      ? IconButton(
                          icon: SvgPicture.asset(
                            Assets.iconsCloseGrey,
                            height: 20.w,
                            width: 20.w,
                          ),
                          onPressed: model.onClearTap,
                        )
                      : const SizedBox(),
                )
              ],
            );
          }),
          automaticallyImplyLeading: false,
        );
}
