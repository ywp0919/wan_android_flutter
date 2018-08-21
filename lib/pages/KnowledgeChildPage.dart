import 'package:flutter/material.dart';
import 'package:WanAndroid/pages/KnowledgeChildListPage.dart';

/// tab数据从外面传入。知识体系的二级页面
class KnowledgeChildPage extends StatefulWidget {
  final _data;

  KnowledgeChildPage(this._data);

  @override
  State<StatefulWidget> createState() => KnowledgeChildPageState(_data);
}

class KnowledgeChildPageState extends State<KnowledgeChildPage> {
  final _data;

  KnowledgeChildPageState(this._data);

  @override
  void initState() {
    super.initState();
  }

  /// 参考 https://flutterchina.club/catalog/samples/tabbed-app-bar/ 使用
  @override
  Widget build(BuildContext context) {
    // 生成需要的tab和tabView
    List<Tab> _tabs = List();
    List<Widget> _tabBarViews = List();
    var children = _data["children"];
    for (var value in children) {
      _tabs.add(Tab(
        text: value["name"],
      ));
      _tabBarViews.add(KnowledgeChildListPage(value["id"]));
    }

    return DefaultTabController(
      length: _data["children"].length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_data["name"] != null ? _data["name"] : "体系列表"),
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: _tabs,
            isScrollable: true,
          ),
        ),
        body: TabBarView(children: _tabBarViews),
      ),
    );
  }
}
