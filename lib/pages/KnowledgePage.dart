import 'package:flutter/material.dart';
import 'package:WanAndroid/http/HttpUtils.dart';
import 'package:WanAndroid/constant/Urls.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'package:WanAndroid/pages/KnowledgeChildPage.dart';

class KnowledgePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => KnowledgePageState();
}

/// 这个就没有上拉加载更多了，只用做一个刷新的就行了。
class KnowledgePageState extends State<KnowledgePage> {

  /// 体系数据
  var _treeData;

  Future<Null> _refresh() async {
    getTreeData();
    return null;
  }

  @override
  void initState() {
    getTreeData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      body: _treeData == null
          ? Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation(Theme.of(context).primaryColor),
              ),
            )
          : RefreshIndicator(
              child: ListView.builder(
                itemBuilder: (context, index) => getItemView(index),
                itemCount: _treeData == null ? 0 : _treeData.length,
              ),
              onRefresh: _refresh));

  /// 生成 item widget
  getItemView(int index) {
    var item = _treeData[index];
    var children = item["children"];
    StringBuffer contentString = StringBuffer();
    for (var value in children) {
      contentString.write("${value['name']}   ");
    }

    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 2.0,
      child: InkWell(
        onTap: () {
          /// 点击事件
//          Fluttertoast.showToast(
//              msg: "点击了${item["name"]}",
//              gravity: ToastGravity.CENTER,
//              bgcolor: "#99000000",
//              textcolor: '#ffffff');
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>KnowledgeChildPage(item)));
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    item["name"],
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 18.0, color: Theme.of(context).primaryColor),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      contentString.toString(),
                      softWrap: true,
                      textAlign: TextAlign.left,
                    ),
                  )
                ],
              )),
              Icon(Icons.navigate_next)
            ],
          ),
        ),
      ),
    );
  }

  /// 获取数据
  void getTreeData() {
    HttpUtils.get(Urls.TREE_DATA).then((response) {
//      print(response);
      if (response != null && response.isNotEmpty) {
        Map<String, dynamic> resultMap = jsonDecode(response);
        var datas = resultMap["data"];
        if (resultMap["errorCode"] == 0 && datas != null) {
          setState(() {
            _treeData = datas;
          });
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
