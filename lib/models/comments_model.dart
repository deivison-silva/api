class CommentsModel {
  int id;
  String name;
  String body;
  String email;

  //construtor
  CommentsModel({
    required this.id,
    required this.name,
    required this.body,
    required this.email,
  });

  //fromMap
  factory CommentsModel.fromMap(Map<String, dynamic> map) {
    return CommentsModel(
      id: map['id'],
      name: map['name'],
      body: map['body'],
      email: map['email'],
    );
  }
}
