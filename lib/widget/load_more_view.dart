import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_english/common/MyColors.dart';

///https://www.jianshu.com/p/270357939247
class LoadMoreView extends StatelessWidget {
  final LoadMoreStatus loadMoreStatus;

  LoadMoreView({Key key, @required this.loadMoreStatus}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[_bulidProgress(), Text('正在加载')],
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
}

enum LoadMoreStatus { STATU_LOADING, STATU_COMPLETED, STATU_IDEL }
