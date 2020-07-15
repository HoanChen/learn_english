import 'package:learn_english/bean/BeanFactory.dart';

class ResultBean<O> {
  static const CLASS_NAME = 'ResultBean<dynamic>';

  String code;
  String message;
  String serviceVersion;
  O data;

  ResultBean.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    serviceVersion = json['serviceVersion'];
    data = json['data'] != null
        ? BeanFactory.generateObject<O>(json['data'])
        : null;
  }

  bool isSuccess() => code == '10000';
}
