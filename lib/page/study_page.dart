import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_english/common/MyColors.dart';
import 'package:learn_english/net/api/Api.dart';
import 'package:learn_english/net/bean/WordBean.dart';
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
      _buildTopTips(),
      DateSwitch(
        dateStr: _dateStr,
        callback: (dateStr) {
          _dateStr = dateStr;
          _loadData();
        },
      ),
      SizedBox(
          height: 100.0,
          child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: Text(
                _word != null ? _word.contentEN : '',
                style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.w500),
              )))
    ];
    if (_word != null) {
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

  _loadData() {
    Api.getInstance().wordApi.randomWord(_dateStr).then((value) => setState(() {
          _revertEnable = false;
          _word = value;
          if (value != null) _showCN = false;
        }));
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

  _markWord(int id, bool markUp) {
    Api.getInstance().wordApi.markWord(id, markUp).then((value) => setState(() {
          _revertEnable = !markUp;
          if (value) {
            _showCN = true;
          }
        }));
  }

  ///透明度实现 invisible
  Widget _buildTopTips() => Opacity(
      opacity: _revertEnable ? 1.0 : 0.0,
      child: Container(
          color: Colors.black12,
          child: Padding(
              padding: EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
              child: Row(
                children: <Widget>[
                  Text('确定认得该词？'),
                  GestureDetector(
                    onTap: _revertEnable
                        ? () {
                            if (_word != null) _markWord(_word.id, true);
                          }
                        : null,
                    child: Text(
                      '记错了',
                      style: TextStyle(color: MyColors.accentColor),
                    ),
                  ),
                  Expanded(
                      child: GestureDetector(
                    onTap: _revertEnable
                        ? () {
                            //TODO
                            // if (_word != null)
                            //   Api.getInstance()
                            //       .wordApi
                            //       .deleteWord(_word.id)
                            //       .then((value) => {if (value) _loadData()});
                          }
                        : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Icon(Icons.delete_forever),
                        Text(
                          '太简单',
                        )
                      ],
                    ),
                  ))
                ],
              ))));
}
