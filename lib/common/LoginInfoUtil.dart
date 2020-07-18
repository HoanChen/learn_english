import 'dart:convert';

import 'package:learn_english/bean/login_Info.dart';

import 'Constants.dart';
import 'StorageUtil.dart';

class LoginInfoUtil {
  static final LoginInfoUtil _instance = LoginInfoUtil._internal();
  factory LoginInfoUtil() => _instance;

  LoginInfoUtil._internal();

  LoginInfoBean _info;
  Future<bool> checkLoginInfo() async {
    var infoOK = false;
    if (_info == null) {
      await StorageUtil.getString(Constants.LOGIN_INFO).then((String value) {
        if (value != null && value != '') {
          _info = LoginInfoBean.fromJson(json.decode(value));
          infoOK = true;
        }
      });
    } else {
      infoOK = true;
    }
    return infoOK;
  }

  LoginInfoBean getInfo() {
    return _info;
  }

  Future<bool> setLoginInfo(LoginInfoBean infoBean) async {
    this._info = infoBean;
    return StorageUtil.set(Constants.LOGIN_INFO, infoBean.toJson());
  }

  Future<bool> exitLogin() async {
    this._info = null;
    return StorageUtil.set(Constants.LOGIN_INFO, '');
  }

  getToken() => 'Bearer ${_info.accessToken}';
}
