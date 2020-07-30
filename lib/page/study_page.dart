import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:learn_english/bean/ResultBean.dart';
import 'package:learn_english/bean/ResultListBean.dart';
import 'package:learn_english/bean/WordBean.dart';
import 'package:learn_english/bean/WordMarkBean.dart';
import 'package:learn_english/common/LoginInfoUtil.dart';
import 'package:learn_english/common/MyColors.dart';
import 'package:learn_english/net/HttpUtil.dart';
import 'package:learn_english/widget/DateSwitch.dart';

class StudyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StudyPageState();
}

class StudyPageState extends State<StudyPage>
    with AutomaticKeepAliveClientMixin {
  String _dateStr;
  WordBean _word;
  var _showCN = false;
  var _revertEnable = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var children = [
      DateSwitch(
        dateStr: _dateStr,
        callback: (dateStr) {
          _dateStr = dateStr;
          _loadData();
        },
      ),
      SizedBox(
          height: 150.0,
          child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Text(
                _word != null ? _word.contentEN : '',
                style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.w500),
              )))
    ];
    if (_word != null) {
      if (_revertEnable) {
        children.insert(0, _buildTopTips());
      }
      children.addAll([
        Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 100.0),
            child: Text(
              _showCN ? '${_word != null ? _word.contentCN ?? '' : ''}' : '',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
            )),
        _buildButton(_showCN ? '下一个' : '我认识', MyColors.accentColor, () {
          if (_showCN) {
            _loadData();
          } else {
            if (_word != null) _markWord(_word.id, false);
          }
        }),
        SizedBox(
          height: 10.0,
        ),
        _showCN
            ? SizedBox()
            : _buildButton('提示一下', MyColors.orange, () {
                if (_word != null) _markWord(_word.id, true);
              })
      ]);
    } else {
      children.add(Text('暂无数据'));
    }
    return Container(
      child: Column(children: children),
    );
  }

  Future<void> _loadData() async {
    var response = await HttpUtil().get<ResultListBean, WordBean>(
        '/api/v1/word/random',
        params: {'monthDate': _dateStr});
    setState(() {
      if (response.isSuccess() && response.data.isNotEmpty) {
        _showCN = false;
        _word = response.data[0];
      } else {
        _word = null;
        Fluttertoast.showToast(msg: response.message);
      }
    });
  }

  @override
  bool get wantKeepAlive => true;

  _buildButton(String text, Color color, Function() onPressed) =>
      MaterialButton(
          minWidth: 250.0,
          height: 46.0,
          shape: RoundedRectangleBorder(
              side: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(46))),
          onPressed: onPressed,
          color: color,
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 18.0),
          ));

  _markWord(int id, bool markUp) async {
    var response = await HttpUtil().post<ResultBean, Object>(
        '/api/v1/word/mark',
        WordMarkBean(
            userId: LoginInfoUtil().getInfo().userBean.id,
            wordId: id,
            markUp: markUp));
    setState(() {
      _revertEnable = !markUp;
      if (response.isSuccess()) {
        _showCN = true;
      } else {
        Fluttertoast.showToast(msg: response.message);
      }
    });
  }

  Widget _buildTopTips() => Container(
      color: Colors.black12,
      child: Padding(
          padding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
          child: Row(
            children: <Widget>[
              Text('确定认得该词？'),
              GestureDetector(
                onTap: () {
                  if (_word != null) _markWord(_word.id, true);
                },
                child: Text(
                  '记错了',
                  style: TextStyle(color: MyColors.accentColor),
                ),
              )
            ],
          )));
}
