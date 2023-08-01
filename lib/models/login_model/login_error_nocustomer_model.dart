// final loginErrorNoCustomerModel = loginErrorNoCustomerModelFromJson(jsonString);

import 'dart:convert';

LoginErrorNoCustomerModel loginErrorNoCustomerModelFromJson(String str) =>
    LoginErrorNoCustomerModel.fromJson(json.decode(str));

String loginErrorNoCustomerModelToJson(LoginErrorNoCustomerModel data) =>
    json.encode(data.toJson());

class LoginErrorNoCustomerModel {
  LoginErrorNoCustomerModel({
    this.errors,
    this.data,
  });

  List<Error>? errors;
  Data? data;

  factory LoginErrorNoCustomerModel.fromJson(Map<String, dynamic> json) =>
      LoginErrorNoCustomerModel(
        errors: List<Error>.from(json["errors"].map((x) => Error.fromJson(x))),
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "errors": List<dynamic>.from(errors!.map((x) => x.toJson())),
        "data": data!.toJson(),
      };
}

class Data {
  Data({
    this.loginUsingOtp,
  });

  dynamic loginUsingOtp;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        loginUsingOtp: json["loginUsingOtp"],
      );

  Map<String, dynamic> toJson() => {
        "loginUsingOtp": loginUsingOtp,
      };
}

class Error {
  Error({
    this.message,
    this.extensions,
    this.locations,
    this.path,
  });

  String? message;
  Extensions? extensions;
  List<Location>? locations;
  List<String>? path;

  factory Error.fromJson(Map<String, dynamic> json) => Error(
        message: json["message"],
        extensions: Extensions.fromJson(json["extensions"]),
        locations: List<Location>.from(
            json["locations"].map((x) => Location.fromJson(x))),
        path: List<String>.from(json["path"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "extensions": extensions!.toJson(),
        "locations": List<dynamic>.from(locations!.map((x) => x.toJson())),
        "path": List<dynamic>.from(path!.map((x) => x)),
      };
}

class Extensions {
  Extensions({
    this.category,
  });

  String? category;

  factory Extensions.fromJson(Map<String, dynamic> json) => Extensions(
        category: json["category"],
      );

  Map<String, dynamic> toJson() => {
        "category": category,
      };
}

class Location {
  Location({
    this.line,
    this.column,
  });

  int? line;
  int? column;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        line: json["line"],
        column: json["column"],
      );

  Map<String, dynamic> toJson() => {
        "line": line,
        "column": column,
      };
}
