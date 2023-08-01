import 'package:gogo_pharma/common/const.dart';
import 'package:gogo_pharma/models/product_listing_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ReusableFunctions {
  static bool checkDiscount(MaximumPrice? maximumPrice) {
    bool res = true;
    if ((maximumPrice?.discount?.percentOff ?? 0) == 0) {
      res = false;
    }
    return res;
  }

  static void launchApp(String _url) async {
    final Uri url =
        Uri.parse(_url);
    try {
      if (!await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      )) {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print(e);
    }
  }
}
