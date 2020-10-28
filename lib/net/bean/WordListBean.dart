import 'BeanFactory.dart';
import 'WordBean.dart';

class WordListBean {
  static const CLASS_NAME = 'WordListBean';
  int total;
  int pages;
  List<WordBean> dataList;

  WordListBean({this.total, this.pages, this.dataList});

  WordListBean.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    pages = json['pages'];
    if (json['dataList'] != null) {
      dataList = List<WordBean>();
      (json['dataList'] as List).forEach((element) {
        dataList.add(BeanFactory.generateObject<WordBean>(element));
      });
    }
  }
}
