import 'package:flutter/material.dart';
import 'package:WanAndroid/pages/http/HttpUtils.dart';
import 'package:WanAndroid/pages/constant/Urls.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  /// 给Snack用的。
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey();

  /// banner的数据。
  var _bannerData;

  /// 获取到的文章列表数据集合。给ListView构建Item时使用。
  List _articleData = List();

  /// 文章总条数，用来做加载更多的判断用的。
  var _totalCount;

  /// 当前的页面，这个接口是从0开始的。
  var _curPager = 0;

  @override
  void initState() {
    // 获取文章列表数据。
    getArticleData(false);
    // 获取banner数据。
    getBannerData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        key: _scaffoldState,
        body: RefreshIndicator(
            child: ListView.builder(
              itemBuilder: (context, index) => getListViewItemWidget(index),
              itemCount: _articleData.length + 1,
            ),
            onRefresh: () {
              getBannerData();
              getArticleData(false);
              return null;
            }),
      );

  /// 构建 item
  getListViewItemWidget(int index) {
    if (index == 0) {
      // 这个是banner
      return Text("banner先不写");
    }
    var item = _articleData[index - 1];
    // 其他的是列表的数据了。 这样写的好难看，看来得把代码多的这些部分移动到另一个文件去写了。
    return Card(
      // 水波
      child: InkWell(
        onTap: () {
          /// 点击事件
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
                      child: Text.rich(
                        TextSpan(text: item["title"]),
                        softWrap: true,
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.black, fontSize: 18.0),
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
                      Scaffold
                          .of(context)
                          .showSnackBar(SnackBar(content: Text("收藏我哦")));
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
      _articleData.clear();
      _curPager = 0;
    }
    // 拼接url
    var articleUrl = "${Urls.BASE_URL}${Urls.ARTICLE_LIST}$_curPager/json";
    // 开始请求
    HttpUtils.get(articleUrl).then((response) {
      // 拿到结果后解析数据吧。
      print(response);
      if (response != null && response.isNotEmpty) {
        // 这里用到dart:convert这个转换库
        Map<String, dynamic> resultMap = jsonDecode(response);
        // 判断成功取到了列表数据没有 errorCode==0 && data 有数据就正确，不然弹出errorMsg
        var data = resultMap["data"];
        if (data != null && resultMap["errorCode"] == 0) {
          // 要使状态发生改变
          setState(() {
            // 总数
            _totalCount = data["total"];
            // 要加的列表数据
            _articleData.addAll(data["datas"]);
            // 这个时候mPager++
            _curPager++;
          });
        } else {
          // 弹出提示
//          _scaffoldState.currentState
//              .showSnackBar(SnackBar(content: Text("数据获取失败")));
        }
      }
    });
  }

  /// 获取banner数据
  void getBannerData() {}
}
