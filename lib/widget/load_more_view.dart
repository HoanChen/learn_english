import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_english/common/MyColors.dart';

class LoadMoreView extends StatelessWidget {
  final LoadMoreStatus loadMoreStatus;

  LoadMoreView({Key key, @required this.loadMoreStatus}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        _bulidProgress(),
        Padding(
            child: Text(
              _getText(),
              style: TextStyle(fontSize: 14.0),
            ),
            padding: EdgeInsets.all(10.0)),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  _bulidProgress() => Visibility(
      visible: loadMoreStatus == LoadMoreStatus.STATU_LOADING ? true : false,
      child: SizedBox(
        height: 20.0,
        width: 20.0,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(MyColors.accentColor),
        ),
      ));

  String _getText() {
    switch (loadMoreStatus) {
      case LoadMoreStatus.STATU_IDEL:
        return '上拉加载更多🚀';
      case LoadMoreStatus.STATU_LOADING:
        return '正在加载中🚚';
      case LoadMoreStatus.STATU_NO_MORE:
        return '已到世界的尽头⛔';
      default:
        return '';
    }
  }
}

enum LoadMoreStatus { STATU_LOADING, STATU_NO_MORE, STATU_IDEL }
