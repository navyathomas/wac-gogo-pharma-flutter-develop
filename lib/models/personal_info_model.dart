// To parse this JSON data, do
//
//     final personalInfoModel = personalInfoModelFromJson(jsonString);

import 'dart:convert';

import 'package:gogo_pharma/common/constants.dart';

PersonalInfoModel personalInfoModelFromJson(String str) =>
    PersonalInfoModel.fromJson(json.decode(str));

String personalInfoModelToJson(PersonalInfoModel data) =>
    json.encode(data.toJson());

class PersonalInfoModel {
  PersonalInfoModel({
    this.data,
  });

  Data? data;

  factory PersonalInfoModel.fromJson(Map<String, dynamic> json) =>
      PersonalInfoModel(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class Data {
  Data({
    this.customer,
  });

  Customer? customer;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        customer: Customer.fromJson(json["customer"]),
      );

  Map<String, dynamic> toJson() => {
        "customer": customer?.toJson(),
      };
}

class Customer {
  Customer({
    this.firstname,
    this.lastname,
    this.fullName,
    this.email,
    this.mobileNumber,
    this.gender,
    this.dateOfBirth,
  });

  String? firstname;
  String? lastname;
  String? fullName;
  String? email;
  String? mobileNumber;
  dynamic gender;
  dynamic dateOfBirth;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
      firstname: json["firstname"],
      lastname: json["lastname"],
      email: json["email"],
      mobileNumber: json["mobile_number"],
      gender: json["gender"],
      dateOfBirth: json["date_of_birth"],
      fullName: json["firstname"] ?? '' + json["lastname"] ?? '');

  Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "mobile_number": mobileNumber,
        "gender": gender,
        "date_of_birth": dateOfBirth,
      };

  Customer copyWith({
    String? firstname,
    String? lastname,
    String? email,
    String? mobileNumber,
    dynamic gender,
    dynamic dateOfBirth,
  }) =>
      Customer(
        firstname: firstname ?? this.firstname,
        lastname: lastname ?? this.lastname,
        email: email ?? this.email,
        mobileNumber: mobileNumber ?? this.mobileNumber,
        gender: gender ?? this.gender,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      );
}
