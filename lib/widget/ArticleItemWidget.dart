import 'package:flutter/material.dart';
import 'package:WanAndroid/pages/MyWebDetailPage.dart';
import 'package:WanAndroid/http/HttpUtils.dart';
import 'package:WanAndroid/constant/Urls.dart';
import 'dart:convert';

import 'package:WanAndroid/utils/ToastUtils.dart';

/// 里面的文章item都是用的这一个生成，之前到处要copy一份很乱，现在直接抽出来大家共用。
class ArticleItemWidget extends StatefulWidget {
  final item;

  ArticleItemWidget(
    this.item,
  );

  @override
  State<StatefulWidget> createState() {
    return ArticleItemWidgetState(item);
  }
}

class ArticleItemWidgetState extends State<ArticleItemWidget> {
  final item;

  ArticleItemWidgetState(this.item);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 2.0,
      // 水波
      child: InkWell(
        onTap: () {
          /// 点击事件
//          Fluttertoast.showToast(
//              msg: "点击了${item["title"]}",
//              gravity: ToastGravity.CENTER,
//              bgcolor: "#99000000",
//              textcolor: '#ffffff');
          // 打开web页面
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  MyWebDetailPage(handleString(item["title"] as String), item["link"])));
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              /// 作者 和 时间 在一行
              Row(
                children: <Widget>[
                  // 作者
                  Expanded(
                    child: Text(
                      item["author"],
                      style: TextStyle(color: Colors.black, fontSize: 14.0),
                    ),
                  ),
                  //时间
                  Text(
                    item["niceDate"],
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),

              /// 标题   描述有的是空的，就不放上来了。
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      // 设置支持软换行的
                      child: Text(
                        /// 哎，这里的搜索的文字还需要做过滤处理才行。有<em class='highlight'></em>标签存在
                        handleString(item["title"] as String),
                        softWrap: true,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),

              /// 分类   和   点星(收藏)
              Row(
                children: <Widget>[
                  Expanded(
                      child: Text(
                    item["superChapterName"],
                    style: TextStyle(color: Colors.green, fontSize: 16.0),
                  )),
                  // 小星星
                  GestureDetector(
                    onTap: () {
//                      Scaffold
//                          .of(context)
//                          .showSnackBar(SnackBar(content: Text("收藏我哦")));
                      // 收藏或者取消收藏
                      dealWithArticleCollectStatus();
                    },
                    child: Image.asset(
                      item["collect"]
                          ? "images/icon_collect_yes.png"
                          : "images/icon_collect_no.png",
                      width: 25.0,
                      height: 25.0,
                    ),
                  )
                ],
              )
              //
            ],
          ),
        ),
      ),
    );
  }

  /// 处理收藏或者取消收藏文章
  void dealWithArticleCollectStatus() {
    if (item["collect"] as bool) {
      // 取消收藏
      cancelCollectArt();
    } else {
      // 收藏
      collectArt();
    }
  }

  /// 取消收藏  这个返回都是一样看来是能把这两个整合起来减少代码量的，先这样吧，已经写了。
  void cancelCollectArt() {
    var id = item["id"];
    var url = Urls.ARTICLE_UN_COLLECT + "$id/json";
    print(url);
    HttpUtils.post(url).then((response) {
//      print(response);
      var suc = false;
      if (response != null && response.isNotEmpty) {
        Map<String, dynamic> resultMap = jsonDecode(response);
        if (resultMap["errorCode"] == 0) {
          setState(() {
            item["collect"] = false;
          });
          suc = true;
        }
        ToastUtils.showToast(suc ? "已取消收藏" : "${resultMap["errorMsg"]}");

//        Fluttertoast.showToast(
//            msg: suc ? "已取消收藏" : "${resultMap["errorMsg"]}",
//            gravity: ToastGravity.CENTER,
//            bgcolor: "#99000000",
//            textcolor: '#ffffff');
//        _scaffoldState.currentState.showSnackBar(SnackBar(
//            content: Text(
//              suc ? "已取消收藏" : "${resultMap["errorMsg"]}",
//            )));
      }
    });
  }

  /// 收藏
  void collectArt() {
    var id = item["id"];
    var url = Urls.ARTICLE_COLLECT_INNER + "$id/json";
    print(url);
    HttpUtils.post(url).then((response) {
//      print(response);
      var suc = false;
      if (response != null && response.isNotEmpty) {
        Map<String, dynamic> resultMap = jsonDecode(response);
        if (resultMap["errorCode"] == 0) {
          setState(() {
            item["collect"] = true;
          });
          suc = true;
        }
        ToastUtils.showToast(
          suc ? "收藏成功" : "${resultMap["errorMsg"]}",
        );
//        Fluttertoast.showToast(
//            msg: suc ? "收藏成功" : "${resultMap["errorMsg"]}",
//            gravity: ToastGravity.CENTER,
//            bgcolor: "#99000000",
//            textcolor: '#ffffff');
//        _scaffoldState.currentState.showSnackBar(SnackBar(
//            content: Text(
//              suc ? "收藏成功" : "${resultMap["errorMsg"]}",
//            )));
      }
    });
  }

  /// 把文字 处理一下。这里的搜索的文字还需要做过滤处理才行。有<em class='highlight'></em>标签存在
  /// 这里可以再考虑做一下高度。
  String handleString(String item) {
    if (item.contains("<em")) {
      return item
          .replaceAll("<em class='highlight'>", "")
          .replaceAll("<\/em>", "");
    } else {
      return item;
    }
  }
}
