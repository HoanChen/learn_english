class WordBean {
  static const CLASS_NAME = 'WordBean';
  int id;
  String contentEN, contentCN, createTime;

  WordBean({this.id, this.contentEN, this.contentCN, this.createTime});

  WordBean.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    contentEN = json['contentEN'];
    contentCN = json['contentCN'];
    createTime = json['createTime'];
  }

  Map<String, dynamic> toJson() => Map<String, dynamic>()
    ..['id'] = this.id
    ..['contentEN'] = this.contentEN
    ..['contentCN'] = this.contentCN
    ..['createTime'] = this.createTime;

  @override
  String toString() => toJson().toString();
}
