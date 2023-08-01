import 'package:fluttertoast/fluttertoast.dart';

void showToast([
  msg,
]) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    fontSize: 14.0,
  );
}
