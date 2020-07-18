import 'package:learn_english/bean/WordBean.dart';
import 'package:learn_english/bean/login_Info.dart';

class BeanFactory {
  static O generateObject<O>(json) {
    switch (O.toString()) {
      case LoginInfoBean.CLASS_NAME:
        return LoginInfoBean.fromJson(json) as O;
      case WordBean.CLASS_NAME:
        return WordBean.fromJson(json) as O;
      default:
        if (json is O) {
          return json;
        } else {
          throw Exception('请在请求方法上设置正确泛型！');
        }
    }
  }
}
