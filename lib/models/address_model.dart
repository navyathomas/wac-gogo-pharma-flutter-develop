import 'package:gogo_pharma/services/helpers.dart';

class RegionList {
  List<AvailableRegions>? availableRegions;

  RegionList({this.availableRegions});

  RegionList.fromJson(Map<String, dynamic> json) {
    if (json['available_regions'] != null) {
      availableRegions = <AvailableRegions>[];
      json['available_regions'].forEach((v) {
        availableRegions!.add(AvailableRegions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (availableRegions != null) {
      data['available_regions'] =
          availableRegions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AvailableRegions {
  String? code;
  int? id;
  String? name;

  AvailableRegions({this.code, this.id, this.name});

  AvailableRegions.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class RegionCountry {
  List<GetRegionCityList>? getRegionCityList;

  RegionCountry({this.getRegionCityList});

  RegionCountry.fromJson(Map<String, dynamic> json) {
    if (json['getRegionCityList'] != null) {
      getRegionCityList = <GetRegionCityList>[];
      json['getRegionCityList'].forEach((v) {
        getRegionCityList!.add(GetRegionCityList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (getRegionCityList != null) {
      data['getRegionCityList'] =
          getRegionCityList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetRegionCityList {
  int? id;
  String? label;
  String? value;

  GetRegionCityList({this.id, this.label});

  GetRegionCityList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['label'] = label;
    data['value'] = value;
    return data;
  }
}

class FetchAddress {
  List<Addresses>? addresses;

  FetchAddress({this.addresses});

  FetchAddress.fromJson(Map<String, dynamic> json) {
    if (json['addresses'] != null) {
      addresses = <Addresses>[];
      json['addresses'].forEach((v) {
        addresses!.add(Addresses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (addresses != null) {
      data['addresses'] = addresses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Addresses {
  int? id;
  String? city;
  String? countryCode;
  String? countryName;
  bool? defaultBilling;
  bool? defaultShipping;
  String? firstname;
  String? lastname;
  String? name;
  List<String>? street;
  String? telephone;
  int? typeOfAddress;
  String? area;
  double? latitude;
  double? longitude;
  Region? region;

  Addresses(
      {this.id,
      this.city,
      this.countryCode,
      this.countryName,
      this.defaultBilling,
      this.defaultShipping,
      this.firstname,
      this.lastname,
      this.street,
      this.name,
      this.telephone,
      this.typeOfAddress,
      this.area,
      this.latitude,
      this.longitude});

  Addresses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    city = json['city'];
    countryCode = json['country_code'];
    countryName = json['country_name'];
    defaultBilling = json['default_billing'];
    defaultShipping = json['default_shipping'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    name = '${firstname ?? ''} ${lastname ?? ''}';
    street = json['street'].cast<String>();
    telephone = json['telephone'];
    typeOfAddress = json['type_of_address'];
    area = json['area'];
    latitude = Helpers.convertToDouble(json['latitude']);
    longitude = Helpers.convertToDouble(json['longitude']);
    region = json['region'] != null ? Region.fromJson(json['region']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['city'] = city;
    data['country_code'] = countryCode;
    data['country_name'] = countryName;
    data['default_billing'] = defaultBilling;
    data['default_shipping'] = defaultShipping;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['street'] = street;
    data['telephone'] = telephone;
    data['type_of_address'] = typeOfAddress;
    data['area'] = area;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    if (region != null) {
      data['region'] = region!.toJson();
    }
    return data;
  }
}

class Region {
  String? regionCode;
  String? region;

  Region({this.regionCode, this.region});

  Region.fromJson(Map<String, dynamic> json) {
    regionCode = json['region_code'];
    region = json['region'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['region_code'] = regionCode;
    data['region'] = region;
    return data;
  }
}
