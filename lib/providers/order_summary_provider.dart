import 'package:flutter/material.dart';
import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/models/route_arguments.dart';
import 'package:gogo_pharma/services/provider_helper_class.dart';

class OrderSummaryProvider extends ChangeNotifier with ProviderHelperClass {
  int pageIndex = 0;
  int addressPageIndex = 0;
  bool disableBtn = false;
  final PageController addressCtrl = PageController();
  RouteArguments? addAddressArgument;

  @override
  void pageInit() {
    pageIndex = 0;
    addressPageIndex = 0;
    addAddressArgument = null;
    disableBtn = false;
    notifyListeners();
    super.pageInit();
  }

  void updatePageIndex(int val) {
    pageIndex = val;
    notifyListeners();
  }

  /// ------------- address page ctrl
  void disposeCtrl() {
    addressCtrl.dispose();
    notifyListeners();
  }

  void switchAddressPage(int index) {
    addressPageIndex = index;
    addressCtrl.animateToPage(index,
        duration: const Duration(milliseconds: 600), curve: Curves.easeIn);
    notifyListeners();
  }

  ///-------------------------------

  void updateAddAddressArgument(val) {
    addAddressArgument = val;
    notifyListeners();
  }

  void updateDisableBtn(bool val) {
    disableBtn = val;
    notifyListeners();
  }

  @override
  void updateLoadState(LoaderState state) {
    // TODO: implement updateLoadState
  }
}
