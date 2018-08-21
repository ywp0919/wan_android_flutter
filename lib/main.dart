import 'package:flutter/material.dart';
import 'package:WanAndroid/pages/main/MainApp.dart';
import 'package:WanAndroid/constant/Config.dart';
import 'package:WanAndroid/constant/AppConstant.dart';
import 'package:shared_preferences/shared_preferences.dart';


/// 这里直接用MaterialApp包裹，后面有用到Navigator.push的时候context要求把Scaffold独立出widget出来
void main() {

  SharedPreferences.getInstance().then((prefs) {
    AppConstant.APP_COOKIE = prefs.getString(Config.SP_COOKIE);
  });

  runApp(MaterialApp(
    //主题设置
    theme: ThemeData(primaryColor: Colors.green),
    home: MainApp(),
  ));
}
