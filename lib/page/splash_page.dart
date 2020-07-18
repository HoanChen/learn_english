import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_english/common/MyColors.dart';
import 'package:learn_english/common/LoginInfoUtil.dart';

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
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 60.0),
              child: SizedBox(
                width: 160.0,
                height: 160.0,
              ),
            ),
            Positioned(
              bottom: 50.0,
              child: Center(
                  child: Text(
                '智，能未来',
                style: TextStyle(fontSize: 20.0, color: Colors.white),
              )),
            )
          ],
        ),
      ),
    );
  }

  _postDelayGoMain() async {
    LoginInfoUtil().checkLoginInfo().then((loginOK) => {
          Timer(Duration(milliseconds: 1500), () {
            Navigator.of(context)
                .pushReplacementNamed(loginOK ? './main' : "./login");
          })
        });
  }
}
