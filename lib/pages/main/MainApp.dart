import 'package:flutter/material.dart';
import 'package:WanAndroid/pages/main/IndexedStackMain.dart';
import 'package:WanAndroid/pages/main/TabBarViewMain.dart';

///  一个是左右滑动的ViewPager样式的。
///  一个是点击ItemBar切换显示样式的。

class MainApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MainAppState();
}

class MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
            title: Text(
              "请选择一种主页风格",
              style: TextStyle(color: Colors.white),
            ),
            iconTheme: IconThemeData(color: Colors.white)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => IndexedStackMain()));
                },
                child: Container(
                  width: 200.0,
                  height: 200.0,
                  child: Card(
                    color: Colors.green,
                    child: Center(
                      child: Text(
                        "进入不可以左右滑动的主页",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TabBarViewMain()));
                  Scaffold
                      .of(context)
                      .showSnackBar(SnackBar(content: Text("进入可以左右滑动的主页")));
                },
                child: Container(
                  width: 200.0,
                  height: 200.0,
                  child: Card(
                    color: Colors.blue,
                    child: Center(
                      child: Text(
                        "进入可以左右滑动的主页",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
}
