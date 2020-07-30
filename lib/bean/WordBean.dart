class WordBean {
  static const CLASS_NAME = 'WordBean';
  int id;
  String contentEN, contentCN;

  WordBean({this.id, this.contentEN, this.contentCN});

  WordBean.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    contentEN = json['contentEN'];
    contentCN = json['contentCN'];
  }

  Map<String, dynamic> toJson() => Map<String, dynamic>()
    ..['id'] = this.id
    ..['contentEN'] = this.contentEN
    ..['contentCN'] = this.contentCN;

  @override
  String toString() => toJson().toString();
}
