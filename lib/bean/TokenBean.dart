class TokenBean {
  static const CLASS_NAME = 'TokenBean';
  String token;
  int expiration;

  TokenBean.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    expiration = json['expiration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['expiration'] = this.expiration;
    return data;
  }

  bool expired() {
    return DateTime.now().isAfter(DateTime.fromMillisecondsSinceEpoch(expiration));
  }
}
