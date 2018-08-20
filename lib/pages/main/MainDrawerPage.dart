import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// 主页的侧滑页面  用一个没有状态的widget ，比用一个有状态的widget ui反应上快了很多。
class MainDrawerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          children: <Widget>[
            Container(
              height: 200.0,
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      // 就先居中放一个头像和名字吧
                      children: <Widget>[
                        SizedBox(
                          width: 80.0,
                          height: 80.0,
                          child: CircleAvatar(
                            child: Image.asset(
                              "images/icon_head_default.png",
                              width: 80.0,
                              height: 80.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text(
                            "未登录",
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.0),
                          ),
                        )
                      ],
                    ),
                  ),
                  // 右下角来一个点击登录
                  Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: FlatButton(
                        onPressed: () {
                          // 前往登录 todo
                        },
                        child: Text(
                          "前往登录",
                          style: TextStyle(fontSize: 14.0, color: Colors.white),
                        ),
                        color: Colors.transparent,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
                child: Container(
              color: Colors.white,
              child: ListView(
                children: <Widget>[
                  ListTile(
                    title: Text("我喜欢的"),
                    trailing: Icon(Icons.navigate_next),
                    onTap: () {},
                  ),
                  Divider(),
                  ListTile(
                    title: Text("关于"),
                    trailing: Icon(Icons.navigate_next),
                    onTap: () {},
                  ),
                  Divider(),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
