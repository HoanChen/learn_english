class LoginInfoBean {
  String accessToken;
  String refreshToken;
  String expiration;
  RoleBean role;
  UserBean userBean;

  LoginInfoBean(
      {this.accessToken,
      this.refreshToken,
      this.expiration,
      this.role,
      this.userBean});
  static const CLASS_NAME = 'LoginInfoBean';

  LoginInfoBean.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
    expiration = json['expiration'];
    role = json['role'] != null ? new RoleBean.fromJson(json['role']) : null;
    userBean = json['userBean'] != null
        ? new UserBean.fromJson(json['userBean'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accessToken'] = this.accessToken;
    data['refreshToken'] = this.refreshToken;
    data['expiration'] = this.expiration;
    if (this.role != null) {
      data['role'] = this.role.toJson();
    }
    if (this.userBean != null) {
      data['userBean'] = this.userBean.toJson();
    }
    return data;
  }
}

class RoleBean {
  int code;
  String name;

  RoleBean({this.code, this.name});

  RoleBean.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['name'] = this.name;
    return data;
  }
}

class UserBean {
  int id;
  String userName;
  String phone;
  String email;
  String avatar;

  UserBean({this.id, this.userName, this.phone, this.email, this.avatar});

  UserBean.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['userName'];
    phone = json['phone'];
    email = json['email'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userName'] = this.userName;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['avatar'] = this.avatar;
    return data;
  }
}
