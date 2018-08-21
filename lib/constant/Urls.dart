class Urls {
  static const String BASE_URL = "http://www.wanandroid.com/";

  /// 文章列表  后面的参数在使用的时候加吧。
  static const String ARTICLE_LIST = BASE_URL + "article/list/";

  /// 首页banner
  static const String HOME_BANNER_DATA = BASE_URL + "banner/json";

  /// 体系数据
  static const String TREE_DATA = BASE_URL + "tree/json";

  /// 注册
  static const String REGISTER = BASE_URL + "user/register";

  /// 登录
  static const String LOGIN = BASE_URL + "user/login";

  /// 收藏站内文章，还有一个收站外文章没懂是怎么用，先用着这一个了。
  static const String ARTICLE_COLLECT_INNER = BASE_URL + "lg/collect/";

  /// 文章列表的取消收藏 http://www.wanandroid.com/lg/uncollect_originId/2333/json
  static const String ARTICLE_UN_COLLECT = BASE_URL + "lg/uncollect_originId/";

  /// 喜欢的文章列表
  static const String COLLECT_ARTICLE_LIST = BASE_URL + "lg/collect/list/";

  /// 某一个分类下项目列表数据，分页展示 project/list/1/json?cid=294
  static const String KNOWLEDGE_PROJECT_LIST = BASE_URL + "project/list/";
}
