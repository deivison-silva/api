class TodoModel {
  final int id;
  final String title;
  final bool completed;

  //construtor
  TodoModel({required this.id, required this.title, required this.completed});

  //factory que converte o Map vindo da API em objeto tipado
  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'],
      title: map['title'],
      completed: map['completed'],
    );
  }
}
