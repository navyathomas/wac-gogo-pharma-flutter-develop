import 'dart:async';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/font_style.dart';
import 'package:gogo_pharma/common/route_generator.dart';
import 'package:gogo_pharma/generated/assets.dart';
import 'package:gogo_pharma/services/app_config.dart';
import 'package:gogo_pharma/utils/color_palette.dart';
import 'package:gogo_pharma/views/location/map_shimmer.dart';
import 'package:gogo_pharma/views/location/search_suggestion_item.dart';
import 'package:gogo_pharma/widgets/common_button.dart';
import 'package:gogo_pharma/widgets/common_error_widget.dart';
import 'package:gogo_pharma/widgets/reusable_widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../common/constants.dart';
import '../../providers/location_provider.dart';
import '../../services/helpers.dart';
import '../../widgets/common_app_bar.dart';

class SelectLocation extends StatefulWidget {
  final NavFromState navFromState;
  const SelectLocation(
      {Key? key, this.navFromState = NavFromState.navFromAccount})
      : super(key: key);

  @override
  _SelectLocationState createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation>
    with WidgetsBindingObserver {
  FocusNode searchFocus = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  Set<Circle>? circles;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  int _markerIdCounter = 0;
  Completer<GoogleMapController>? mapController = Completer();
  GoogleMapController? _googleMapController;
  LocationProvider? model;

  String _markerIdVal({bool increment = false}) {
    String val = 'marker_id_$_markerIdCounter';
    if (increment) _markerIdCounter++;
    return val;
  }

  @override
  void initState() {
    initData();
    _appBarOfSplash();
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  initData() {
    _searchController.text = "";
    Future.microtask(() => context.read<LocationProvider>()
      ..checkLocationPermission(context, mapController, _googleMapController)
      ..showSearchWidget(false));
    _searchController.addListener(_onChanged);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    _appBarOfSplash();
    final locationProvider = context.read<LocationProvider>();
    Permission _permission = Permission.location;
    PermissionStatus _status = await _permission.status;
    if (state == AppLifecycleState.resumed) {
      if (_status.isGranted && locationProvider.checkPermission) {
        locationProvider.updateCheckPermission(false);
        Future.microtask(() => locationProvider.checkLocationPermission(context,
            mapController, _googleMapController));
      }
    }
  }

  @override
  void dispose() {
    _searchController.text = "";
    _searchController.dispose();
    searchFocus.dispose();
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  void _appBarOfSplash() {
    if (widget.navFromState == NavFromState.navFromSplash) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Consumer<LocationProvider>(builder: (context, _model, _) {
          model = _model;
          _googleMapController = _model.googleMapController;
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: widget.navFromState == NavFromState.navFromSplash
                ? null
                : !_model.showSearch
                    ? CommonAppBar(
                        pageTitle: context.loc.deliveryLocation,
                        buildContext: context,
                        actionList: const [],
                      )
                    : PreferredSize(
                        preferredSize: const Size(0.0, 0.0),
                        child: Container(),
                      ),
            body: SafeArea(
              top: false,
              child: Stack(
                children: [
                  GestureDetector(
                    child: widget.navFromState == NavFromState.navFromSplash
                        ? _fromSplashView(_model)
                        : _fromAddressView(_model),
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  ),
                ],
              ),
            ),
          );
        }),
        onWillPop: _willPopCallback);
  }

  Widget _fromAddressView(LocationProvider _model) {
    return _model.isLocationEnabled
        ? SafeArea(
            bottom: false,
            child: Stack(
              children: [
                _model.currentLoc != null
                    ? _buildMapWidget()
                    : ReusableWidgets.circularLoader(),
                _model.showSearch ? _buildSearchList() : _buildBottomWidget(),
                _model.loaderState == LoaderState.loading
                    ? ReusableWidgets.circularLoader()
                    : Container()
              ],
            ),
          )
        : requestLocation(_model);
  }

  Widget _fromSplashView(LocationProvider _model) {
    return Stack(
      children: [
        _model.currentLoc == null && _model.isLocationEnabled
            ? ReusableWidgets.circularLoader()
            : _buildMapWidget(),
        _model.showSearch
            ? _buildSearchList()
            : _model.isLocationEnabled
                ? _buildBottomWidget()
                : const SizedBox(),
        _model.loaderState == LoaderState.loading
            ? ReusableWidgets.circularLoader()
            : Container(),
        (_model.isLocationEnabled
                ? const SizedBox()
                : Container(
                    margin: EdgeInsets.fromLTRB(15.w, 41.h, 15.w, 0),
                    decoration: BoxDecoration(
                        color: HexColor('#FF5353'),
                        borderRadius: BorderRadius.circular(8.r),
                        boxShadow: [
                          BoxShadow(
                              color: HexColor('#0000001D'),
                              blurRadius: 2.r,
                              offset: const Offset(0, 2))
                        ]),
                    padding:
                        EdgeInsets.symmetric(vertical: 19.h, horizontal: 13.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(Assets.iconsAlert),
                        SizedBox(
                          width: 10.w,
                        ),
                        Expanded(
                            child: Text(
                                _model.showLocReqBtn
                                    ? context.loc.noLocationPermissionMsg
                                    : context.loc.serviceDisabled,
                                style: FontStyle.white13Regular)),
                        SizedBox(width: 20.w),
                        TextButton(
                          onPressed: () {
                            AppSettings.openDeviceSettings().then((value) {
                              context
                                  .read<LocationProvider>()
                                  .updateCheckPermission(true);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.r))),
                              side: const BorderSide(color: Colors.white)),
                          child: Text(
                            context.loc.goToSettings,
                            style: FontStyle.white13Regular,
                          ),
                        )
                      ],
                    ),
                  ))
            .animatedSwitch(),
      ],
    );
  }

  Widget _buildMapWidget() {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: double.maxFinite,
          width: double.maxFinite,
          child: GoogleMap(
            onCameraIdle: onCameraIdle,
            onMapCreated: onMapCreated,
            onCameraMove: (CameraPosition position) => onCameraMove(position),
            initialCameraPosition: CameraPosition(
              target: model?.currentLoc ??
                  const LatLng(Constants.lat, Constants.lng),
              zoom: 15.0,
            ),
          ),
        ),
        Image.asset(Assets.iconsMarkerPin, width: 35.r, height: 35.r)
      ],
    );
  }

  Widget _buildBottomWidget() {
    return Positioned(
      bottom: 0.0,
      left: 0.0,
      right: 0.0,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 3.0,
            ),
          ],
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(10.0), topLeft: Radius.circular(10.0)),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            model!.isChangeLocEnabled
                ? model?.selectedLoc != null && model?.selectedLoc?.name != null
                    ? buildProceedBtnWidget()
                    : const MapBottomShimmer()
                : Container()
          ],
        ),
      ),
    );
  }

  Widget _buildSearchList() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          model!.isChangeLocEnabled == false
              ? searchCloseButton(context.loc.searchLocationText)
              : Container(),
          model!.isChangeLocEnabled == false
              ? _searchTextField(context)
              : Container(),
          model!.isChangeLocEnabled == false
              ? model!.placeList!.isNotEmpty
                  ? _searchController.text.isNotEmpty
                      ? model!.placesIsLoading
                          ? Expanded(
                              child: Shimmer.fromColors(
                              child: _buildListLoader(),
                              baseColor: HexColor("#BDBDBD"),
                              highlightColor: Colors.white.withOpacity(0.8),
                            ))
                          : _buildPlacesSearchList()
                      : Container()
                  : _noPlaceSuggestionFound()
              : Container(),
          model!.isChangeLocEnabled == false
              ? _searchController.text.isNotEmpty
                  ? Container()
                  : _buildCurrentLocationText()
              : Container(),
        ],
      ),
      color: Colors.white,
    );
  }

  Widget _buildCurrentLocationText() {
    return GestureDetector(
      onTap: () {
        Future.microtask(() => context.read<LocationProvider>()
          ..showSearchWidget(false)
          ..checkLocationPermission(context, mapController, _googleMapController)
          ..typeContext(0));
        setState(() {
          _searchController.text = "";
        });
      },
      child: Container(
        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 8),
        padding: const EdgeInsets.all(2),
        child: Text(
          context.loc.currentLocationText,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: FontStyle.primary14Medium,
        ),
      ),
    );
  }

  Widget _searchTextField(BuildContext context) {
    return Container(
        margin:
            EdgeInsets.only(left: 15.w, right: 15.w, bottom: 8.h, top: 10.h),
        child: TextFormField(
          maxLines: 1,
          textInputAction: TextInputAction.done,
          controller: _searchController,
          focusNode: searchFocus,
          decoration: InputDecoration(
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              contentPadding: EdgeInsets.all(5.0.w),
              labelText: context.loc.searchLocationText,
              hintStyle: FontStyle.slightDarkGrey14Regular,
              prefixIconConstraints:
                  const BoxConstraints(minHeight: 24, minWidth: 24),
              prefixIcon: Container(
                child: const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                padding: EdgeInsets.only(
                    right: context.isArabic ? 0 : 10,
                    left: context.isArabic ? 10 : 0),
              )),
        ));
  }

  Widget _buildPlacesSearchList() {
    if (model!.placesSuggestionList!.isNotEmpty) {
      return Expanded(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: model?.placesSuggestionList!.length,
          itemBuilder: (context, index) {
            return SearchSuggestionItemList(
              size: model?.placesSuggestionList!.length,
              index: index,
              placeMarkSuggestion: model?.placesSuggestionList![index],
              onPlaceTap: () {
                context.read<LocationProvider>()
                  ..showSearchWidget(false)
                  ..updateChangeLocButton(true)
                  ..updateSelectedLocation(model!.placesSuggestionList?[index])
                  ..typeContext(1)
                  ..animateMapToLocation(
                      model?.currentLoc ?? const LatLng(0, 0),
                      mapController,
                      _googleMapController);

                setState(() {
                  _searchController.text = "";
                });

                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus &&
                    currentFocus.focusedChild != null) {
                  currentFocus.focusedChild!.unfocus();
                }
                context.read<LocationProvider>().clearPlacesListValues();
              },
            );
          },
          shrinkWrap: true,
          physics: const ScrollPhysics(),
        ),
      );
    }
    return Container();
  }

  Widget _noPlaceSuggestionFound() {
    return model!.placeList!.isEmpty &&
            _searchController.text.isNotEmpty &&
            !model!.placesIsLoading
        ? const Expanded(
            child: CommonErrorWidget(
              types: ErrorTypes.noMatchFound,
            ),
          )
        : Container();
  }

  Widget buildProceedBtnWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin:
              EdgeInsets.only(left: 15.w, right: 15.w, bottom: 16.h, top: 16.h),
          padding: EdgeInsets.all(2.w),
          child: Text(
            context.loc.confirmLocation,
            textAlign: TextAlign.start,
            maxLines: 1,
            style: FontStyle.bold14Black,
          ),
        ),
        ReusableWidgets.divider(),
        SizedBox(height: 25.h),
        buildCurrentLocChangeWidget(),
        buildProceedBtn(),
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.08,
        ),
      ],
    );
  }

  Widget buildProceedBtn() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0.w),
      child: CommonButton(
        buttonText: context.loc.confirmLocation,
        onPressed: () async {
          switch (widget.navFromState) {
            case NavFromState.navFromAccount:
              _searchController.text = "";
              context.read<LocationProvider>()
                ..typeContext(0)
                ..getParsedCoordinatesForMarker(
                    model?.selectedLoc?.lat ?? Constants.lat,
                    model?.selectedLoc?.long ?? Constants.lng,
                    context,
                    onButtonPressed: true,
                    fromAccountPage: true);
              break;
            case NavFromState.navFromSplash:
              await context.read<LocationProvider>().saveSavedUserLocation();
              Navigator.pushNamedAndRemoveUntil(
                  context, RouteGenerator.routeMain, (route) => false);
              break;
            case NavFromState.navFromCart:
              _searchController.text = "";
              await context.read<LocationProvider>().saveSavedUserLocation();
              context.read<LocationProvider>()
                ..typeContext(0)
                ..getParsedCoordinatesForMarker(
                    model?.selectedLoc?.lat ?? Constants.lat,
                    model?.selectedLoc?.long ?? Constants.lng,
                    context,
                    onButtonPressed: true,
                    fromAccountPage: false);
              break;

            default:
              await context.read<LocationProvider>().saveSavedUserLocation();
              Navigator.pop(context);
          }
        },
      ),
    );
  }

  Widget buildCurrentLocChangeWidget() {
    return Row(
      children: [
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(
              left: context.isArabic ? 0 : 15.w,
              right: context.isArabic ? 15.w : 0,
              bottom: 25.h),
          padding: EdgeInsets.all(2.w),
          child: Icon(
            Icons.location_on,
            color: HexColor("#FF9230"),
            size: 20,
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(
                left: context.isArabic ? 0 : 8.w,
                right: context.isArabic ? 8.w : 0,
                bottom: 25.h),
            padding: EdgeInsets.all(2.w),
            child: Text(
              model?.selectedLoc!.name ?? "",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: FontStyle.black14Normal,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Helpers.isInternetAvailable().then((value) {
              if (value) {
                if (model?.currentLoc != null &&
                        model?.currentLoc!.longitude != null ||
                    model?.selectedLoc != null &&
                        model?.selectedLoc!.name != null) {
                  context.read<LocationProvider>()
                    ..showSearchWidget(true)
                    ..updateChangeLocButton(false);
                }
              } else {}
            });
          },
          child: Container(
            alignment: Alignment.center,
            height: 30,
            margin: EdgeInsets.only(left: 8.w, bottom: 25.h, right: 20.h),
            padding: EdgeInsets.all(2.w),
            child: Text(
              context.loc.change,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: FontStyle.primary14Medium,
            ),
          ),
        )
      ],
    );
  }

  Widget requestLocation(LocationProvider model) {
    return CommonErrorWidget(
      types: ErrorTypes.locationPermissionError,
      errorTitle: context.loc.oops,
      errorSubTitle: model.locationMsg,
      buttonText: model.showLocReqBtn
          ? context.loc.requestPermission
          : context.loc.retry,
      onTap: () {
        Future.microtask(() => context
            .read<LocationProvider>()
            .checkLocationPermission(context, mapController, _googleMapController,
                requestService: true, openDeviceSetting: true));
      },
    );
  }

  Future<bool> _willPopCallback() async {
    final locationProvider = context.read<LocationProvider>();
    if (locationProvider.showSearch) {
      locationProvider
        ..showSearchWidget(false)
        ..updateChangeLocButton(true)
        ..typeContext(0);
      setState(() {
        _searchController.text = "";
      });
      return false;
    } else {
      return true;
    }
  }

  Widget searchCloseButton(String titleText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            margin: EdgeInsets.only(
                top: 25.h,
                left: AppData.appLocale == 'ar' ? 0 : 15.w,
                right: AppData.appLocale == 'ar' ? 15.w : 0),
            child: Padding(
              child: Text(
                titleText,
                style: FontStyle.black14Medium,
              ),
              padding: EdgeInsets.all(5.w),
            )),
        InkWell(
          onTap: () {
            context.read<LocationProvider>()
              ..showSearchWidget(false)
              ..updateChangeLocButton(true)
              ..typeContext(0);
            setState(() {
              _searchController.text = "";
            });
          },
          child: Container(
              margin: EdgeInsets.only(
                  top: 25.h,
                  right: AppData.appLocale == 'ar' ? 0 : 15.w,
                  left: AppData.appLocale == 'ar' ? 15.w : 0),
              child: Padding(
                child: Text(
                  context.loc.close,
                  style: FontStyle.primary14Medium,
                ),
                padding: EdgeInsets.all(5.w),
              )),
        )
      ],
    );
  }

  Widget _buildListLoader() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
            padding: EdgeInsets.all(10.w),
            margin: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.location_on_outlined,
                        color: HexColor("#BDBDBD"),
                      ),
                      margin: EdgeInsets.only(bottom: 5.h),
                    )
                  ],
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 13,
                        margin: EdgeInsets.only(bottom: 5.h),
                        child: Container(
                          color: Colors.black26,
                          width: MediaQuery.of(context).size.width * 0.64,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(width: 15)
              ],
            ));
      },
      shrinkWrap: true,
      physics: const ScrollPhysics(),
    );
  }

  void onMapCreated(GoogleMapController controller) async {
    _googleMapController = controller;
    if (!mapController!.isCompleted) mapController!.complete(controller);
    MarkerId markerId = MarkerId(_markerIdVal());
    Marker marker = Marker(
      infoWindow: const InfoWindow(
          snippet: "Please place the pin accurately on the map",
          title: "Your order will be delivered here"),
      markerId: markerId,
      position: model?.selectedLoc != null
          ? LatLng(model?.selectedLoc?.lat ?? Constants.lat,
              model?.selectedLoc?.long ?? Constants.lng)
          : LatLng(model?.currentLoc?.latitude ?? Constants.lat,
              model?.currentLoc?.longitude ?? Constants.lng),
      draggable: false,
    );
    setState(() {
      markers[markerId] = marker;
      _searchController.text = "";
    });
    GoogleMapController _controller = await mapController!.future;
    if (_googleMapController != null) {
      _googleMapController!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: model?.selectedLoc != null
              ? LatLng(model?.selectedLoc?.lat ?? Constants.lat,
                  model?.selectedLoc?.long ?? Constants.lng)
              : LatLng(model?.currentLoc?.latitude ?? Constants.lat,
                  model?.currentLoc?.longitude ?? Constants.lng),
          zoom: 17.0,
        ),
      ));
    }
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: model?.selectedLoc != null
              ? LatLng(model?.selectedLoc?.lat ?? Constants.lat,
                  model?.selectedLoc?.long ?? Constants.lng)
              : LatLng(model?.currentLoc?.latitude ?? Constants.lat,
                  model?.currentLoc?.longitude ?? Constants.lng),
          zoom: 17.0,
        ),
      ),
    );
  }

  void onCameraIdle() {
    if (markers.isNotEmpty) {
      final marker = markers.values.toList()[0];
      Future.delayed(const Duration(milliseconds: 10)).then(
          (_) => _googleMapController?.showMarkerInfoWindow(marker.markerId));
      Future.microtask(() => context.read<LocationProvider>()
        ..typeContext(0)
        ..getParsedCoordinatesForMarker(
          marker.position.latitude,
          marker.position.longitude,
          context,
        ));
    }
  }

  void onCameraMove(CameraPosition position) {
    if (markers.isNotEmpty) {
      MarkerId? markerId = MarkerId(_markerIdVal());
      Marker? marker = markers[markerId];
      Marker updatedMarker = marker!.copyWith(
        positionParam: position.target,
      );
      if (mounted) {
        setState(() {
          markers[markerId] = updatedMarker;
        });
      }
    }
  }

  void _onChanged() {
    final locationProvider = context.read<LocationProvider>();
    Future.microtask(() => locationProvider.isPlaceLoading(true));
    if (_searchController.text.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 500)).then((_) =>
          locationProvider.getPlaceSuggestionList(
              _searchController.text, _searchController));
    } else {
      locationProvider.clearPlacesListValues();
    }
  }
}
