import 'package:dio/dio.dart';
import 'package:learn_english/bean/BeanFactory.dart';
import 'package:learn_english/net/ResultUtil.dart';

class ResultBean<O> {
  static const CLASS_NAME = 'ResultBean<dynamic>';

  String code, message, serviceVersion;
  O data;

  ResultBean.error(String message) {
    this.code = '000000';
    this.message = message;
  }

  ResultBean.fromJson(Map<String, dynamic> json, DioError error) {
    if (error != null) {
      code = ResultUtil.errorCode(error);
      message = ResultUtil.errorMessage(error);
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
