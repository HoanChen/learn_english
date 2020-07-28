class WordMarkBean {
  int userId, wordId;
  bool markUp;

  WordMarkBean({this.userId, this.wordId, this.markUp});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['wordId'] = this.wordId;
    data['markUp'] = this.markUp;
    return data;
  }

  @override
  String toString() => toJson().toString();
}
