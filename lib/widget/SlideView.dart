import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// 参考flutter-osc修改的。
class SlideView extends StatefulWidget {
  var data;

  SlideView(this.data);

  @override
  State<StatefulWidget> createState() {
    return new SlideViewState(data);
  }
}

class SlideViewState extends State<SlideView>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  List data;

  SlideViewState(this.data);

  @override
  void initState() {
    super.initState();
    tabController =
        new TabController(length: data == null ? 0 : data.length, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [];
    if (data != null && data.length > 0) {
      items.addAll(List.generate(data.length, (i) {
        var item = data[i];
        return GestureDetector(
            onTap: () {
              _handOnItemClick(item);
            },
            child: AspectRatio(
              aspectRatio: 2.0 / 1.0,
              child: Stack(
                children: <Widget>[
                  Container(
                    child: CachedNetworkImage(
                      width: MediaQuery.of(context).size.width,
                      imageUrl: item['imagePath'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: new Container(
                      width: MediaQuery.of(context).size.width,
                      color: Color(0x44000000),
                      padding: EdgeInsets.all(5.0),
                      child: Text(item['title'],
                          style:
                              TextStyle(color: Colors.white, fontSize: 14.0)),
                    ),
                  ),
                ],
              ),
            ));
      }));
    }
    return new TabBarView(
      controller: tabController,
      children: items,
    );
  }

  void _handOnItemClick(itemData) {
//    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
//      return new ArticleDetailPage(title:itemData['title'],url: itemData['link']);
//    }));
  }
}
