class WordBean {
  static const CLASS_NAME = 'WordBean';
  int id;
  String contentEN;
  String contentCN;

  WordBean(int id, String contentEN, String contentCN) {
    this.id = id;
    this.contentEN = contentEN;
    this.contentCN = contentCN;
  }

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
}
