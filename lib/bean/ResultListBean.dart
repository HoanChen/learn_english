import 'BeanFactory.dart';

class ResultListBean<O> {
  static const CLASS_NAME = 'ResultListBean<dynamic>';

  String code;
  String message;
  String serviceVersion;
  List<O> data;

  ResultListBean.fromJson(Map<String, dynamic> json) {
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

  bool isSuccess() => code == '10000';
}
