import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

/// web页面。
class MyWebDetailPage extends StatefulWidget {
// 目前只需要标题和url吧。
  final String _title;
  final String _url;

  MyWebDetailPage(this._title, this._url);

  @override
  State<StatefulWidget> createState() => MyWebDetailPageState(_title, _url);
}

class MyWebDetailPageState extends State<MyWebDetailPage> {
  final String _title;
  final String _url;

  MyWebDetailPageState(this._title, this._url);


  @override
  Widget build(BuildContext context) {
    print(_url);
    return WebviewScaffold(
      url: _url,
      withJavascript: true,
      appBar: AppBar(
        title: Text(
          _title,
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          // 分享功能，现在还不清楚分享什么东西比较好。
//          IconButton(icon: Icon(Icons.share), onPressed: () {}),
        ],
        iconTheme: IconThemeData(color: Colors.white),
      ),
    );
  }
}
