import 'package:flutter/material.dart';
import 'package:WanAndroid/pages/account/LoginOrRegisterPage.dart';
import 'package:WanAndroid/constant/AppConstant.dart';
import 'package:WanAndroid/dao/SpUtils.dart';
import 'package:WanAndroid/constant/Config.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:WanAndroid/event/EventObject.dart';
import 'package:WanAndroid/event/EventUtils.dart';

/// 主页的侧滑页面  用一个没有状态的widget ，不知道是不是我幻觉了，视觉上比用一个有状态的widget ui反应上快了很多。
class MainDrawerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MainDrawerPageState();
}

class MainDrawerPageState extends State<MainDrawerPage> {
  var _appCookie = AppConstant.APP_COOKIE;

  @override
  void initState() {
    // 监听 登录 成功和失败的事件
    EventUtils.appEvent.on<EventObject>().listen((event) {
      // 这里要检查下挂载状态
      if (this.mounted) {
        if (event.key == EventUtils.EVENT_LOGIN) {
          // 登录成功
          setState(() {
            _appCookie = AppConstant.APP_COOKIE;
          });
          print("MainDrawerPage:EVENT_LOGIN");
        }
      }
    });
    super.initState();
  }

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
                            backgroundImage: AssetImage(
                              _appCookie == null || _appCookie.isEmpty
                                  ? "images/icon_head_default.png"
                                  : "images/icon_my_head.png",
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text(
                            _appCookie == null || _appCookie.isEmpty
                                ? "未登录"
                                : "已登录",
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
                          _appCookie == null || _appCookie.isEmpty
                              ?
                              // 前往登录
                              goLogin(context)
                              : exitLogin();
                        },
                        child: Text(
                          _appCookie == null || _appCookie.isEmpty
                              ? "前往登录"
                              : "退出登录",
                          style: TextStyle(fontSize: 14.0, color: Colors.white),
                        ),
                        color: Colors.transparent,
                      ),
                    ),
                  ),
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
                    onTap: () {
                      Fluttertoast.showToast(
                          msg: "我喜欢的还不知道在哪呢？",
                          gravity: ToastGravity.CENTER,
                          bgcolor: "#99000000",
                          textcolor: '#ffffff');
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: Text("关于"),
                    trailing: Icon(Icons.navigate_next),
                    onTap: () {
                      Fluttertoast.showToast(
                          msg: "关于我们~们~们~",
                          gravity: ToastGravity.CENTER,
                          bgcolor: "#99000000",
                          textcolor: '#ffffff');
                    },
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

  /// 前往登录
  goLogin(BuildContext context) {
//    Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return LoginOrRegister();
    }));
  }

  /// 退出登录
  exitLogin() {
    // 清除cookie信息。
    SpUtils.removeString(Config.SP_COOKIE);
    AppConstant.APP_COOKIE = "";
    setState(() {
      _appCookie = "";
    });
    Fluttertoast.showToast(
        msg: "退出登录成功",
        gravity: ToastGravity.CENTER,
        bgcolor: "#99000000",
        textcolor: '#ffffff');
    // 发送退出登录的event
    EventUtils.appEvent.fire(EventObject(EventUtils.EVENT_LOGOUT, ""));
  }
}
