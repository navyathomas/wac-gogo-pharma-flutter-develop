import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:gogo_pharma/common/const.dart';
import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/common/extensions.dart';
import 'package:gogo_pharma/common/route_generator.dart';
import 'package:gogo_pharma/models/address_model.dart';
import 'package:gogo_pharma/providers/order_summary_provider.dart';
import 'package:gogo_pharma/services/helpers.dart';
import 'package:gogo_pharma/services/provider_helper_class.dart';
import 'package:gogo_pharma/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';

import '../common/check_function.dart';
import '../services/app_config.dart';
import 'cart_provider.dart';

class AddressProvider extends ChangeNotifier with ProviderHelperClass {
  RegionList? regionList;
  RegionCountry? regionCountry;
  GetRegionCityList? selectedCityName;
  AvailableRegions? selectedRegionName;
  bool isDefaultAddressSelected = false;
  FetchAddress? fetchAddress;
  Addresses? address;
  bool isHomeSelected = true;
  bool isOfficeSelected = false;
  int addressType = 0;
  bool isButtonLoading = false;

  Future<void> getAvailableRegions(
      bool isEdit, String prefilledRegionCode, String prefilledCityName) async {
    updateLoadState(LoaderState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic _resp = await serviceConfig.getAvailableRegions();
        if (_resp['country'] != null) {
          RegionList _regionList = RegionList.fromJson(_resp['country']);
          setRegion(_regionList, isEdit, prefilledRegionCode);
          selectedRegionName?.code != null
              ? await getRegionCityList(
                  isEdit: isEdit, prefilledCityName: prefilledCityName)
              : null;
          updateLoadState(LoaderState.loaded);
        } else {
          updateLoadState(LoaderState.loaded);
        }
      } catch (e) {
        log('$e', name: 'availableRegions');
        updateLoadState(LoaderState.error);
      }
    } else {
      updateLoadState(LoaderState.networkErr);
    }
  }

  Future<void> getRegionCityList(
      {bool isEdit = false, String? prefilledCityName}) async {
    updateLoadState(LoaderState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic _resp =
            await serviceConfig.getRegionCityList(selectedRegionName!.code!);
        if (_resp != null) {
          RegionCountry _regionCountryList = RegionCountry.fromJson(_resp);
          setRegionCity(_regionCountryList, isEdit, prefilledCityName);
          updateLoadState(LoaderState.loaded);
        } else {
          updateLoadState(LoaderState.loaded);
        }
      } catch (e) {
        log('$e', name: 'regionCity');
        updateLoadState(LoaderState.error);
      }
    } else {
      updateLoadState(LoaderState.networkErr);
    }
  }

  Future<void> getAddressList(BuildContext context,
      {Function(bool val)? noAddress,
      bool popLoaderStatus = false,
      bool initial = false}) async {
    updateLoadState(LoaderState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic _resp = await serviceConfig.fetchCustomerAddressList();
        if (_resp != null) {
          if (_resp['status'] == 'error') {
            Check.checkException(
              _resp,
              onError: (val) {
                if (val ?? false) updateLoadState(LoaderState.error);
              },
              onCartIdExpired: (val) {
                if (val ?? false) updateLoadState(LoaderState.error);
              },
              onAuthError: (val) {
                if (val) updateLoadState(LoaderState.error);
              },
            );
            if (popLoaderStatus) context.rootPop();
            updateLoadState(LoaderState.loaded);
          } else {
            if (_resp['customer'] != null) {
              FetchAddress fetchAddress =
                  FetchAddress.fromJson(_resp['customer']);
              setAddressList(fetchAddress);
              if (fetchAddress.addresses == null ||
                  fetchAddress.addresses!.isEmpty) {
                if (noAddress != null) noAddress(true);
              } else {
                if (fetchAddress.addresses!.length == 1 &&
                    address == null &&
                    initial) {
                  updateDefaultCustomerAddress(
                      id: fetchAddress.addresses?.first.id ?? -1,
                      context: context,
                      navFromState: NavFromState.navFromCart,
                      defaultAddress: false);
                }
                if (popLoaderStatus) {
                  context.rootPop();
                  Navigator.pushNamed(
                      context, RouteGenerator.routeSelectAddressScreen);
                }
              }
              updateLoadState(LoaderState.loaded);
            } else {
              if (popLoaderStatus) context.rootPop();
              updateLoadState(LoaderState.loaded);
            }
          }
        }
      } catch (e, stackTrace) {
        print(stackTrace);
        log('$e', name: 'fetchAddress');
        if (popLoaderStatus) context.rootPop();
        updateLoadState(LoaderState.error);
      }
    } else {
      if (popLoaderStatus) context.rootPop();
      updateLoadState(LoaderState.networkErr);
    }
  }

  Future<void> addAddress(BuildContext context,
      {required String fullName,
      required String mobileNumber,
      required String apartment,
      required String area,
      required double latitude,
      required double longitude,
      NavFromState navFromState = NavFromState.navFromAccount}) async {
    updateIsButtonLoading(true);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic _resp = await serviceConfig.addAddress(
            fullName: fullName,
            mobileNumber: mobileNumber,
            apartment: apartment,
            city: selectedCityName!.value,
            area: area,
            regionCode: selectedRegionName!.code,
            addressType: addressType,
            billing: isDefaultAddressSelected,
            shipping: isDefaultAddressSelected,
            latitude: latitude,
            longitude: longitude);
        if (_resp != null && _resp['createCustomerAddress'] != null) {
          if (_resp['createCustomerAddress']['id'] != null) {
            await getAddressList(context);
            Helpers.successToast(context.loc.addedAddress);
            //Used this condition to pop multiple screens when address added from selectAddress page
            if (AppData.navFromState == NavFromState.navFromSelectAddress) {
              Navigator.of(context).pop();
            }
            navFromState == NavFromState.navFromAccount
                ? Navigator.pushReplacementNamed(
                    context, RouteGenerator.routeSelectAddressScreen)
                : context.read<OrderSummaryProvider>().switchAddressPage(0);
            notifyListeners();
          }
          updateIsButtonLoading(false);
        } else {
          updateIsButtonLoading(false);
        }
      } catch (e) {
        log('$e', name: 'addAddress');
        updateIsButtonLoading(false);
      }
    } else {
      updateIsButtonLoading(false);
    }
  }

  Future<void> editAddress(BuildContext context,
      {int? addressId,
      required String fullName,
      required String mobileNumber,
      required String apartment,
      required String area,
      required double latitude,
      required double longitude,
      NavFromState navFromState = NavFromState.navFromAccount}) async {
    ///Todo: Need to discuss number country code issue with rahees and Febin

    updateIsButtonLoading(true);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic _resp = await serviceConfig.editAddress(
            addressId: addressId,
            fullName: fullName,
            mobileNumber: mobileNumber,
            apartment: apartment,
            city: selectedCityName!.value,
            area: area,
            regionCode: selectedRegionName!.code,
            addressType: addressType,
            billing: isDefaultAddressSelected,
            shipping: isDefaultAddressSelected,
            latitude: latitude,
            longitude: longitude);
        if (_resp != null && _resp['updateCustomerAddress'] != null) {
          if (_resp['updateCustomerAddress'] != null) {
            updateAddressSelected(null);
            await getAddressList(context);
            Helpers.successToast(context.loc.editedAddress);
            navFromState == NavFromState.navFromAccount
                ? context.rootPop()
                : context.read<OrderSummaryProvider>().switchAddressPage(0);

            notifyListeners();
          }
          updateIsButtonLoading(false);
        } else {
          updateIsButtonLoading(false);
        }
      } catch (e) {
        log('$e', name: 'addAddress');
        updateIsButtonLoading(false);
      }
    } else {
      updateIsButtonLoading(false);
    }
  }

  Future<void> deleteAddress(int addressId, BuildContext context,
      {NavFromState navFromState = NavFromState.navFromAccount}) async {
    updateLoadState(LoaderState.loading);
    updateAddressSelected(null);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        dynamic _resp = await serviceConfig.deleteAddress(addressId);
        if (_resp != null) {
          if (_resp['status'] == 'error') {
            Helpers.errorToast(_resp['message']);
            updateLoadState(LoaderState.loaded);
          } else {
            if (_resp != null && _resp['deleteCustomerAddress'] != null) {
              if (_resp['deleteCustomerAddress'] == true) {
                await getAddressList(context, noAddress: (val) {
                  if (val && navFromState != NavFromState.navFromCart) {
                    Navigator.pushNamed(
                        context, RouteGenerator.routeSelectLocationScreen);
                  }
                });
                Helpers.errorToast(context.loc.removedAddress);
              }
              updateLoadState(LoaderState.loaded);
            } else {
              updateLoadState(LoaderState.loaded);
            }
          }
        }
      } catch (e) {
        log('$e', name: 'deleteAddress');
        updateLoadState(LoaderState.error);
      }
    } else {
      updateLoadState(LoaderState.networkErr);
    }
  }

  ///---------------Proceed to checkout ---------------

  Future<bool> proceedToCheckOut() async {
    bool resFlag = false;
    final shippingRes = await setShippingAddress();
    if (shippingRes) {
      final billingRes = await setBillingAddress();
      if (billingRes) {
        resFlag = true;
      }
    }
    return resFlag;
  }

  ///---------------set shipping address---------------
  Future<bool> setShippingAddress() async {
    bool flag = false;
    final val = await Helpers.isInternetAvailable();
    if (val) {
      try {
        if (address?.id != null) {
          dynamic _resp = await serviceConfig.setShippingAddress(AppData.cartId,
              addressId: address!.id!);
          if (_resp != null &&
              _resp?['setShippingAddressesOnCart']?['cart']
                      ?['shipping_addresses'] !=
                  null) {
            flag = true;
          } else {
            Check.checkException(_resp, onError: (value) {
              if (value != null && value) {
                flag = false;
              }
            });
          }
        }
      } catch (_) {
        flag = false;
        log('Set Shipping Address error');
      }
    } else {
      flag = false;
    }
    return flag;
  }

  ///---------------set shipping address---------------
  Future<bool> setBillingAddress() async {
    bool flag = false;
    final val = await Helpers.isInternetAvailable();
    if (val) {
      try {
        dynamic _resp = await serviceConfig.setBillingAddress(AppData.cartId,
            addressId: address!.id!);
        if (_resp != null &&
            _resp?['setBillingAddressOnCart']?['cart']?['billing_address'] !=
                null) {
          flag = true;
        } else {
          Check.checkException(_resp, onError: (value) {
            if (value != null && value) {
              flag = false;
            }
          });
        }
      } catch (_) {
        flag = false;
        log('Set Billing Address error');
      }
    } else {
      flag = false;
    }
    return flag;
  }

  ///----------- change default address -----------------
  Future<void> updateDefaultCustomerAddress(
      {required int id,
      required BuildContext context,
      required bool defaultAddress,
      required NavFromState navFromState,
      bool autoFetch = true}) async {
    updateLoadState(LoaderState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        final _resp = await serviceConfig.updateDefaultAddress(
            id: id, defaultAddress: !defaultAddress);
        if (_resp['updateCustomerAddress'] != null) {
          Addresses _addresses =
              Addresses.fromJson(_resp['updateCustomerAddress']);
          defaultAddress
              ? updateAddressSelected(null)
              : updateAddressSelected(_addresses);
          //     Helpers.successToast(context.loc.defaultAddressUpdated);
          await getAddressList(context);
          if (navFromState == NavFromState.navFromCart) {
            await context.read<CartProvider>().getCartData(context);
          }
          updateLoadState(LoaderState.loaded);
        } else {
          updateLoadState(LoaderState.loaded);
          updateAddressSelected(null);
          Check.checkException(_resp, onError: (value) {
            if (value != null && value) {
              updateLoadState(LoaderState.loaded);
            }
          });
        }
      } catch (_) {
        updateLoadState(LoaderState.loaded);
        log('update Default Customer Address error');
      }
    } else {
      updateLoadState(LoaderState.loaded);
    }
  }

  void setRegion(
      RegionList _regionList, bool isEdit, String? prefilledRegionCode) {
    regionList = _regionList;
    if (regionList?.availableRegions != null &&
        regionList!.availableRegions!.isNotEmpty) {
      if (isEdit && prefilledRegionCode != null) {
        for (var i = 0; i < regionList!.availableRegions!.length; i++) {
          if (prefilledRegionCode == regionList!.availableRegions![i].code) {
            selectedRegionName = regionList!.availableRegions![i];
          } else {
            print("No region matches");
          }
        }
      }
    }
    notifyListeners();
  }

  void setRegionCity(
      RegionCountry _regionCountry, bool isEdit, String? prefilledCityName) {
    regionCountry = _regionCountry;
    if (regionCountry?.getRegionCityList != null &&
        regionCountry!.getRegionCityList!.isNotEmpty) {
      if (isEdit && prefilledCityName != null) {
        for (var i = 0; i < regionCountry!.getRegionCityList!.length; i++) {
          if (prefilledCityName == regionCountry!.getRegionCityList![i].label) {
            selectedCityName = regionCountry!.getRegionCityList![i];
          }
        }
      }
    }
    notifyListeners();
  }

  void setAddressList(FetchAddress _fetchAddress) {
    if (_fetchAddress.addresses != null &&
        _fetchAddress.addresses!.isNotEmpty) {
      try {
        address = _fetchAddress.addresses!
            .firstWhere((element) => (element.defaultShipping ?? false));
      } catch (_) {
        address = null;
        log('Default Address error');
      }
    }
    fetchAddress = _fetchAddress;
    notifyListeners();
  }

  void onRegionChanged(AvailableRegions? regionSelected) {
    selectedRegionName = regionSelected;
    notifyListeners();
  }

  void onCityChanged(GetRegionCityList? citySelected) {
    selectedCityName = citySelected;
    notifyListeners();
  }

  void checkDefaultAddressSelected() {
    isDefaultAddressSelected = !isDefaultAddressSelected;
    notifyListeners();
  }

  void editDefaultAddressSelected(bool value) {
    isDefaultAddressSelected = value;
    notifyListeners();
  }

  void updateAddressSelected(val) {
    address = val;
    notifyListeners();
  }

  void updateHomeSelected() {
    isHomeSelected = !isHomeSelected;
    if (isHomeSelected == true) {
      addressType = 0;
      isOfficeSelected = false;
    } else {
      addressType = 1;
      isOfficeSelected = true;
    }
    notifyListeners();
  }

  void updateOfficeSelected() {
    isOfficeSelected = !isOfficeSelected;
    if (isOfficeSelected == true) {
      addressType = 1;
      isHomeSelected = false;
    } else {
      addressType = 0;
      isHomeSelected = true;
    }
    notifyListeners();
  }

  void editHomeOfficeValue(bool home, bool office) {
    isHomeSelected = home;
    isOfficeSelected = office;
    notifyListeners();
  }

  void init(bool isDefault) {
    selectedCityName = null;
    selectedRegionName = null;
    isDefaultAddressSelected = isDefault;
    isHomeSelected = true;
    regionCountry = null;
    notifyListeners();
  }

  @override
  void pageInit() {
    address = null;
    fetchAddress = null;
    loaderState = LoaderState.loading;
    notifyListeners();
  }

  void updateIsButtonLoading(bool val) {
    isButtonLoading = val;
    notifyListeners();
  }

  @override
  void updateLoadState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }
}
