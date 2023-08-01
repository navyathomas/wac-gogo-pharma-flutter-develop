//     final loginSuccessModel = loginSuccessModelFromJson(jsonString);

import 'dart:convert';

LoginSuccessModel loginSuccessModelFromJson(String str) =>
    LoginSuccessModel.fromJson(json.decode(str));

String loginSuccessModelToJson(LoginSuccessModel data) =>
    json.encode(data.toJson());

class LoginSuccessModel {
  LoginSuccessModel({
    this.data,
  });

  Data? data;

  factory LoginSuccessModel.fromJson(Map<String, dynamic> json) =>
      LoginSuccessModel(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data!.toJson(),
      };
}

class Data {
  Data({
    this.loginUsingOtp,
  });

  LoginUsingOtp? loginUsingOtp;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        loginUsingOtp: LoginUsingOtp.fromJson(json["loginUsingOtp"]),
      );

  Map<String, dynamic> toJson() => {
        "loginUsingOtp": loginUsingOtp!.toJson(),
      };
}

class LoginUsingOtp {
  LoginUsingOtp({
    this.token,
    this.typename,
  });

  String? token;
  String? typename;

  factory LoginUsingOtp.fromJson(Map<String, dynamic> json) => LoginUsingOtp(
        token: json["token"],
        typename: json["__typename"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "__typename": typename,
      };
}
