import 'package:flutter/cupertino.dart';
import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/services/service_config.dart';

abstract class ProviderHelperClass {
  final ServiceConfig serviceConfig = ServiceConfig();
  LoaderState loaderState = LoaderState.initial;
  int apiCallCount = 0;
  void pageInit() {}
  void pageDispose() {}
  void updateApiCallCount() {}
  void updateLoadState(LoaderState state);
}
