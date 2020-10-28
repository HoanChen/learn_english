import 'package:learn_english/net/api/LoginApi.dart';
import 'package:learn_english/net/api/WordApi.dart';

class Api {
  static Api _singleton;

  factory Api() => getInstance();

  static Api getInstance() {
    if (_singleton == null) {
      _singleton = Api._internal();
    }
    return _singleton;
  }

  Api._internal() {
    //do something
  }

  final WordApi wordApi = WordApi();

  final LoginApi loginApi = LoginApi();
}
