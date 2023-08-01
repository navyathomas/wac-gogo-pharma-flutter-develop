import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:gogo_pharma/common/const.dart';
import 'package:gogo_pharma/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class RemoteConfigServices {
  static RemoteConfigServices? _instance;
  late final FirebaseRemoteConfig _remoteConfig;

  static RemoteConfigServices get instance {
    _instance ??= RemoteConfigServices();
    return _instance!;
  }

  Future<void> fetchRemoteConfigValue(BuildContext context) async {
    _remoteConfig = FirebaseRemoteConfig.instance;
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: Duration.zero,
    ));
    await _remoteConfig.ensureInitialized();
    await _remoteConfig.fetchAndActivate();

    bool isGoogleLogin = _remoteConfig.getBool(Const.googleSign);
    Provider.of<AuthProvider>(context, listen: false)
        .setGoogleButtonStatus(isGoogleLogin);
  }

  void dispose() {
    _remoteConfig.dispose();
  }
}
