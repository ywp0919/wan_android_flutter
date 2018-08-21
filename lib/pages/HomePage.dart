import 'package:flutter/material.dart';
import 'package:WanAndroid/http/HttpUtils.dart';
import 'package:WanAndroid/constant/Urls.dart';
import 'package:WanAndroid/widget/SlideView.dart';
import 'dart:convert';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:WanAndroid/event/EventObject.dart';
import 'package:WanAndroid/event/EventUtils.dart';
import 'package:WanAndroid/pages/MyWebDetailPage.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  /// 列表用的滑动监听控制器。这里可以点进去看看它里面有哪些参数和方法。
  ScrollController _scrollController = ScrollController();

  /// 给Snack用的。
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey();

  /// banner的数据。
  var _bannerData;

  SlideView _slideView;

  /// 获取到的文章列表数据集合。给ListView构建Item时使用。
  List _articleData = List();

  /// 文章总条数，用来做加载更多的判断用的。
  var _totalCount;

  /// 当前的页面，这个接口是从0开始的。
  var _curPager = 0;

  /// 标志当前在请求中。
  var _isRequesting = false;

  /// 下拉刷新动作，这里需要看下文档
  Future<Null> _refresh() async {
    getBannerData();
    getArticleData(false);
    return null;
  }

  @override
  void initState() {
    // 加载更多
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
              _scrollController.position.pixels &&
          _articleData.length < _totalCount &&
          !_isRequesting) {
        // 这个时候触发加载更多
        getArticleData(true);
      }
    });

    // 监听 登录 成功和失败的事件
    EventUtils.appEvent.on<EventObject>().listen((event) {
      // 登录成功 这里要检查下挂载状态
      if (this.mounted) {
        if (event.key == EventUtils.EVENT_LOGIN) {
          // 登录成功  刷新下列表吧
          getArticleData(false);
          print("HomePage:EVENT_LOGIN");
        } else if (event.key == EventUtils.EVENT_LOGOUT) {
          // 退出登录  也刷新下列表吧  别想到其他的动作现在
          getArticleData(false);
          print("HomePage:EVENT_LOGOUT");
        }
      }
    });

    _refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        key: _scaffoldState,
        body: _articleData.length == 0
            ? Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                ),
              )
            : RefreshIndicator(
                child: ListView.builder(
                  itemBuilder: (context, index) => getListViewItemWidget(index),
                  itemCount: _articleData.length + 1,
                  controller: _scrollController,
                ),
                onRefresh: _refresh),
      );

  /// 构建 item
  getListViewItemWidget(int index) {
    if (index == 0) {
      // 这个是banner
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width / 2,
        child: _slideView,
      );
    }
    var item = _articleData[index - 1];
    // 其他的是列表的数据了。 这样写的好难看，看来得把代码多的这些部分移动到另一个文件去写了。
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
                  MyWebDetailPage(item["title"], item["link"])));
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
                        item["title"],
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
                      dealWithArticleCollectStatus(index - 1, item["collect"]);
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

  /// 获取文章列表的数据
  void getArticleData(bool isLoadMore) {
    // 根据当前需要加载的页码来加载。这个页码在每次加载更多成功后+1就好了，下拉刷新的时候重置为0
    if (!isLoadMore) {
      _curPager = 0;
    }
    // 拼接url
    var articleUrl = "${Urls.ARTICLE_LIST}$_curPager/json";
    // 开始请求  来一个请求中的值吧。
    setState(() {
      _isRequesting = true;
    });
    HttpUtils.get(articleUrl).then((response) {
      // 请求完成后设置这个值的状态
      _isRequesting = false;
      // 拿到结果后解析数据吧。
//      print(response);
      if (response != null && response.isNotEmpty) {
        // 这里用到dart:convert这个转换库
        Map<String, dynamic> resultMap = jsonDecode(response);
        // 判断成功取到了列表数据没有 errorCode==0 && data 有数据就正确，不然弹出errorMsg
        var data = resultMap["data"];
        if (data != null && resultMap["errorCode"] == 0) {
          // 要使状态发生改变
          setState(() {
            /// 这些是文章列表的数据
            // 总数
            _totalCount = data["total"];
            // 要加的列表数据
            if (!isLoadMore) {
              _articleData = data["datas"];
            } else {
              _articleData.addAll(data["datas"]);
            }
            // 这个时候mPager++
            _curPager++;
          });
          // 如果是加载成功再提示一下吧。
          if (isLoadMore) {
            _scaffoldState.currentState.showSnackBar(
                SnackBar(content: Text("新增了${data["datas"].length}条数据")));
          }
        } else {
          // 弹出提示
          Fluttertoast.showToast(
              msg: "${resultMap["errorMsg"]}",
              gravity: ToastGravity.CENTER,
              bgcolor: "#99000000",
              textcolor: '#ffffff');
        }
      }
    });
  }

  /// 获取banner数据
  void getBannerData() {
    // http://www.wanandroid.com/banner/json
    HttpUtils.get(Urls.HOME_BANNER_DATA).then((response) {
//      print(response);
      if (response != null && response.isNotEmpty) {
        // 这里用到dart:convert这个转换库
        Map<String, dynamic> resultMap = jsonDecode(response);
        var data = resultMap["data"];
        if (data != null && resultMap["errorCode"] == 0) {
          setState(() {
            _bannerData = data;
            _slideView = SlideView(_bannerData);
          });
        }
      }
    });
  }

  /// 处理收藏或者取消收藏文章
  void dealWithArticleCollectStatus(int index, bool collectStatus) {
    if (collectStatus) {
      // 取消收藏
      cancelCollectArt(index);
    } else {
      // 收藏
      collectArt(index);
    }
  }

  /// 取消收藏  这个返回都是一样看来是能把这两个整合起来减少代码量的，先这样吧，已经写了。
  void cancelCollectArt(int index) {
    var id = _articleData[index]["id"];
    var url = Urls.ARTICLE_UN_COLLECT + "$id/json";
    print(url);
    HttpUtils.post(url).then((response) {
//      print(response);
      var suc = false;
      if (response != null && response.isNotEmpty) {
        Map<String, dynamic> resultMap = jsonDecode(response);
        if (resultMap["errorCode"] == 0) {
          setState(() {
            _articleData[index]["collect"] = false;
          });
          suc = true;
        }
        Fluttertoast.showToast(
            msg: suc ? "已取消收藏" : "${resultMap["errorMsg"]}",
            gravity: ToastGravity.CENTER,
            bgcolor: "#99000000",
            textcolor: '#ffffff');
//        _scaffoldState.currentState.showSnackBar(SnackBar(
//            content: Text(
//              suc ? "已取消收藏" : "${resultMap["errorMsg"]}",
//            )));
      }
    });
  }

  /// 收藏
  void collectArt(int index) {
    var id = _articleData[index]["id"];
    var url = Urls.ARTICLE_COLLECT_INNER + "$id/json";
    print(url);
    HttpUtils.post(url).then((response) {
//      print(response);
      var suc = false;
      if (response != null && response.isNotEmpty) {
        Map<String, dynamic> resultMap = jsonDecode(response);
        if (resultMap["errorCode"] == 0) {
          setState(() {
            _articleData[index]["collect"] = true;
          });
          suc = true;
        }
        Fluttertoast.showToast(
            msg: suc ? "收藏成功" : "${resultMap["errorMsg"]}",
            gravity: ToastGravity.CENTER,
            bgcolor: "#99000000",
            textcolor: '#ffffff');
//        _scaffoldState.currentState.showSnackBar(SnackBar(
//            content: Text(
//              suc ? "收藏成功" : "${resultMap["errorMsg"]}",
//            )));
      }
    });
  }
}
