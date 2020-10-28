import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_english/net/api/Api.dart';
import 'package:learn_english/net/bean/WordBean.dart';
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
          setState(() {
            _loadMoreStatus = LoadMoreStatus.LOADING;
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
                                    setState(() {
                                      _loadMoreStatus = LoadMoreStatus.LOADING;
                                    });
                                    _pageNum++;
                                    _loadData();
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

  void _loadData() {
    Api.getInstance()
        .wordApi
        .loadWords(pageNum: _pageNum, dateStr: _dateStr)
        .then((value) => {
              if (value != null)
                setState(() {
                  if (_pageNum == 1) {
                    _loadMoreStatus = LoadMoreStatus.IDLE;
                    _list.clear();
                  } else if (value.length < 10) {
                    _loadMoreStatus = LoadMoreStatus.NO_MORE;
                  } else {
                    _loadMoreStatus = LoadMoreStatus.IDLE;
                  }
                  _list.addAll(value);
                })
              else
                setState(() {
                  _pageNum--;
                  _loadMoreStatus = LoadMoreStatus.IDLE;
                })
            });
  }

  _editWord(BuildContext context, WordBean bean) async {
    var ok = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => EditDialog(word: bean),
    );
    if (ok)
      Api.getInstance().wordApi.editWord(bean).then((value) =>
          {if (value) setState(() {}) else _editWord(context, bean)});
  }

  _addWord(BuildContext context, WordBean wordBean) {
    showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => EditDialog(
              word: wordBean,
              confirmCallback: () => Api.getInstance()
                  .wordApi
                  .addWord(wordBean, _dateStr)
                  .then((value) => {
                        if (value != null)
                          setState(() {
                            _list.add(WordBean(
                                id: value,
                                contentEN: wordBean.contentEN,
                                contentCN: wordBean.contentCN,
                                createTime: wordBean.createTime));
                          })
                        else
                          _addWord(context, wordBean)
                      }),
            ));
  }
}
