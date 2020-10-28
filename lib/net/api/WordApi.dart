import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:learn_english/net/HttpUtil.dart';
import 'package:learn_english/net/bean/ResultBean.dart';
import 'package:learn_english/net/bean/ResultListBean.dart';
import 'package:learn_english/net/bean/WordBean.dart';
import 'package:learn_english/net/bean/WordListBean.dart';
import 'package:learn_english/net/bean/WordMarkBean.dart';

class WordApi {
  static const _pageSize = 10;

  Future<List<WordBean>> loadWords(
      {@required int pageNum,
      int pageSize = _pageSize,
      @required String dateStr}) async {
    var response = await HttpUtil().get<ResultBean, WordListBean>(
        '/api/v1/word/words/$pageNum/$_pageSize/$dateStr');
    if (response.isSuccess()) {
      return response.data.dataList;
    } else {
      Fluttertoast.showToast(msg: response.message);
      return null;
    }
  }

  Future<WordBean> randomWord(String dateStr) async {
    var response = await HttpUtil().get<ResultListBean, WordBean>(
        '/api/v1/word/random',
        params: {'monthDate': dateStr});
    if (response.isSuccess() && response.data.isNotEmpty) {
      return response.data[0];
    } else {
      Fluttertoast.showToast(msg: response.message);
      return null;
    }
  }

  Future<int> addWord(WordBean wordBean, String dateStr) async {
    var response = await HttpUtil().post<ResultBean, int>(
        '/api/v1/word', wordBean..createTime = '$dateStr-01');
    Fluttertoast.showToast(msg: response.message);
    if (response.isSuccess()) {
      return response.data;
    } else {
      return null;
    }
  }

  Future<bool> editWord(WordBean wordBean) async {
    var response =
        await HttpUtil().put<ResultBean, int>('/api/v1/word', wordBean);
    Fluttertoast.showToast(msg: response.message);
    return response.isSuccess();
  }

  Future<bool> deleteWord(int id) async {
    var response = await HttpUtil().delete<ResultBean, int>('/api/v1/word/$id');
    Fluttertoast.showToast(msg: response.message);
    return response.isSuccess();
  }

  Future<bool> markWord(int id, bool markUp) async {
    var response = await HttpUtil().post<ResultBean, Object>(
        '/api/v1/word/mark', WordMarkBean(wordId: id, markUp: markUp));
    return response.isSuccess();
  }
}
