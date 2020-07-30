class TokenBean {
  static const CLASS_NAME = 'TokenBean';
  String token;
  int expiration;

  TokenBean.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    expiration = json['expiration'];
  }

  Map<String, dynamic> toJson() => Map<String, dynamic>()
    ..['token'] = this.token
    ..['expiration'] = this.expiration;

  bool expired() =>
      DateTime.now().isAfter(DateTime.fromMillisecondsSinceEpoch(expiration));
}
