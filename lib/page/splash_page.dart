import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_english/common/LoginInfoUtil.dart';
import 'package:learn_english/common/MyColors.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _postDelayGoMain();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: MyColors.accentColor,
          child: Center(
            child: Text(
              '博观而约取\n\n厚积而薄发',
              style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w200),
            ),
          )),
    );
  }

  _postDelayGoMain() async {
    LoginInfoUtil().isLogin().then((loginOK) => {
          Timer(Duration(milliseconds: 1500), () {
            Navigator.of(context)
                .pushReplacementNamed(loginOK ? './main' : "./login");
          })
        });
  }
}
