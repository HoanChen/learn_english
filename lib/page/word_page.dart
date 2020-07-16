import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_english/bean/ResultBean.dart';
import 'package:learn_english/bean/ResultListBean.dart';
import 'package:learn_english/bean/WordBean.dart';
import 'package:learn_english/common/MyColors.dart';
import 'package:learn_english/http/HttpUtil.dart';
import 'package:learn_english/widget/EditDialog.dart';

class WordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WordPageState();
}

class WordPageState extends State<WordPage> with AutomaticKeepAliveClientMixin {
  var _list = [];
  var _pageNum = 1;
  var _pageSize = 10;
  var _loadMoreStatus = 10;
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
        child: RefreshIndicator(
            onRefresh: () async {
              _pageNum = 0;
              _loadData();
            },
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                WordBean bean = _list[index];
                return ListTile(
                  title: Text('${bean.contentEN} => ${bean.contentCN}'),
                  onTap: () => {_editWord(context, bean)},
                );
              },
              itemCount: _list.length,
            )));
  }

  _editWord(BuildContext context, WordBean bean) async {
    var cnStr = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => EditDialog(word: bean),
    );
    if (cnStr != null) {
      var response = await HttpUtil().put<ResultBean, int>(
          '/api/v1/word', WordBean(bean.id, bean.contentEN, cnStr));
      if (response.isSuccess()) {
        setState(() {
          bean.contentCN = cnStr;
        });
      } else {
        _editWord(context, bean);
      }
    }
  }

  Future<void> _loadData() async {
    var response = await HttpUtil().get<ResultListBean, WordBean>(
        '/api/v1/word/words/$_pageNum/$_pageSize');
    if (response.isSuccess()) {
      setState(() {
        if (_pageNum == 0) {
          _list.clear();
        }
        _list.addAll(response.data);
      });
    } else {
      _pageNum--;
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: new Text(response.message)));
    }
  }

  @override
  bool get wantKeepAlive => true;
}
