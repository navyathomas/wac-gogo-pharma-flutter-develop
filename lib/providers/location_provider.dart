import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gogo_pharma/common/const.dart';
import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/route_generator.dart';
import 'package:gogo_pharma/models/geocoding_response_model.dart';
import 'package:gogo_pharma/models/place_mark_suggestion_model.dart';
import 'package:gogo_pharma/models/route_arguments.dart';
import 'package:gogo_pharma/services/app_config.dart';
import 'package:gogo_pharma/services/helpers.dart';
import 'package:gogo_pharma/services/shared_preference_helper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/provider_helper_class.dart';
import 'package:location/location.dart' as loc;
import 'package:http/http.dart' as http;

class LocationProvider extends ChangeNotifier with ProviderHelperClass {
  bool showSearch = false;
  bool showLocReqBtn = true;
  bool serviceEnabled = false;
  bool isLocationEnabled = true;
  bool placesIsLoading = false;
  bool isChangeLocEnabled = true;
  bool checkPermission = false;

  int tapContextType = 0;
  LatLng? currentLoc;
  Position? position;
  String locationMsg = '';
  GoogleMapController? googleMapController;
  Completer<GoogleMapController>? mapController;
  PlaceMarkSuggestion? selectedLoc;
  List<dynamic>? placeList = [];
  List<PlaceMarkSuggestion>? placesSuggestionList = [];
  TextEditingController searchController = TextEditingController();
  String savedUserLocation = '';
  double? savedUserLatitude;
  double? savedUserLongitude;

