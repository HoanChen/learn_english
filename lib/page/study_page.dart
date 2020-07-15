import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_english/bean/ResultListBean.dart';
import 'package:learn_english/bean/WordBean.dart';
import 'package:learn_english/common/MyColors.dart';
import 'package:learn_english/http/HttpUtil.dart';

class StudyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StudyPageState();
}

class StudyPageState extends State<StudyPage>
    with AutomaticKeepAliveClientMixin {
  WordBean _word;
  var _showCN = false;
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      margin: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
      child: Column(children: [
        SizedBox(
            height: 150.0,
            child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Text(
                  _word != null ? _word.contentEN : '',
                  style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.w500),
                ))),
        Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 100.0),
            child: Text(
              _showCN ? '翻译：${_word != null ? _word.contentCN ?? '' : ''}' : '',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
            )),
        _buildButton(_showCN ? '下一个' : '我认识', MyColors.accentColor, () {
          if (_showCN) {
            _loadData();
          } else {
            setState(() {
              _showCN = true;
            });
          }
        }),
        SizedBox(
          height: 10.0,
        ),
        _showCN
            ? SizedBox()
            : _buildButton('提示一下', Color(0xFFFF935C), () {
                setState(() {
                  _showCN = true;
                });
              }),
      ]),
    );
  }

  Future<void> _loadData() async {
    var response =
        await HttpUtil().get<ResultListBean, WordBean>('/api/v1/word/random');
    setState(() {
      _showCN = false;
      if (response.isSuccess()) {
        _word = response.data[0];
      } else {
        _word = null;
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
}
