import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:learn_english/common/LoginInfoUtil.dart';
import 'package:learn_english/net/HttpUtil.dart';
import 'package:learn_english/net/bean/ResultBean.dart';
import 'package:learn_english/net/bean/login_Info.dart';

class LoginApi {
  Future<bool> login(String phoneNum, String password) async {
    FormData formData = FormData.fromMap({
      'phone': phoneNum,
      'password': base64Encode(utf8.encode(password)),
    });
    var response = await HttpUtil()
        .post<ResultBean, LoginInfoBean>('/api/v1/user/login', formData);
    Fluttertoast.showToast(msg: response.message);
    if (response.isSuccess()) {
      var success = await LoginInfoUtil().setLoginInfo(response.data);
      return true;
    } else {
      return false;
    }
  }
}
