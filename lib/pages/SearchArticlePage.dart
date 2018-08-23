import 'package:flutter/material.dart';
import 'dart:async';
import 'package:WanAndroid/http/HttpUtils.dart';
import 'package:WanAndroid/constant/Urls.dart';
import 'dart:convert';
import 'package:WanAndroid/utils/ToastUtils.dart';
import 'package:WanAndroid/widget/ArticleItemWidget.dart';

/// 搜索文章页面。
class SearchArticlePage extends StatefulWidget {
  /// 这个是传进来的
  final searchStr;

  SearchArticlePage({this.searchStr});

  @override
  State<StatefulWidget> createState() => SearchArticlePageState(
        searchStr: searchStr == null ? "" : searchStr,
      );
}

class SearchArticlePageState extends State<SearchArticlePage> {
  /// 用来搜索的关键字
  var searchStr = "";

  SearchArticlePageState({this.searchStr});

  /// 用来控制清除输入icon的显不显示
  var _showClear = false;

  /// 输入框架controller
  var _textFieldController;

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
    searchArticle(false);
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
        searchArticle(true);
      }
    });
    // 如果这个时候传入了搜索词就触发搜索
    if (searchStr == null || searchStr.isEmpty) {
      _textFieldController = TextEditingController();
    } else {
      _textFieldController = TextEditingController(text: searchStr);
      _refresh();
      _showClear = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        /// 输入框
        title: Container(
          child: TextField(
            controller: _textFieldController,
            // 把键盘设置为搜索。为什么图标没有改变呢，看里面的说明是这样意思呀？
            textInputAction: TextInputAction.search,
            // 点击键盘上的搜索触发。
            onSubmitted: (content) {
              searchStr = content;
              // 进行搜索
              searchArticle(false);
            },
            onChanged: (content) {
              setState(() {
                _showClear = content != null && content.isNotEmpty;
              });
            },
            decoration: InputDecoration(
              hintText: "请输入搜索内容",
              hintStyle: TextStyle(color: Colors.white),
              // 这个难道不是下面的线条样式吗？？？哎
//              border: UnderlineInputBorder(
//                borderSide: BorderSide(
//                  width: 0.0,
//                  style: BorderStyle.none,
//                  color: Colors.transparent,
//                )
//              )
            ),
            maxLines: 1,
            style: TextStyle(color: Colors.white),
          ),
        ),

        /// 删除操作
        actions: <Widget>[
          _showClear
              ? IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _textFieldController.clear();
                  },
                )
              : Container()
        ],
        // icon的主题设置
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: _isRequesting
          ? Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation(Theme.of(context).primaryColor),
              ),
            )
          : RefreshIndicator(
              child: ListView.builder(
                itemBuilder: (context, index) =>
                    ArticleItemWidget(_articleData[index]),
                itemCount: _articleData.length,
                controller: _scrollController,
              ),
              onRefresh: _refresh),
    );
  }

  /// 这里进行搜索， isLoadMore 代表是不是加载更多。
  void searchArticle(bool isLoadMore) {
    if (searchStr.isEmpty && !isLoadMore) {
      ToastUtils.showToast("请输入搜索内容");
      return null;
    }
    // 根据当前需要加载的页码来加载。这个页码在每次加载更多成功后+1就好了，下拉刷新的时候重置为0
    if (!isLoadMore) {
      _curPager = 0;
      setState(() {
        _isRequesting = true;
      });
    }
    // 拼接url
    var searchUrl = "${Urls.SEARCH_ARTICLE_LIST}$_curPager/json";
    // 开始请求  来一个请求中的值吧。
    var params = Map<String, String>();
    params["k"] = "$searchStr";
    HttpUtils.post(searchUrl, params: params).then((response) {
      // 请求完成后设置这个值的状态
      print(response);
      setState(() {
        _isRequesting = false;
      });
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
          } else {
            // 没有搜索到数据的话给个提示。
            if (_totalCount == 0) {
              ToastUtils.showToast("搜索结果为空");
            }
          }
        } else {
          // 弹出提示
          ToastUtils.showToast("${resultMap["errorMsg"]}");
        }
      }
    });
  }
}