  checkLocationPermission(
      BuildContext context,
      Completer<GoogleMapController>? mapController,
      GoogleMapController? _googleMapController,
      {bool requestService = false,
      bool openDeviceSetting = false}) async {
    updateLoadState(LoaderState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic status = await Permission.location.request();
        if (status == PermissionStatus.granted) {
          showLocReqBtn = false;
          checkServiceEnabled(context, mapController, _googleMapController,
              requestService: requestService);
          updateLoadState(LoaderState.loaded);
        } else if (status == PermissionStatus.denied) {
          showLocReqBtn = true;
          isLocationEnabled = false;
          locationMsg = context.loc.permissionDenied;
          updateLoadState(LoaderState.loaded);
        } else if (status == PermissionStatus.permanentlyDenied) {
          isLocationEnabled = false;
          showLocReqBtn = true;
          locationMsg = context.loc.permissionDeniedPermanently;
          if (serviceEnabled || openDeviceSetting) {
            AppSettings.openDeviceSettings().then((value) {
              updateCheckPermission(true);
            });
          }
          updateLoadState(LoaderState.loaded);
        }
        notifyListeners();
      } catch (e) {
        log('$e', name: 'permissionError');
        updateLoadState(LoaderState.error);
      }
    } else {
      updateLoadState(LoaderState.networkErr);
    }
  }

  checkServiceEnabled(
      BuildContext context,
      Completer<GoogleMapController>? mapController,
      GoogleMapController? _googleMapController,
      {bool requestService = false}) async {
    updateLoadState(LoaderState.loading);
    loc.Location location = loc.Location();
    final network = await Helpers.isInternetAvailable();
    final service = await Helpers.isLocationServiceEnabled();
    if (network) {
      try {
        if (!service) {
          isLocationEnabled = false;
          showLocReqBtn = false;
          locationMsg = context.loc.serviceDisabled;
          if (requestService) {
            serviceEnabled = await location.requestService();
            if (!serviceEnabled) {
              isLocationEnabled = false;
              showLocReqBtn = false;
              locationMsg = context.loc.serviceDisabled;
              updateLoadState(LoaderState.loaded);
            } else {
              isLocationEnabled = true;
              serviceEnabled = true;
              getLocation(mapController, _googleMapController);
              updateLoadState(LoaderState.loaded);
            }
          }
          updateLoadState(LoaderState.loaded);
        } else {
          isLocationEnabled = true;
          serviceEnabled = requestService;
          getLocation(mapController, _googleMapController);
          updateLoadState(LoaderState.loaded);
        }
      } catch (e) {
        log('$e', name: 'gpsError');
        updateLoadState(LoaderState.error);
      }
    } else {
      updateLoadState(LoaderState.networkErr);
    }
  }

  getLocation(Completer<GoogleMapController>? mapController,
      GoogleMapController? _googleMapController) async {
    updateLoadState(LoaderState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.bestForNavigation);
        if (position != null) {
          showLocReqBtn = false;
          isLocationEnabled = true;
          if (AppData.navFromState == NavFromState.navFromCart ||
              AppData.navFromState == NavFromState.navFromHome) {
            currentLoc = LatLng(savedUserLatitude ?? Constants.lat,
                savedUserLongitude ?? Constants.lng);
          } else {
            currentLoc = LatLng(position?.latitude ?? Constants.lat,
                position?.longitude ?? Constants.lng);
          }
          setCurrentLoc(
              currentLoc ?? const LatLng(Constants.lat, Constants.lng));
          animateMapToLocation(
              currentLoc ?? const LatLng(Constants.lat, Constants.lng),
              mapController,
              _googleMapController);
          updateLoadState(LoaderState.loaded);
          notifyListeners();
        }
      } catch (e) {
        log('$e', name: 'getLocationError');
        updateLoadState(LoaderState.error);
      }
    } else {
      updateLoadState(LoaderState.networkErr);
    }
  }

  animateMapToLocation(
      LatLng _currentLoc,
      Completer<GoogleMapController>? mapController,
      GoogleMapController? _googleMapController) async {
    GoogleMapController _controller = await mapController!.future;
    if (_googleMapController != null) {
      _googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: LatLng(_currentLoc.latitude, _currentLoc.longitude),
          zoom: 17.0,
        ),
      ));
    }
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(_currentLoc.latitude, _currentLoc.longitude),
          zoom: 17.0,
        ),
      ),
    );
    googleMapController = _googleMapController;
    notifyListeners();
  }

  void setCurrentLoc(LatLng currentLoc) async {
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        List<Placemark> placeMarks = await placemarkFromCoordinates(
            currentLoc.latitude, currentLoc.longitude);
        if (placeMarks.isNotEmpty) {
          Placemark? placeMark = placeMarks[0];
          selectedLoc = PlaceMarkSuggestion(
              placeMark.name ?? "",
              currentLoc.latitude,
              currentLoc.longitude,
              placeMark.subLocality ?? " ",
              placeMark.locality ?? " ",
              placeMark.street ?? '');
        }
        isChangeLocEnabled = true;
        updateLoadState(LoaderState.loaded);
      } catch (e) {
        getPlaceFromApi(currentLoc.latitude, currentLoc.longitude);
        log('$e', name: 'setCurrentLoc Error');
        updateLoadState(LoaderState.error);
      }
    } else {
      updateLoadState(LoaderState.networkErr);
    }
  }

  void getPlaceSuggestionList(
      String input, TextEditingController _searchController) async {
    try {
      String request =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input'
          '&location=${currentLoc?.latitude},${currentLoc?.longitude}&sensor=true&key=${AppData.apiKey}&components=country:AE';
      var response = await http.get(Uri.parse(request));

      if (response.statusCode == 200) {
        placeList = json.decode(response.body)['predictions'];
        if (placeList != null && placeList!.isNotEmpty) {
          setPlacesSuggestionList(placeList!);
        } else {
          isPlaceLoading(false);
          clearPlacesListValues();
        }
      } else {
        throw Exception('Failed to load predictions');
      }
    } catch (e) {
      log('$e', name: 'suggestionList Error');
    }
  }

  void setPlacesSuggestionList(List<dynamic> placeList) async {
    placesSuggestionList!.clear();
    if (placeList.isNotEmpty) {
      final geoCoding = GoogleMapsGeocoding(apiKey: AppData.apiKey);
      for (int i = 0; i < placeList.length; i++) {
        try {
          final response =
              await geoCoding.searchByPlaceId(placeList[i]['place_id']);
          if (response.results.isNotEmpty) {
            final name =
                placeList[i] != null ? placeList[i]['description'] ?? "" : "";

            PlaceMarkSuggestion suggestion = PlaceMarkSuggestion(
                name.toString(),
                response.results[0].geometry.location.lat,
                response.results[0].geometry.location.lng,
                null,
                null,
                response.results[0].formattedAddress);
            placesSuggestionList!.add(suggestion);
          }
          notifyListeners();
        } catch (err) {
          log("$err", name: '');
        }
      }
      isPlaceLoading(false);
      notifyListeners();
    }
  }

  void getParsedCoordinatesForMarker(
      double lat, double long, BuildContext context,
      {bool onButtonPressed = false, bool fromAccountPage = true}) async {
    try {
      List<Placemark> placeMarks = await placemarkFromCoordinates(lat, long);
      Placemark? placeMark = placeMarks[0];
      setParsedCoordinatesForMarker(lat, long, false, context,
          placeMark: placeMark,
          onButtonPressed: onButtonPressed,
          fromAccountPage: fromAccountPage);
    } catch (e) {
      setParsedCoordinatesForMarker(lat, long, true, context,
          onButtonPressed: onButtonPressed, fromAccountPage: fromAccountPage);
    }
    notifyListeners();
  }

  void setParsedCoordinatesForMarker(
      double lat, double long, bool isPlaceMarkError, BuildContext context,
      {Placemark? placeMark,
      bool onButtonPressed = false,
      bool fromAccountPage = true}) {
    String name = "";
    String locality = "";
    String apartment = "";
    String subAdministrativeArea = "";
    String administrativeArea = "";

    if (tapContextType == 1) {
      if (selectedLoc != null && selectedLoc?.name != null) {
        name = selectedLoc?.name ?? '';
        apartment = selectedLoc?.apartment ?? '';
      }
      selectedLoc = PlaceMarkSuggestion(name, lat, long, "", "", apartment);
    } else if (tapContextType == 0) {
      if (isPlaceMarkError) {
        getPlaceFromApi(lat, long);
      } else {
        if (placeMark != null) {
          if (placeMark.name != null) {
            locality = placeMark.locality ?? '';
            subAdministrativeArea = placeMark.subAdministrativeArea ?? '';
            administrativeArea = placeMark.administrativeArea ?? '';

            name = placeMark.thoroughfare == ""
                ? (placeMark.name! + " " + locality)
                : placeMark.thoroughfare ?? '';
            // apartment = placeMark.street ?? '';
            apartment = ((placeMark.street ?? '') + " " +
                locality +" " +
                subAdministrativeArea +" " +
                administrativeArea);
          }
        }
        selectedLoc = PlaceMarkSuggestion(name, lat, long, "", "", apartment);
      }
    } else {
      name = "";
      apartment = '';
    }

    typeContext(0);
    if (onButtonPressed) {
      clearPlacesListValues();
      fromAccountPage
          ? Navigator.pushReplacementNamed(
              context, RouteGenerator.routeAddAddressScreen,
              arguments: RouteArguments(
                  latitude: selectedLoc?.lat,
                  longitude: selectedLoc?.long,
                  isEditAddress: false,
                  apartmentSelectedFromLocation: selectedLoc?.apartment))
          : Navigator.pop(
              context,
              RouteArguments(
                  latitude: selectedLoc?.lat,
                  longitude: selectedLoc?.long,
                  isEditAddress: false,
                  navFromState: NavFromState.navFromCart,
                  apartmentSelectedFromLocation: selectedLoc?.apartment));
    }
  }

  //PlaceMark package does not support for some devices,so google api is used to fetch address...
  void getPlaceFromApi(double currentLatitude, double currentLongitude) async {
    try {
      String request =
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=$currentLatitude,$currentLongitude&key=${AppData.apiKey}';
      var response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        GeocoderResModel _geocoderResModel =
            GeocoderResModel.fromJson(json.decode(response.body));
        if (_geocoderResModel.results != null &&
            _geocoderResModel.results!.isNotEmpty) {
          selectedLoc = PlaceMarkSuggestion(
              _geocoderResModel.results![0].addressComponents![0].longName ??
                  "",
              currentLatitude,
              currentLongitude,
              '',
              '',
              _geocoderResModel.results![0].formattedAddress ?? '');
          notifyListeners();
        }
      }
    } catch (e) {
      log('$e', name: 'placeId Error');
    }
  }

  void updateSelectedLocation(PlaceMarkSuggestion? placeMarkSuggestion) {
    currentLoc = LatLng(placeMarkSuggestion?.lat ?? Constants.lat,
        placeMarkSuggestion?.long ?? Constants.lng);
    selectedLoc = placeMarkSuggestion;
    notifyListeners();
  }

  void clearPlacesListValues() {
    placeList?.clear();
    placesSuggestionList!.clear();
    placeList = [];
    placesSuggestionList = [];
    notifyListeners();
  }

  void showSearchWidget(bool val) {
    showSearch = val;
    notifyListeners();
  }

  void isPlaceLoading(bool val) {
    placesIsLoading = val;
    notifyListeners();
  }

  void updateChangeLocButton(bool val) {
    isChangeLocEnabled = val;
    notifyListeners();
  }

  void typeContext(int val) {
    tapContextType = val;
    notifyListeners();
  }

  void updateCheckPermission(bool val) {
    checkPermission = val;
    notifyListeners();
  }

  Future<String> getSavedUserLocation() async {
    String loc = await SharedPreferencesHelper.getUserLocation();
    LatLongModel decodedData = LatLongModel.decodeString(loc);
    saveUserLatLng(decodedData);
    return loc;
  }

  Future<void> saveSavedUserLocation() async {
    LatLongModel longModel = LatLongModel(
        userLocation: selectedLoc?.name ?? '',
        userLatitude: selectedLoc?.lat,
        userLongitude: selectedLoc?.long);
    String encodedData =
        LatLongModel.encodeString(LatLongModel.toMap(longModel));
    await SharedPreferencesHelper.saveUserLocation(encodedData);
    saveUserLatLng(longModel);
  }

  void saveUserLatLng(LatLongModel longModel) {
    savedUserLocation = longModel.userLocation ?? '';
    savedUserLatitude = longModel.userLatitude;
    savedUserLongitude = longModel.userLongitude;
    notifyListeners();
  }

  @override
  void updateLoadState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }
}
