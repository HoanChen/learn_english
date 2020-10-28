import 'dart:io';

import 'package:dio/dio.dart';
import 'package:learn_english/common/Constants.dart';
import 'package:learn_english/common/LoginInfoUtil.dart';

import '../main.dart';
import 'HttpUtil.dart';
import 'bean/ResultBean.dart';
import 'bean/TokenBean.dart';
import 'bean/TokensBean.dart';

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
          HttpUtil().lock();
          var token = await _refreshToken();
          HttpUtil().unlock();
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
    if (!token.expired()) return token;
    var refreshToken = LoginInfoUtil().getRefreshToken();
    if (refreshToken.expired()) return null;
    try {
      var response =
          await HttpUtil().newDio(Constants.BASE_URL).post('/api/v1/user/token',
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
    } catch (e) {
      //TODO 超时/网络异常等情况处理
      print('-----_refreshToken Error:${e.toString()}');
      return token;
    }
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
    HttpUtil().cancel();
    LoginInfoUtil().exitLogin().then((value) =>
        MyApp.navigator.pushNamedAndRemoveUntil('./login', (route) => false));
  }
}
