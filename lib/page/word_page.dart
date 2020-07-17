import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_english/bean/ResultBean.dart';
import 'package:learn_english/bean/ResultListBean.dart';
import 'package:learn_english/bean/WordBean.dart';
import 'package:learn_english/common/MyColors.dart';
import 'package:learn_english/http/HttpUtil.dart';
import 'package:learn_english/widget/EditDialog.dart';
import 'package:learn_english/widget/load_more_view.dart';

class WordPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WordPageState();
}

class WordPageState extends State<WordPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  DateTime _date;
  String _dateStr;
  var _dateType = 0; //0 时间最小，2 时间最大
  var _list = [];
  var _pageNum = 1;
  var _pageSize = 10;
  var _loadMoreStatus = LoadMoreStatus.STATU_IDEL;
  ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _setDateField(DateTime.now());
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
    _loadData();
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
          _buildTopDate(),
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

  _buildTopDate() => Padding(
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Visibility(
            visible: _dateType != 0,
            child: IconButton(
              onPressed: () {
                setState(() {
                  int _year = _date.year;
                  int _month = _date.month;
                  if (_date.month == 1) {
                    _year -= 1;
                    _month = 12;
                  } else {
                    _month -= 1;
                  }
                  _setDateField(DateTime(_year, _month));
                });
                _pageNum = 1;
                _loadData();
              },
              icon: Icon(Icons.chevron_left),
            )),
        GestureDetector(
            onTap: () {
              showDatePicker(
                context: context,
                initialDate: _date,
                firstDate: DateTime(2020, 5),
                lastDate: new DateTime.now(),
              ).then((DateTime dateTime) {
                if (dateTime != null) {
                  setState(() {
                    _setDateField(dateTime);
                  });
                  _pageNum = 1;
                  _loadData();
                }
              });
            },
            child: Text(
              _dateStr,
              style: TextStyle(fontSize: 15.0, color: MyColors.accentColor),
            )),
        Visibility(
            visible: _dateType != 2,
            child: IconButton(
              onPressed: () {
                setState(() {
                  int _year = _date.year;
                  int _month = _date.month;
                  if (_date.month == 12) {
                    _year += 1;
                    _month = 1;
                  } else {
                    _month += 1;
                  }
                  _setDateField(DateTime(_year, _month));
                });
                _pageNum = 1;
                _loadData();
              },
              icon: Icon(Icons.chevron_right),
            )),
      ]));

  Future<void> _loadData() async {
    var response = await HttpUtil().get<ResultListBean, WordBean>(
        '/api/v1/word/words/$_dateStr/$_pageNum/$_pageSize');
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
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: new Text(response.message)));
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
      var response = await HttpUtil().put<ResultBean, int>(
          '/api/v1/word', WordBean(id: bean.id, contentCN: cnStr));
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
      var response =
          await HttpUtil().post<ResultBean, int>('/api/v1/word', wordBean);
      if (response.isSuccess()) {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: new Text(response.message)));
      } else {
        _addWord(context, wordBean);
      }
    }
  }

  void _setDateField(DateTime dateTime) {
    _date = dateTime;
    _dateStr =
        "${_date.year.toString()}-${_date.month.toString().padLeft(2, '0')}";
    var now = DateTime.now();
    if (_date.year == now.year && _date.month == now.month) {
      _dateType = 2;
    } else if (_date.year == 2020 && _date.month == 5) {
      _dateType = 0;
    } else {
      _dateType = 1;
    }
  }
}
