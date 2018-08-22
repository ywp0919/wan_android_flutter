import 'package:fluttertoast/fluttertoast.dart';

class ToastUtils {

  /// toast
  static showToast(String content) {
    Fluttertoast.showToast(
        msg: "$content",
        gravity: ToastGravity.CENTER,
        bgcolor: "#99000000",
        textcolor: '#ffffff');
  }
}
