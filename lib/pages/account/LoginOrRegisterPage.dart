import 'package:flutter/material.dart';
import 'package:WanAndroid/http/HttpUtils.dart';
import 'package:WanAndroid/constant/Urls.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:WanAndroid/event/EventObject.dart';
import 'package:WanAndroid/event/EventUtils.dart';

class LoginOrRegister extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginOrRegisterState();
}

/// 登录和注册我就放在一起了，懒的多写一个页面了，至于密码的二次输入确认也不想写了。。。原谅我这么的懒吧。
class LoginOrRegisterState extends State<LoginOrRegister> {
  var _isRequesting = false;
  var _username = "";
  var _password = "";

  // 我去，这个controller 记得一定要放在外面来，不能直接在里面new ，不然状态没保存，键盘一收输入的内容也没有了。
  var _usernameController = TextEditingController();
  var _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("用户登录"),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.only(
                top: 48.0, left: 32.0, right: 32.0, bottom: 190.0),
            child: Card(
              child: _isRequesting == false
                  ? Padding(
                      padding: const EdgeInsets.only(top: 28.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: 80.0,
                            height: 80.0,
                            child: CircleAvatar(
                              backgroundImage: AssetImage(
                                "images/icon_head_default.png",
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 18.0),
                            child: TextField(
                              maxLines: 1,
                              onChanged: (username) {
                                _username = username;
                              },
//                              autofocus: true,
                              decoration: InputDecoration(
                                  hintText: "账 号：", labelText: "请输入您的账号"),
                              controller: _usernameController,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 12.0),
                            child: TextField(
                              maxLines: 1,
                              onChanged: (password) {
                                _password = password;
                              },
                              obscureText: true,
                              decoration: InputDecoration(
                                  hintText: "密 码：", labelText: "请输入您的密码"),
                              controller: _passwordController,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 38.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    child: RaisedButton(
                                  color: Theme.of(context).primaryColor,
                                  onPressed: () {
                                    loginUser();
                                  },
                                  child: Text(
                                    "登 录",
                                    style: TextStyle(
                                        fontSize: 14.0, color: Colors.white),
                                  ),
                                )),
                                Expanded(
                                    child: RaisedButton(
                                  color: Theme.of(context).primaryColor,
                                  onPressed: () {
                                    registerUser();
                                  },
                                  child: Text(
                                    "注 册",
                                    style: TextStyle(
                                        fontSize: 14.0, color: Colors.white),
                                  ),
                                ))
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(
                            Theme.of(context).primaryColor),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  /// 注册
  void registerUser() {
    if (!checkInput()) {
      return null;
    }
    var params = Map<String, String>();
    params["username"] = _username;
    params["password"] = _password;
    params["repassword"] = _password;
    setState(() {
      _isRequesting = true;
    });
    HttpUtils
        .post(Urls.REGISTER, params: params, saveCookie: true)
        .then((response) {
      dealWithResponse(response);
    });
  }

  /// 登录
  void loginUser() {
    if (!checkInput()) {
      return null;
    }

    var params = Map<String, String>();
    params["username"] = _username;
    params["password"] = _password;

    setState(() {
      _isRequesting = true;
    });
    HttpUtils
        .post(Urls.LOGIN, params: params, saveCookie: true)
        .then((response) {
      dealWithResponse(response);
    });
  }

  /// 处理返回的结果数据，都是一样的格式。
  void dealWithResponse(String response) {
//    print(response);
    setState(() {
      _isRequesting = false;
    });
    Map<String, dynamic> resultMap = jsonDecode(response);
    var data = resultMap["data"];
    if (resultMap["errorCode"] == 0 && data != null) {
      // 登录成功了 返回吧，发送成功的事件，保存一些数据
      // 发送登录 成功的event
      EventUtils.appEvent.fire(EventObject(EventUtils.EVENT_LOGIN, ""));
      Navigator.of(context).pop();

    } else {
      Fluttertoast.showToast(
          msg: "${resultMap["errorMsg"]}",
          gravity: ToastGravity.CENTER,
          bgcolor: "#99000000",
          textcolor: '#ffffff');
    }
  }

  /// 检查输入的
  bool checkInput() {
    if (_username.isEmpty || _password.isEmpty) {
      // 弹出提示
      Fluttertoast.showToast(
          msg: _username.isEmpty ? "请输入您的账号" : "请输入你的密码",
          gravity: ToastGravity.CENTER,
          bgcolor: "#99000000",
          textcolor: '#ffffff');
      return false;
    }
    if (_username.length < 8 || _password.length < 8) {
      Fluttertoast.showToast(
          msg: _username.length < 8 ? "请输入不少于8位长度的账号" : "请输入不少于8位长度的密码",
          gravity: ToastGravity.CENTER,
          bgcolor: "#99000000",
          textcolor: '#ffffff');
      return false;
    }
    return true;
  }

  ///  这是登录和注册接口返回的json格式内容
//  {
//  "data": {
//  "collectIds": [],
//  "email": "",
//  "icon": "",
//  "id": 9429,
//  "password": "12345678",
//  "token": "",
//  "type": 0,
//  "username": "weponYan"
//  },
//  "errorCode": 0,
//  "errorMsg": ""
//  }

}
