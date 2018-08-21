import 'package:event_bus/event_bus.dart';

class EventUtils{

  static EventBus appEvent = EventBus();

  /// 登录成功
  static const EVENT_LOGIN = "event_login";

  /// 退出登录
  static const EVENT_LOGOUT = "event_logout";
}