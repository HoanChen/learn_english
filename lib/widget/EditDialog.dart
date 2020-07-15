import 'dart:math';

import 'package:flutter/material.dart';
import 'package:learn_english/common/MyColors.dart';

import '../bean/ResultBean.dart';
import '../bean/WordBean.dart';
import '../http/HttpUtil.dart';

class EditDialog extends Dialog {
  WordBean word;

  EditDialog({Key key, @required this.word}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _controller = TextEditingController();
    _controller.addListener(() {
      word.contentCN = _controller.text.toString();
    });
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Material(
        type: MaterialType.transparency,
        child: Column(children: [
          Container(
            decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)))),
            margin: EdgeInsets.all(12.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Stack(
                    alignment: AlignmentDirectional.centerEnd,
                    children: <Widget>[
                      Center(
                        child: Text(word.contentEN),
                      )
                    ],
                  ),
                ),
                Container(
                  color: Color(0xffe0e0e0),
                  height: 1.0,
                ),
                Container(
                    constraints: BoxConstraints(minHeight: 130.0),
                    child: Padding(
                      padding: EdgeInsets.only(left: 30.0, right: 30.0),
                      child: Center(
                        child: TextField(
                          controller: _controller,
                        ),
                      ),
                    )),
                Container(
                  color: Colors.black12,
                  height: 1.0,
                ),
                Row(
                  children: <Widget>[
                    Expanded(child: _buildBottomButton(context, false)),
                    Container(
                      color: Colors.black12,
                      height: 50.0,
                      width: 1.0,
                    ),
                    Expanded(child: _buildBottomButton(context, true)),
                  ],
                )
              ],
            ),
          )
        ]),
      ),
    );
  }

  _buildBottomButton(BuildContext context, bool poistive) => MaterialButton(
        height: 50.0,
        onPressed: () {
          if (poistive) {
            _postData(context);
          } else {
            Navigator.pop(context);
          }
        },
        child: Text(
          poistive ? '确认' : '取消',
          style: TextStyle(
              fontSize: 16.0,
              color: poistive ? MyColors.accentColor : Colors.black),
        ),
      );

  void _postData(BuildContext context) async {
    var response = await HttpUtil().put<ResultBean, int>('/api/v1/word', word);
    if (response.isSuccess()) {
      Navigator.pop(context);
    }
  }
}
