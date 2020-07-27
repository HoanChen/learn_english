import 'package:learn_english/bean/TokenBean.dart';

class TokensBean {
  static const CLASS_NAME = 'TokensBean';
  TokenBean accessToken, refreshToken;

  TokensBean.fromJson(Map<String, dynamic> json) {
    accessToken = TokenBean.fromJson(json['accessToken']);
    refreshToken = TokenBean.fromJson(json['refreshToken']);
  }
}
