import 'dart:async';
import 'package:http/http.dart' as http;

///
/// 网络 请求 get post 工具类。
///
class HttpUtils {
  ///  get 请求
  static Future<String> get(String url, {Map<String, String> params}) async {
    if (params != null && params.isNotEmpty) {
      StringBuffer sb = new StringBuffer("?");
      params.forEach((key, value) {
        sb.write("$key" + "=" + value + "&");
      });
      String paramsString = sb.toString();
      paramsString = paramsString.substring(0, paramsString.length - 1);
      url += paramsString;
    }
    print(url);

    /// 这里如果有能用请求头信息需要设置的话可以在这里传。
    /// 这里需要设置一下cookie
    var response = await http.get(url);
    return response.body;
  }

  /// post 请求
  static Future<String> post(String url, {Map<String, String> params}) async {
    var response = await http.post(url, body: params);
    return response.body;
  }
}
