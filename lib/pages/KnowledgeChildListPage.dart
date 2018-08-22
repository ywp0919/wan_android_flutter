import 'package:flutter/material.dart';
import 'dart:async';
import 'package:WanAndroid/http/HttpUtils.dart';
import 'package:WanAndroid/constant/Urls.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:WanAndroid/widget/ArticleItemWidget.dart';

/// 通过传入的id 获取这个分类的文章列表。
class KnowledgeChildListPage extends StatefulWidget {
  final _id;

  KnowledgeChildListPage(this._id);

  @override
  State<StatefulWidget> createState() => KnowledgeChildListPageState(_id);
}

class KnowledgeChildListPageState extends State<KnowledgeChildListPage>
    with AutomaticKeepAliveClientMixin {
  final _id;

  KnowledgeChildListPageState(this._id);

  /// 列表用的滑动监听控制器。这里可以点进去看看它里面有哪些参数和方法。
  ScrollController _scrollController = ScrollController();

  /// 给Snack用的。
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey();

  /// 获取到的文章列表数据集合。给ListView构建Item时使用。
  List _articleData = List();

  /// 文章总条数，用来做加载更多的判断用的。
  var _totalCount;

  /// 当前的页面，这个接口是从0开始的。
  var _curPager = 0;

  /// 标志当前在请求中。
  var _isRequesting = false;

  /// 下拉刷新动作
  Future<Null> _refresh() async {
    getArticleData(false);
    return null;
  }

  /// 这个东西能让它在切换时不给销毁掉。
  @override
  bool get wantKeepAlive => true;

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
                  itemCount: _articleData.length,
                  controller: _scrollController,
                ),
                onRefresh: _refresh),
      );

  /// 构建 item
  getListViewItemWidget(int index) {
    var item = _articleData[index];
    // 其他的是列表的数据了。 这样写的好难看，看来得把代码多的这些部分移动到另一个文件去写了。
   return ArticleItemWidget(item);
  }

  /// 获取文章列表的数据
  void getArticleData(bool isLoadMore) {
    // 根据当前需要加载的页码来加载。这个页码在每次加载更多成功后+1就好了，下拉刷新的时候重置为0
    if (!isLoadMore) {
      _curPager = 0;
    }
    // 拼接url
    var articleUrl = "${Urls.KNOWLEDGE_PROJECT_LIST}$_curPager/json";
    // 开始请求  来一个请求中的值吧。
    setState(() {
      _isRequesting = true;
    });
    var params = Map<String, String>();
    params["cid"] = "$_id";
    HttpUtils.get(articleUrl, params: params).then((response) {
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

}
