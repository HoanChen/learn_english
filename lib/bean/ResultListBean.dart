import 'package:dio/dio.dart';
import 'package:learn_english/net/ResultUtil.dart';

import 'BeanFactory.dart';

class ResultListBean<O> {
  static const CLASS_NAME = 'ResultListBean<dynamic>';

  String code, message, serviceVersion;
  List<O> data;

  ResultListBean.fromJson(Map<String, dynamic> json, DioError error) {
    if (error != null) {
      code = ResultUtil.errorCode(error);
      message = ResultUtil.errorMessage(error);
    } else {
      code = json['code'];
      message = json['message'];
      serviceVersion = json['serviceVersion'];
      if (json['data'] != null) {
        data = List<O>();
        (json['data'] as List).forEach((element) {
          data.add(BeanFactory.generateObject<O>(element));
        });
      }
    }
  }

  bool isSuccess() => code == '10000';
}
