import 'dart:io';

import 'package:dio/dio.dart';
import 'package:learn_english/bean/ResultBean.dart';
import 'package:learn_english/bean/TokenBean.dart';
import 'package:learn_english/bean/TokensBean.dart';
import 'package:learn_english/common/LoginInfoUtil.dart';
import 'package:learn_english/net/HttpUtil.dart';

import '../main.dart';

///添加token认证head,提前判断失效并主动刷新
class TokenInterceptor extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options) async {
    var isLogin = await LoginInfoUtil().isLogin();
    if (isLogin) {
      var accessToken = LoginInfoUtil().getToken();
      //判断token是否过期
      if (accessToken.expired()) {
        //判断refreshToken是否过期
        if (LoginInfoUtil().getRefreshToken().expired()) {
          onExpired();
        } else {
          HttpUtil().dio().lock();
          var token = await _refreshToken();
          HttpUtil().dio().unlock();
          if (token != null) {
            options.headers.addAll({'authorization': 'Bearer ${token.token}'});
          } else {
            onExpired();
          }
        }
      } else {
        options.headers
            .addAll({'authorization': 'Bearer ${accessToken.token}'});
      }
    }
    return super.onRequest(options);
  }

  Future<TokenBean> _refreshToken() async {
    var token = LoginInfoUtil().getToken();
    if (!token.expired()) {
      return token;
    }
    var refreshToken = LoginInfoUtil().getRefreshToken();
    if (refreshToken.expired()) {
      return null;
    }
    try {
      var response = await HttpUtil().tokenDio().post('/api/v1/user/token',
          data: FormData.fromMap({
            'refreshToken': refreshToken.token,
          }));
      var resJson = response != null ? response.data : null;
      if (resJson != null) {
        var resultBean = ResultBean<TokensBean>.fromJson(resJson, null);
        if (resultBean.isSuccess()) {
          var setToken = await LoginInfoUtil().setToken(resultBean.data);
          if (setToken) {
            return LoginInfoUtil().getToken();
          }
        }
      }
    } catch (e) {}
    return null;
  }

  @override
  Future onError(DioError err) {
    if (err?.response?.statusCode == HttpStatus.unauthorized) {
      onExpired();
      return null;
    } else {
      return super.onError(err);
    }
  }

  void onExpired() {
    HttpUtil.getInstance().cancel();
    LoginInfoUtil().exitLogin().then((value) =>
        MyApp.navigator.pushNamedAndRemoveUntil('./login', (route) => false));
  }
}
