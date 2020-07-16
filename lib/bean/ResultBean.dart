import 'package:dio/dio.dart';
import 'package:learn_english/bean/BeanFactory.dart';
import 'package:learn_english/http/NetUtil.dart';

class ResultBean<O> {
  static const CLASS_NAME = 'ResultBean<dynamic>';

  String code;
  String message;
  String serviceVersion;
  O data;

  ResultBean.fromJson(Map<String, dynamic> json, DioError error) {
    if (error != null) {
      code = NetUtil.errorCode(error);
      message = NetUtil.errorMessage(error);
    } else {
      code = json['code'];
      message = json['message'];
      serviceVersion = json['serviceVersion'];
      data = json['data'] != null
          ? BeanFactory.generateObject<O>(json['data'])
          : null;
    }
  }

  bool isSuccess() => code == '10000';
}
