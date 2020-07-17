import 'package:flutter/material.dart';
import 'package:learn_english/common/MyColors.dart';
import '../bean/WordBean.dart';

class EditDialog extends Dialog {
  final WordBean word;

  EditDialog({Key key, @required this.word}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _textEditController = TextEditingController(
        text: word.id != null ? word.contentCN : word.contentEN ?? '');
    return SingleChildScrollView(
        child: Material(
            type: MaterialType.transparency,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)))),
                margin: EdgeInsets.all(12.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Stack(
                        alignment: AlignmentDirectional.centerEnd,
                        children: <Widget>[
                          Center(
                            child: Text(word.id != null
                                ? '编辑汉译【${word.contentEN}】'
                                : '新增单词'),
                          )
                        ],
                      ),
                    ),
                    Container(
                      color: Color(0xffe0e0e0),
                      height: 1.0,
                    ),
                    _buildInputText(_textEditController, (text) {
                      Navigator.pop(context, text);
                    }),
                    Container(
                        margin: EdgeInsets.only(right: 10.0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _buildBottomButton(context, false, () {
                              Navigator.pop(context, null);
                            }),
                            _buildBottomButton(context, true, () {
                              if (_textEditController.text.isEmpty) {
                              } else {
                                Navigator.pop(
                                    context, _textEditController.text);
                              }
                            })
                          ],
                        )),
                  ],
                ),
              )
            ])));
  }

  _buildBottomButton(BuildContext context, bool poistive, Function onPressed) =>
      FlatButton(
        onPressed: onPressed,
        child: Text(
          poistive ? '确认' : '取消',
          style: TextStyle(
              fontSize: 16.0,
              color: poistive ? MyColors.accentColor : Colors.black),
        ),
      );

  _buildInputText(TextEditingController controller,
          ValueChanged<String> valueChanged) =>
      Container(
          constraints: BoxConstraints(minHeight: 130.0),
          child: Padding(
            padding: EdgeInsets.only(left: 30.0, right: 30.0),
            child: Center(
              child: TextField(
                controller: controller,
                autofocus: true,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                onSubmitted: valueChanged,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 15),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(3), //边角为5
                    ),
                    borderSide: BorderSide(
                      color: MyColors.accentColor, //边线颜色为白色
                      width: 1, //边线宽度为2
                    ),
                  ),
                ),
              ),
            ),
          ));
}
