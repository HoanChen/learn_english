import 'package:dio/dio.dart';
import 'package:learn_english/net/ResultUtil.dart';

import 'BeanFactory.dart';

class ResultListBean<O> {
  static const CLASS_NAME = 'ResultListBean<dynamic>';

  String code, message, serviceVersion;
  List<O> dataList;

  ResultListBean.fromJson(Map<String, dynamic> json, DioError error) {
    if (error != null) {
      code = ResultUtil.errorCode(error);
      message = ResultUtil.errorMessage(error);
    } else {
      code = json['code'];
      message = json['message'];
      serviceVersion = json['serviceVersion'];
      var dataJson = json['data'];
      if (dataJson != null) {
        var dataListJson = dataJson['dataList'];
        if (dataListJson != null) {
          dataList = List<O>();
          (dataListJson as List).forEach((element) {
            dataList.add(BeanFactory.generateObject<O>(element));
          });
        }
      }
    }
  }

  bool isSuccess() => code == '10000';
}
