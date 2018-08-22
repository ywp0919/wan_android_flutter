import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:WanAndroid/constant/AppConstant.dart';
import 'package:WanAndroid/dao/SpUtils.dart';
import 'package:WanAndroid/constant/Config.dart';

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
    /// 这里需要设置一下cookie 、、 从缓存取出来吧。
    var headMap = Map<String, String>();
    headMap["Cookie"] = AppConstant.APP_COOKIE;
    var response = await http.get(url, headers: headMap);
    return response.body;
  }

  /// post 请求  这里开放一个参数控制是不是登录注册，是的话得保存cookie数据
  static Future<String> post(String url,
      {Map<String, String> params, bool saveCookie}) async {
    var headMap = Map<String, String>();
    headMap["Cookie"] = AppConstant.APP_COOKIE;
//    print(headMap["Cookie"]);
    print(url);

    var response = await http.post(url, body: params, headers: headMap);
    // 这里需要保存cookie的话，。
    var cookie = response.headers['set-cookie'];

    /// 这里我再判断了一下cookie里面有没有这个值来当作对成功和失败的过滤了。
    if (saveCookie =
        true && cookie != null && cookie.contains("loginUserName")) {
      // 持久化保存
      print("保存cookie成功---:$cookie");
      // 内容中放一份加快取的速度
      AppConstant.APP_COOKIE = cookie;
      // 持久化一份
      SpUtils.setString(Config.SP_COOKIE, cookie);
    }

    return response.body;
  }
}
