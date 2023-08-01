import 'package:flutter/material.dart';
import 'package:gogo_pharma/common/constants.dart';
import 'package:gogo_pharma/common/validation_helper.dart';

import '../common/check_function.dart';
import '../services/firebase_dynamic_link_sevices.dart';
import '../services/helpers.dart';
import '../services/provider_helper_class.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountProvider extends ChangeNotifier with ProviderHelperClass {
  String inviteLink = '';
  String errorMsg = '';
  bool btnLoader = false;
  Future<void> getInviteLink() async {
    updateLoadState(LoaderState.loading);
    final network = await Helpers.isInternetAvailable();
    if (network) {
      try {
        final _resp = await serviceConfig.getInviteLink();
        if (_resp['createInviteFriendLink'] != null) {
          updateInviteLink(_resp['createInviteFriendLink']);
          updateLoadState(LoaderState.loaded);
        } else {
          Check.checkException(_resp);
          updateLoadState(LoaderState.loaded);
        }
      } catch (e) {
        updateLoadState(LoaderState.error);
      }
    } else {
      updateLoadState(LoaderState.networkErr);
    }
  }

  @override
  void updateLoadState(LoaderState state) {
    loaderState = state;
    notifyListeners();
  }

  void updateInviteLink(val) {
    inviteLink = val;
    notifyListeners();
  }

  @override
  void pageInit() {
    loaderState = LoaderState.loading;
    inviteLink = '';
    errorMsg = '';
    btnLoader = false;
    notifyListeners();
  }

  void updateErrorMsg(val) {
    errorMsg = val;
    notifyListeners();
  }

  void updateBtnLoader(val) {
    btnLoader = val;
    notifyListeners();
  }

  void validateInviteMail(BuildContext context, String mail) async {
    String? msg = ValidationHelper.validateEmail(context, mail);
    updateErrorMsg(msg ?? '');
    updateBtnLoader(true);
    String shareCode = await FirebaseDynamicLinkServices.instance
        .createInviteLink(url: inviteLink);
    if (msg == null) {
      sentToEmailId(email: mail.trim(), shareCode: shareCode)
          .then((value) => updateBtnLoader(false))
          .catchError((_) => updateBtnLoader(false));
    } else {
      updateBtnLoader(false);
    }
  }

  Future<void> sentToEmailId({String email = '', String shareCode = ''}) async {
    final Uri _emailLaunchUri =
        Uri(scheme: 'mailto', path: email, queryParameters: {
      'subject': 'Check\tout\tGogo\tPharma\twith\tme',
      'body':
          'Hey\tI\'m\tinviting\tyou\tto\tGogo\tPharma,\tJoin\tnow\tby\tdownloading\tand\tregistering\tin\tthe\tapp\tby\tclicking\tthe\tfollowing\tlink.\n$shareCode'
    });
    if (await canLaunchUrl(_emailLaunchUri)) {
      await launchUrl(_emailLaunchUri);
    } else {
      throw 'Could not launch $_emailLaunchUri';
    }
  }
}
