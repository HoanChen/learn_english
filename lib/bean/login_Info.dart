import 'TokensBean.dart';

class LoginInfoBean extends TokensBean {
  static const CLASS_NAME = 'LoginInfoBean';
  RoleBean role;
  UserBean userBean;

  LoginInfoBean.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    role = json['role'] != null ? RoleBean.fromJson(json['role']) : null;
    userBean =
        json['userBean'] != null ? UserBean.fromJson(json['userBean']) : null;
  }

  Map<String, dynamic> toJson() => Map<String, dynamic>()
    ..['accessToken'] = this.accessToken.toJson()
    ..['refreshToken'] = this.refreshToken.toJson()
    ..['role'] = this.role != null ? this.role.toJson() : null
    ..['userBean'] = this.userBean != null ? this.userBean.toJson() : null;
}

class RoleBean {
  int code;
  String name;

  RoleBean.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() => Map<String, dynamic>()
    ..['code'] = this.code
    ..['name'] = this.name;
}

class UserBean {
  String userName, phone, email, avatar;

  UserBean.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    phone = json['phone'];
    email = json['email'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() => Map<String, dynamic>()
    ..['userName'] = this.userName
    ..['phone'] = this.phone
    ..['email'] = this.email
    ..['avatar'] = this.avatar;
}
