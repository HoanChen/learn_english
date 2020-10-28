class WordMarkBean {
  int userId, wordId;
  bool markUp;

  WordMarkBean({this.userId, this.wordId, this.markUp});

  Map<String, dynamic> toJson() => Map<String, dynamic>()
    ..['userId'] = this.userId
    ..['wordId'] = this.wordId
    ..['markUp'] = this.markUp;

  @override
  String toString() => toJson().toString();
}
