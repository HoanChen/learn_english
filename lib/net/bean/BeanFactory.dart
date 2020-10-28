import 'TokensBean.dart';
import 'WordBean.dart';
import 'WordListBean.dart';
import 'login_Info.dart';

class BeanFactory {
  static O generateObject<O>(json) {
    switch (O.toString()) {
      case LoginInfoBean.CLASS_NAME:
        return LoginInfoBean.fromJson(json) as O;
      case TokensBean.CLASS_NAME:
        return TokensBean.fromJson(json) as O;
      case WordBean.CLASS_NAME:
        return WordBean.fromJson(json) as O;
      case WordListBean.CLASS_NAME:
        return WordListBean.fromJson(json) as O;
      default:
        if (json is O) {
          return json;
        } else {
          throw Exception('请在请求方法上设置正确泛型！');
        }
    }
  }
}
