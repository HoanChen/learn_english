import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:learn_english/bean/ResultBean.dart';
import 'package:learn_english/bean/WordBean.dart';
import 'package:learn_english/bean/WordListBean.dart';
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
  var _loadMoreStatus = LoadMoreStatus.IDLE;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (_loadMoreStatus == LoadMoreStatus.IDLE) {
          _loadMore();
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
            dateStr: _dateStr,
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
                  child: ListView.separated(
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: _scrollController,
                    itemCount: _list.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (_list.isEmpty) {
                        return Container(
                            height: 400, child: Center(child: Text('暂无数据')));
                      } else if (index == _list.length) {
                        return LoadMoreView(
                            loadMoreStatus: _loadMoreStatus,
                            onLoadMoreClick: index > 8
                                ? null
                                : () {
                                    _loadMore();
                                  });
                      } else {
                        WordBean bean = _list[index];
                        return Dismissible(
                            onDismissed: (_) {
                              //参数暂时没有用到，则用下划线表示
                              setState(() {
                                _list.removeAt(index);
                              });
                            },
                            // 监听
                            movementDuration: Duration(milliseconds: 100),
                            key: Key(bean.id.toString()),
                            child: ListTile(
                              title: Text(
                                  '${bean.contentEN}  ${bean.contentCN ?? ""}'),
                              onTap: () {
                                _editWord(context, bean);
                              },
                            ),
                            background: Container(
                              color: Colors.black12,
                            ));
                      }
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(height: 1.0, color: Colors.black12),
                  )))
        ]));
  }

  Future<void> _loadData() async {
    var response = await HttpUtil().get<ResultBean, WordListBean>(
        '/api/v1/word/words/$_pageNum/$_pageSize/$_dateStr');
    if (response.isSuccess()) {
      setState(() {
        if (_pageNum == 1) {
          _loadMoreStatus = LoadMoreStatus.IDLE;
          _list.clear();
        } else if (response.data.dataList.length < 10) {
          _loadMoreStatus = LoadMoreStatus.NO_MORE;
        } else {
          _loadMoreStatus = LoadMoreStatus.IDLE;
        }
        _list.addAll(response.data.dataList);
      });
    } else {
      _pageNum--;
      Fluttertoast.showToast(msg: response.message);
      setState(() {
        _loadMoreStatus = LoadMoreStatus.IDLE;
      });
    }
  }

  void _loadMore() {
    setState(() {
      _loadMoreStatus = LoadMoreStatus.LOADING;
    });
    _pageNum++;
    _loadData();
  }

  _editWord(BuildContext context, WordBean bean) async {
    var ok = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => EditDialog(word: bean),
    );
    if (ok) _doEditWord(bean);
  }

  void _doEditWord(WordBean bean) async {
    var response = await HttpUtil().put<ResultBean, int>('/api/v1/word', bean);
    Fluttertoast.showToast(msg: response.message);
    if (response.isSuccess()) {
      setState(() {});
    } else {
      _editWord(context, bean);
    }
  }

  _addWord(BuildContext context, WordBean wordBean) {
    showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => EditDialog(
              word: wordBean,
              confirmCallback: () => _doAddWord(wordBean),
            ));
  }

  _doAddWord(WordBean wordBean) async {
    var response = await HttpUtil().post<ResultBean, int>(
        '/api/v1/word', wordBean..createTime = '$_dateStr-01');
    Fluttertoast.showToast(msg: response.message);
    if (response.isSuccess()) {
      setState(() {
        _list.add(WordBean(
            id: response.data,
            contentEN: wordBean.contentEN,
            contentCN: wordBean.contentCN,
            createTime: wordBean.createTime));
      });
    } else {
      _addWord(context, wordBean);
    }
  }
}
