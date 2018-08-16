import 'package:flutter/material.dart';
import 'package:WanAndroid/pages/main/MainApp.dart';

/// 这里直接用MaterialApp包裹，后面有用到Navigator.push的时候context要求把Scaffold独立出widget出来
void main() => runApp(MaterialApp(
      //主题设置
      theme: ThemeData(primaryColor: Colors.green),
      home: MainApp(),
    ));
