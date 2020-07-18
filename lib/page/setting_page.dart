import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_english/common/MyColors.dart';
import 'package:learn_english/common/LoginInfoUtil.dart';

class SettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage>
    with AutomaticKeepAliveClientMixin {
  String phone = LoginInfoUtil().getInfo().userBean.phone;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(phone),
              SizedBox(height: 20.0),
              RaisedButton(
                color: MyColors.orange,
                onPressed: () {
                  LoginInfoUtil().exitLogin().then((value) => {
                        if (value)
                          Navigator.of(context).pushReplacementNamed("./login")
                      });
                },
                child: Text(
                  '退出登录',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
