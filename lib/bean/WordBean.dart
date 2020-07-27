class WordBean {
  static const CLASS_NAME = 'WordBean';
  int id;
  String contentEN,contentCN;

  WordBean({this.id, this.contentEN, this.contentCN});

  WordBean.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    contentEN = json['contentEN'];
    contentCN = json['contentCN'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['contentEN'] = this.contentEN;
    data['contentCN'] = this.contentCN;
    return data;
  }

  @override
  String toString() => toJson().toString();
}
