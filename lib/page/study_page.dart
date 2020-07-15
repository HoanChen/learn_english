import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_english/bean/ResultListBean.dart';
import 'package:learn_english/bean/WordBean.dart';
import 'package:learn_english/http/HttpUtil.dart';

class StudyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StudyPageState();
}

class StudyPageState extends State<StudyPage>
    with AutomaticKeepAliveClientMixin {
  WordBean _word;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      margin: EdgeInsets.all(10.0),
      color: Colors.redAccent,
      child: Column(children: [
        Center(
          child: Text(_word != null ? _word.toString() : ''),
        ),
        FlatButton(onPressed: _loadData, child: Icon(Icons.refresh))
      ]),
    );
  }

  Future<void> _loadData() async {
    var response =
        await HttpUtil().get<ResultListBean, WordBean>('/api/v1/word/random');
    setState(() {
      if (response.isSuccess()) {
        _word = response.data[0];
      } else {
        _word = null;
      }
    });
  }

  @override
  bool get wantKeepAlive => true;
}
