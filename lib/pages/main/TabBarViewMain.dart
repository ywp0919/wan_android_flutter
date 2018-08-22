import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:WanAndroid/pages/HomePage.dart';
import 'package:WanAndroid/pages/KnowledgePage.dart';
import 'package:WanAndroid/pages/main/MainDrawerPage.dart';

/// 这是一个点击TabItem进行切换显示的风格的主页。
class TabBarViewMain extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TabBarViewMainState();
}

class TabBarViewMainState extends State<TabBarViewMain>
    with SingleTickerProviderStateMixin {
  // 底部导航栏的文字 ， 给appBar 共用一下。
  var _bottomTitles = ["首页", "知识体系"];

  // 底部导航栏未选中时的图片
  var _bottomIconNor = [
    "images/icon_bottom_main_nor.png",
    "images/icon_bottom_knowledge_nor.png"
  ];

  // 底部导航栏选中时的图片
  var _bottomIconChecked = [
    "images/icon_bottom_main_checked.png",
    "images/icon_bottom_knowledge_checked.png"
  ];

  // 底部导航栏当前选中的页面
  var _currentBottomIndex = 0;

  // controller
  TabController _tabController;
  VoidCallback _tabOnChanged;

  // 页面
  var _body;

  @override
  void initState() {
    _tabController = TabController(length: _bottomTitles.length, vsync: this);
    _tabOnChanged = () {
      setState(() {
        _currentBottomIndex = _tabController.index;
      });
    };
    _tabController.addListener(_tabOnChanged);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.removeListener(_tabOnChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _body = TabBarView(
      children: <Widget>[HomePage(), KnowledgePage()],
      controller: _tabController,
    );

    return Scaffold(
      // 顶部 appBar
      appBar: AppBar(
          // 顶部标题
          title: Text(
            _bottomTitles[_currentBottomIndex],
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            // 搜索，这里后面看还要不要加什么功能放在上面不？现在有些东西怎么放也没有思路
            IconButton(icon: Icon(Icons.search), onPressed: (){}),
          ],
          // icon的主题设置
          iconTheme: IconThemeData(color: Colors.white)),
      // 底部导航栏 CupertinoTabBar是iOS风格的，BottomNavigationBar是Android风格,这里我尽量都使用Android风格的控件。
//          bottomNavigationBar: CupertinoTabBar(items: null),
      bottomNavigationBar: BottomNavigationBar(
        items: getBottomNavigationBarItems(),
        currentIndex: _currentBottomIndex,
        onTap: (index) {
          setState(() {
            _currentBottomIndex = index;
            _tabController.index = index;
          });
        },
      ),
      // body 放 pager，主要是用来切换的这几个页面
      body: _body,
      // 侧滑页面
      drawer: MainDrawerPage(),
    );
  }

  getBottomNavigationBarItems() => List.generate(
      _bottomTitles.length,
      (index) => BottomNavigationBarItem(
          icon: getBottomIcon(index), title: getBottomTitle(index)));

  getBottomTitle(int i) => Text(
        _bottomTitles[i],
        style: TextStyle(
            color: _currentBottomIndex == i ? Colors.green : Colors.grey),
      );

  getBottomIcon(int i) => Image.asset(
        getBottomIconPath(i),
        width: 25.0,
        height: 25.0,
      );

  String getBottomIconPath(int i) =>
      _currentBottomIndex == i ? _bottomIconChecked[i] : _bottomIconNor[i];
}
