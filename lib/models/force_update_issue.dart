import '../services/helpers.dart';

class ForceUpdateModel {
  ForceUpdate? forceUpdate;

  ForceUpdateModel({this.forceUpdate});

  ForceUpdateModel.fromJson(Map<String, dynamic> json) {
    forceUpdate = json['force_update'] != null
        ? ForceUpdate.fromJson(json['force_update'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (forceUpdate != null) {
      data['force_update'] = forceUpdate!.toJson();
    }
    return data;
  }
}

class ForceUpdate {
  int? androidVersion;
  bool? enabled;
  int? iosVersion;

  ForceUpdate({this.androidVersion, this.enabled, this.iosVersion});

  ForceUpdate.fromJson(Map<String, dynamic> json) {
    androidVersion = Helpers.convertToInt(json['android_version']);
    enabled = json['enabled'];
    iosVersion = Helpers.convertToInt(json['ios_version']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['android_version'] = androidVersion;
    data['enabled'] = enabled;
    data['ios_version'] = iosVersion;
    return data;
  }
}
