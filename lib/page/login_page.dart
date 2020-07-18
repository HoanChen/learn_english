import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:learn_english/bean/ResultBean.dart';
import 'package:learn_english/bean/login_Info.dart';
import 'package:learn_english/common/MyColors.dart';
import 'package:learn_english/common/LoginInfoUtil.dart';
import 'package:learn_english/http/HttpUtil.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<LoginPage> {
  TextEditingController _phoneNumController =
      TextEditingController(text: '18888888888');
  TextEditingController _passwordController =
      TextEditingController(text: '123456');

  FocusNode _phoneNumFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  Future<Null> focusNodeListener() async {
    if (_phoneNumFocusNode.hasFocus) {
      _passwordFocusNode.unfocus();
    }
    if (_passwordFocusNode.hasFocus) {
      _phoneNumFocusNode.unfocus();
    }
  }

  var _isShowPhoneNumClear = false;
  var _isShowPwdClear = false;
  var _isPwdObscure = true;
  var _loading = false;
  @override
  void initState() {
    _phoneNumController.addListener(() {
      _isShowPhoneNumClear = _phoneNumController.text.length > 0;
      setState(() {});
    });
    _passwordController.addListener(() {
      _isShowPwdClear = _passwordController.text.length > 0;
      setState(() {});
    });
    _phoneNumFocusNode.addListener(focusNodeListener);
    _passwordFocusNode.addListener(focusNodeListener);
    super.initState();
  }

  @override
  void dispose() {
    _phoneNumController.dispose();
    _passwordController.dispose();
    _phoneNumFocusNode.removeListener(focusNodeListener);
    _passwordFocusNode.removeListener(focusNodeListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const lineBorder =
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.white));
    const testStyle = TextStyle(color: Colors.white, fontSize: 16.0);
    return Scaffold(
        body: GestureDetector(
      onTap: () {
        _phoneNumFocusNode.unfocus();
        _passwordFocusNode.unfocus();
      },
      child: Container(
          decoration: BoxDecoration(color: MyColors.accentColor),
          child: ListView(
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 120.0,
                  ),
                  Text(
                    '学英语',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600),
                  ),
                  _buildPhoneNumContainer(context, testStyle, lineBorder),
                  _buildPasswordContainer(context, testStyle, lineBorder),
                  _buildButtonContainer(context, testStyle),
                  _buildFootContainer(context)
                ],
              )
            ],
          )),
    ));
  }

  /* 用户名输入 */
  _buildPhoneNumContainer(
          BuildContext context, TextStyle testStyle, InputBorder lineBorder) =>
      Container(
        width: 250.0,
        padding: EdgeInsets.only(top: 60.0),
        child: TextFormField(
          controller: _phoneNumController,
          focusNode: _phoneNumFocusNode,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (value) {
            FocusScope.of(context).requestFocus(_passwordFocusNode);
          },
          style: testStyle,
          decoration: InputDecoration(
            focusedBorder: lineBorder,
            enabledBorder: lineBorder,
            hintStyle: testStyle,
            hintText: '手机号',
            prefixIcon: Icon(
              Icons.person,
              color: Colors.white,
            ),
            prefixIconConstraints:
                BoxConstraints(maxWidth: 48.0, maxHeight: 48.0),
            suffixIcon: _isShowPhoneNumClear
                ? IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _phoneNumController.clear();
                    },
                  )
                : null,
            suffixIconConstraints:
                BoxConstraints(maxWidth: 48.0, maxHeight: 48.0),
          ),
        ),
      );

  /* 密码输入 */
  _buildPasswordContainer(
          BuildContext context, TextStyle testStyle, InputBorder lineBorder) =>
      Container(
        width: 250.0,
        padding: EdgeInsets.only(top: 10.0),
        child: TextFormField(
          controller: _passwordController,
          focusNode: _passwordFocusNode,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (value) {
            _passwordFocusNode.unfocus();
            var _phoneNum = _phoneNumController.text;
            var _password = _passwordController.text;
            doLogin(context, _phoneNum, _password);
          },
          style: testStyle,
          obscureText: _isPwdObscure,
          decoration: InputDecoration(
            focusedBorder: lineBorder,
            enabledBorder: lineBorder,
            hintStyle: testStyle,
            hintText: '密码',
            prefixIcon: Icon(
              Icons.lock,
              color: Colors.white,
            ),
            prefixIconConstraints:
                BoxConstraints(maxWidth: 48.0, maxHeight: 48.0),
            suffixIcon: _isShowPwdClear
                ? IconButton(
                    icon: Icon(
                        _isPwdObscure ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _isPwdObscure = !_isPwdObscure;
                      });
                    },
                  )
                : null,
            suffixIconConstraints:
                BoxConstraints(maxWidth: 48.0, maxHeight: 48.0),
          ),
        ),
      );

  /* 登录按钮 */
  _buildButtonContainer(BuildContext context, TextStyle testStyle) => Container(
        width: 250.0,
        padding: EdgeInsets.only(top: 30.0),
        child: MaterialButton(
          minWidth: 250.0,
          height: 46.0,
          color: MyColors.orange,
          shape: RoundedRectangleBorder(
              side: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(46))),
          onPressed: () {
            var _phoneNum = _phoneNumController.text;
            var _password = _passwordController.text;
            if (!_loading) {
              doLogin(context, _phoneNum, _password);
            }
          },
          child: Text(
            _loading ? "登录中..." : '登录',
            style: TextStyle(color: Colors.white, fontSize: 18.0),
          ),
        ),
      );

  /* 验证码登录、找回密码 */
  _buildFootContainer(BuildContext context) => Container(
      width: 250.0,
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
              child: Text(
                '短信验证码登录',
                style: TextStyle(color: Colors.white, fontSize: 14.0),
              ),
            ),
          ),
          Expanded(
            child: Text(''),
          ),
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
              child: Text(
                '忘记密码',
                style: TextStyle(color: Colors.white, fontSize: 14.0),
              ),
            ),
          ),
        ],
      ));

  /* 登录操作 */
  doLogin(BuildContext context, String _phoneNum, String password) async {
    setState(() {
      _loading = true;
    });
    FormData formData = FormData.fromMap({
      'phone': _phoneNum,
      'password': base64Encode(utf8.encode(password)),
    });
    var response = await HttpUtil.getInstance().post<ResultBean, LoginInfoBean>(
        '/api/v1/user/login', formData,
        needToken: false);
    var msg = response.message;
    if (response.isSuccess()) {
      var success = await LoginInfoUtil().setLoginInfo(response.data);
      if (success) {
        Navigator.of(context).pushReplacementNamed('./main');
      } else {
        msg = '登录失败';
        setState(() {
          _loading = false;
        });
      }
    } else {
      setState(() {
        _loading = false;
      });
    }
    Fluttertoast.showToast(msg: msg);
  }
}
