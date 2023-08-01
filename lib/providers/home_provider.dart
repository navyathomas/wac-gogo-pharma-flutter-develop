import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gogo_pharma/common/check_function.dart';
import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/models/home_model.dart';
import 'package:gogo_pharma/services/provider_helper_class.dart';
import 'package:gogo_pharma/views/home/home_grid_tile.dart';
import 'package:gogo_pharma/views/home/home_header_banner.dart';
import 'package:gogo_pharma/views/home/home_single_banner.dart';
import 'package:gogo_pharma/views/home/home_widgets.dart';

import '../services/helpers.dart';

class HomeProvider extends ChangeNotifier with ProviderHelperClass {
  HomeModel? homeModel;
  List<Widget> widgetList = [];

  Future<void> getHomeData(BuildContext context) async {
    updateLoadState(LoaderState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic _resp = await serviceConfig.getHomeData();
        if (_resp['homepageAppCms'] != null) {
          HomeModel _homeModel = HomeModel.fromJson(_resp['homepageAppCms']);
          setHomeModel(_homeModel, context);
          updateLoadState(LoaderState.loaded);
        } else {
          updateLoadState(LoaderState.loaded);
          Check.checkException(_resp, onError: (val) {
            if (val ?? false) {
              updateLoadState(LoaderState.error);
            }
          });
        }
      } catch (e) {
        log('$e', name: 'homeProvider');
        updateLoadState(LoaderState.error);
      }
    } else {
      updateLoadState(LoaderState.networkErr);
    }
  }

  void setHomeModel(val, BuildContext context) {
    homeModel = val;
    widgetList = [];
    List<Content>? _contentList = homeModel?.content;
    if (_contentList != null) {
      for (var i = 0; i < _contentList.length; i++) {
        Content? _content = _contentList[i];
        switch (_content.blockType) {
          case 'normal_slider':
            widgetList.add(HomeHeaderBanner(
              contentData: _content.contentData,
            ));
            notifyListeners();
            break;
          case 'offer_list':
            widgetList
                .addAll(HomeWidgets.instance.topCategory(context, _content));
            notifyListeners();
            break;
          case 'four_column_images':
            widgetList.add(HomeGridTile(
              content: _content,
            ));
            notifyListeners();
            break;
          case 'single_image_mobile':
            if (_content.contentData != null &&
                _content.contentData!.isNotEmpty) {
              widgetList.add(HomeSingleBanner(
                contentData: _content.contentData!.first,
              ));
            }
            notifyListeners();
            break;
        }
      }
    }
    notifyListeners();
  }

  @override
  void pageInit() {
    loaderState = LoaderState.initial;
    homeModel = null;
    widgetList = [];
    notifyListeners();
    super.pageInit();
  }

  void updateWidgetList(val) {
    widgetList = val;
    notifyListeners();
  }

  @override
  void updateLoadState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }
}
