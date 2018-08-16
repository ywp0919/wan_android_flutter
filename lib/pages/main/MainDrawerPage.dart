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
      constraints:BoxConstraints(maxWidth: 280.0),
      child: Container(
        width: 300.0,
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Image.asset("images/icon_bottom_main_checked.png")
              ],
            )
          ],
        ),
      ),
    );
  }
}
