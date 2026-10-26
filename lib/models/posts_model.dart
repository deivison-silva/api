class PostsModel {
  final int id;
  final String title;
  final String body;

  PostsModel({required this.id, required this.title, required this.body});

  factory PostsModel.fromMap(Map<String, dynamic> map) {
    return PostsModel(id: map['id'], title: map['title'], body: map['body']);
  }
}
