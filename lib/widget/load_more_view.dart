import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_english/common/MyColors.dart';

class LoadMoreView extends StatelessWidget {
  final LoadMoreStatus loadMoreStatus;
  final GestureTapCallback onLoadMoreClick;

  LoadMoreView({Key key, @required this.loadMoreStatus, this.onLoadMoreClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onLoadMoreClick,
        child: Row(
          children: <Widget>[
            _buildProgress(),
            Padding(
                child: Text(
                  _getText(),
                  style: TextStyle(fontSize: 14.0),
                ),
                padding: EdgeInsets.all(10.0)),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ));
  }

  _buildProgress() => Visibility(
      visible: loadMoreStatus == LoadMoreStatus.LOADING ? true : false,
      child: SizedBox(
        height: 20.0,
        width: 20.0,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(MyColors.accentColor),
        ),
      ));

  String _getText() {
    switch (loadMoreStatus) {
      case LoadMoreStatus.IDLE:
        return '${this.onLoadMoreClick == null ? "上拉" : "点击"}加载更多🚀';
      case LoadMoreStatus.LOADING:
        return '正在加载中🚚';
      case LoadMoreStatus.NO_MORE:
        return '已到世界的尽头⛔';
      default:
        return '';
    }
  }
}

enum LoadMoreStatus { IDLE, LOADING, NO_MORE }
