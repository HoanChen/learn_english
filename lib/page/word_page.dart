import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_english/bean/ResultListBean.dart';
import 'package:learn_english/bean/WordBean.dart';
import 'package:learn_english/http/HttpUtil.dart';

class WordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WordPageState();
}

class WordPageState extends State<WordPage> with AutomaticKeepAliveClientMixin {
  var _list = [];
  var _pageNum = 1;
  var _pageSize = 1;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
        child: RefreshIndicator(
            onRefresh: _loadData,
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(_list[index].contentEN),
                );
              },
              itemCount: _list.length,
            )));
  }

  Future<void> _loadData() async {
    var response = await HttpUtil().get<ResultListBean, WordBean>(
        '/api/v1/word/words/${_pageNum++}/$_pageSize');
    if (response.isSuccess()) {
      setState(() {
        _list.addAll(response.data);
      });
    } else {
      _pageNum--;
    }
  }

  @override
  bool get wantKeepAlive => true;
}
