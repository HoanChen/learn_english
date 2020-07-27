import 'TokensBean.dart';

class LoginInfoBean extends TokensBean {
  static const CLASS_NAME = 'LoginInfoBean';
  RoleBean role;
  UserBean userBean;

  LoginInfoBean.fromJson(Map<String, dynamic> json) : super.fromJson(json){
    role = json['role'] != null ? new RoleBean.fromJson(json['role']) : null;
    userBean = json['userBean'] != null
        ? new UserBean.fromJson(json['userBean'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accessToken'] = this.accessToken.toJson();
    data['refreshToken'] = this.refreshToken.toJson();
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
  String userName, phone, email, avatar;

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
