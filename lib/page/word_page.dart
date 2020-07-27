import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:learn_english/bean/ResultBean.dart';
import 'package:learn_english/bean/ResultListBean.dart';
import 'package:learn_english/bean/WordBean.dart';
import 'package:learn_english/net/HttpUtil.dart';
import 'package:learn_english/widget/DateSwitch.dart';
import 'package:learn_english/widget/EditDialog.dart';
import 'package:learn_english/widget/load_more_view.dart';

class WordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WordPageState();
}

class WordPageState extends State<WordPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  String _dateStr;
  var _list = [];
  var _pageNum = 1;
  var _pageSize = 10;
  var _loadMoreStatus = LoadMoreStatus.STATU_IDEL;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (_loadMoreStatus == LoadMoreStatus.STATU_IDEL) {
          setState(() {
            _loadMoreStatus = LoadMoreStatus.STATU_LOADING;
          });
          _pageNum++;
          _loadData();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _addWord(context, WordBean());
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: Column(children: [
          DateSwitch(
            callback: (dateStr) {
              _dateStr = dateStr;
              _pageNum = 1;
              _loadData();
            },
          ),
          Container(
            color: Colors.black12,
            height: 1.0,
          ),
          Expanded(
              child: RefreshIndicator(
                  onRefresh: () async {
                    _pageNum = 1;
                    _loadData();
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _list.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == _list.length) {
                        return LoadMoreView(loadMoreStatus: _loadMoreStatus);
                      } else {
                        WordBean bean = _list[index];
                        return ListTile(
                          title: Text('${bean.contentEN} => ${bean.contentCN}'),
                          onTap: () {
                            _editWord(context, bean);
                          },
                        );
                      }
                    },
                  )))
        ]));
  }

  Future<void> _loadData() async {
    var response = await HttpUtil.getInstance().get<ResultListBean, WordBean>(
        '/api/v1/word/words/$_pageNum/$_pageSize/$_dateStr');
    if (response.isSuccess()) {
      setState(() {
        if (_pageNum == 1) {
          _loadMoreStatus = LoadMoreStatus.STATU_IDEL;
          _list.clear();
        } else if (response.data.length < 10) {
          _loadMoreStatus = LoadMoreStatus.STATU_NO_MORE;
        } else {
          _loadMoreStatus = LoadMoreStatus.STATU_IDEL;
        }
        _list.addAll(response.data);
      });
    } else {
      _pageNum--;
      Fluttertoast.showToast(msg: response.message);
      setState(() {
        _loadMoreStatus = LoadMoreStatus.STATU_IDEL;
      });
    }
  }

  _editWord(BuildContext context, WordBean bean) async {
    var cnStr = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => EditDialog(word: bean),
    );
    if (cnStr != null) {
      var response = await HttpUtil.getInstance().put<ResultBean, int>(
          '/api/v1/word', WordBean(id: bean.id, contentCN: cnStr));
      Fluttertoast.showToast(msg: response.message);
      if (response.isSuccess()) {
        setState(() {
          bean.contentCN = cnStr;
        });
      } else {
        _editWord(context, bean);
      }
    }
  }

  _addWord(BuildContext context, WordBean wordBean) async {
    var enStr = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => EditDialog(word: wordBean),
    );
    if (enStr != null) {
      var wordBean = WordBean(contentEN: enStr);
      var response = await HttpUtil.getInstance()
          .post<ResultBean, int>('/api/v1/word', wordBean);
      Fluttertoast.showToast(msg: response.message);
      if (response.isSuccess()) {
      } else {
        _addWord(context, wordBean);
      }
    }
  }
}
