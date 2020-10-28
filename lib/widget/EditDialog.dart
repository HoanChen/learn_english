import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:learn_english/common/MyColors.dart';
import 'package:learn_english/net/bean/WordBean.dart';

class EditDialog extends Dialog {
  final WordBean word;
  final Function confirmCallback;

  EditDialog({Key key, @required this.word, this.confirmCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _focusNodeEN = FocusNode();
    final _focusNodeCN = FocusNode();
    final _textEditControllerEN =
        TextEditingController(text: word.contentEN ?? '');
    final _textEditControllerCN =
        TextEditingController(text: word.contentCN ?? '');
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
                            child: Text(word.id != null ? '编辑' : '新增'),
                          )
                        ],
                      ),
                    ),
                    Container(
                      color: Color(0xffe0e0e0),
                      height: 1.0,
                    ),
                    _buildInputText(
                        _textEditControllerEN,
                        word.id == null,
                        _focusNodeEN,
                        TextInputAction.next,
                        'English Word', (text) {
                      _focusNodeEN.unfocus();
                      FocusScope.of(context).requestFocus(_focusNodeCN);
                    }),
                    _buildInputText(_textEditControllerCN, word.id != null,
                        _focusNodeCN, TextInputAction.done, '汉语翻译', (text) {
                      if (_textEditControllerEN.text.isNotEmpty) {
                        word
                          ..contentEN = _textEditControllerEN.text
                          ..contentCN = _textEditControllerCN.text;
                        if (confirmCallback != null) {
                          confirmCallback.call();
                          _textEditControllerCN.clear();
                          _textEditControllerEN.clear();
                          _focusNodeCN.unfocus();
                          FocusScope.of(context).requestFocus(_focusNodeEN);
                        } else
                          Navigator.pop(context, true);
                      } else {
                        Navigator.pop(context, false);
                      }
                    }),
                    Container(
                        margin: EdgeInsets.only(right: 10.0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _buildBottomButton(context, false, () {
                              Navigator.pop(context, false);
                            }),
                            _buildBottomButton(context, true, () {
                              if (_textEditControllerEN.text.isNotEmpty) {
                                word
                                  ..contentEN = _textEditControllerEN.text
                                  ..contentCN = _textEditControllerCN.text;
                                if (confirmCallback != null) {
                                  confirmCallback.call();
                                  _textEditControllerCN.clear();
                                  _textEditControllerEN.clear();
                                  _focusNodeCN.unfocus();
                                  FocusScope.of(context)
                                      .requestFocus(_focusNodeEN);
                                } else
                                  Navigator.pop(context, true);
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

  _buildInputText(
          TextEditingController controller,
          bool focus,
          FocusNode focusNode,
          TextInputAction action,
          String hint,
          ValueChanged<String> valueChanged) =>
      Container(
          margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
          child: Padding(
            padding: EdgeInsets.only(left: 30.0, right: 30.0),
            child: Center(
              child: TextField(
                focusNode: focusNode,
                controller: controller,
                autofocus: focus,
                textInputAction: action,
                keyboardType: TextInputType.text,
                onSubmitted: valueChanged,
                decoration: InputDecoration(
                  hintText: hint,
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(3), //边角为5
                    ),
                    borderSide: BorderSide(
                      color: Colors.black12, //边线颜色为白色
                      width: 1, //边线宽度为2
                    ),
                  ),
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
