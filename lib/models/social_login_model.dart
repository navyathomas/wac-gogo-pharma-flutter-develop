//     final socialLoginModel = socialLoginModelFromJson(jsonString);

import 'dart:convert';

SocialLoginModel socialLoginModelFromJson(String str) =>
    SocialLoginModel.fromJson(json.decode(str));

String socialLoginModelToJson(SocialLoginModel data) =>
    json.encode(data.toJson());

class SocialLoginModel {
  SocialLoginModel({
    this.typename,
    this.socialLoginRegistration,
  });

  String? typename;
  SocialLoginRegistration? socialLoginRegistration;

  factory SocialLoginModel.fromJson(Map<String, dynamic> json) =>
      SocialLoginModel(
        typename: json["__typename"],
        socialLoginRegistration: json["socialLoginRegistration"] != null
            ? SocialLoginRegistration.fromJson(json["socialLoginRegistration"])
            : null,
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['__typename'] = typename;
    if (socialLoginRegistration != null) {
      data['socialLoginRegistration'] = socialLoginRegistration!.toJson();
    }
    return data;
  }
}

class SocialLoginRegistration {
  SocialLoginRegistration({
    this.typename,
    this.token,
  });

  String? typename;
  String? token;

  factory SocialLoginRegistration.fromJson(Map<String, dynamic> json) =>
      SocialLoginRegistration(
        typename: json["__typename"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "__typename": typename,
        "token": token,
      };
}
