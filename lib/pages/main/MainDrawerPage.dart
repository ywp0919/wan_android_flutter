import 'package:flutter/material.dart';

/// 主页的侧滑页面
class MainDrawerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MainDrawerPageState();
}

class MainDrawerPageState extends State<MainDrawerPage> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 300.0),
      child: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: 300.0,
                  height: 200.0,
                  color: Colors.blue,
                  child: Stack(
                    children: <Widget>[
                      Text(
                        "我是隔壁的泰山",
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
