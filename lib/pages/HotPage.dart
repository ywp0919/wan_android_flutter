import 'package:flutter/material.dart';
import 'package:WanAndroid/pages/MyWebDetailPage.dart';
import 'package:WanAndroid/constant/Urls.dart';
import 'package:WanAndroid/utils/ToastUtils.dart';
import 'package:WanAndroid/http/HttpUtils.dart';
import 'package:WanAndroid/pages/SearchArticlePage.dart';
import 'dart:convert';
import 'dart:async';

/// 热门搜索和热门网站都放在这里吧。
class HotPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HotPageState();
}

class HotPageState extends State<HotPage> with AutomaticKeepAliveClientMixin {
  /// 变色用的
  var _textColors = [
    0xFF41BAE9,
    0xFFF38083,
    0xFF828528,
    0xFF148583,
    0xFFF28317
  ];

  /// 热词数据
  var _hotSearchData = List();

  /// 常用网站数据
  var _hotWebsiteData = List();

  Future<Null> _refresh() async {
    getHotSearchData();
    getHotWebsite();
    return null;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _refresh();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // 热词列表
    var _hotSearchWidgets = List<Widget>();
    for (var i = 0; i < _hotSearchData.length; ++i) {
      var item = _hotSearchData[i];
      _hotSearchWidgets.add(ActionChip(
          backgroundColor: Colors.grey[300],
          onPressed: () {
            // 点击就去搜索页面吧，把数据带进去
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SearchArticlePage(
                      searchStr: item["name"],
                    )));
          },
          label: Text(
            item["name"],
            style: TextStyle(
              color: Color(_textColors[i % 5]),
              fontSize: 14.0,
            ),
          )));
    }
    // 常用网站列表
    var _hotWebsiteWidgets = List<Widget>();
    for (var i = 0; i < _hotWebsiteData.length; ++i) {
      var item = _hotWebsiteData[i];
      _hotWebsiteWidgets.add(ActionChip(
          backgroundColor: Colors.grey[300],
          onPressed: () {
            // 点击就去web页面了
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    MyWebDetailPage(item["name"], item["link"])));
          },
          label: Text(
            item["name"],
            style: TextStyle(color: Color(_textColors[i % 5])),
          )));
    }

    return Scaffold(
      body: Container(
        color: Colors.grey[100],
        child: RefreshIndicator(
          child: ListView(
            children: <Widget>[
              /// 热词标题栏加热词列表。
              Container(
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding:
                            EdgeInsets.only(top: 8.0, bottom: 8.0, left: 14.0),
                        child: Text(
                          "热门搜索",
                          style: TextStyle(color: Colors.black, fontSize: 18.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1.0,
              ),
              // 热词列表 https://docs.flutter.io/flutter/widgets/Wrap-class.html 用法在这
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: Wrap(
                  spacing: 10.0,
                  children: _hotSearchWidgets,
                ),
              ),
              Divider(
                height: 1.0,
              ),
              /// 常用网站标题栏加常用网站列表。
              Container(
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding:
                            EdgeInsets.only(top: 8.0, bottom: 8.0, left: 14.0),
                        child: Text(
                          "热门网址",
                          style: TextStyle(color: Colors.black, fontSize: 18.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1.0,
              ),
              // 常用网址列表 https://docs.flutter.io/flutter/widgets/Wrap-class.html
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: Wrap(
                  spacing: 10.0,
                  children: _hotWebsiteWidgets,
                ),
              ),
            ],
          ),
          onRefresh: _refresh,
        ),
      ),
    );
  }

  /// 获取热词列表数据。
  getHotSearchData() {
    HttpUtils.get(Urls.HOT_SEARCH_LIST).then((response) {
//      print(response);
      if (response != null && response.isNotEmpty) {
        Map<String, dynamic> resultMap = jsonDecode(response);
        var data = resultMap["data"];
        if (resultMap["errorCode"] == 0 && data != null) {
          setState(() {
            _hotSearchData = data;
          });
        } else {
          ToastUtils.showToast(resultMap["errorMsg"]);
        }
      }
    });
  }

  /// 获取常用网站
  getHotWebsite() {
    HttpUtils.get(Urls.HOT_WEBSITE_LIST).then((response) {
//      print(response);
      if (response != null && response.isNotEmpty) {
        Map<String, dynamic> resultMap = jsonDecode(response);
        var data = resultMap["data"];
        if (resultMap["errorCode"] == 0 && data != null) {
          setState(() {
            _hotWebsiteData = data;
          });
        } else {
          ToastUtils.showToast(resultMap["errorMsg"]);
        }
      }
    });
  }
}
