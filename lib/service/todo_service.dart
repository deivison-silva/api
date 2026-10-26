import 'package:api_rest/models/todo_model.dart';
import 'package:api_rest/api/api_config.dart';
import 'package:dio/dio.dart';

class TodoService {
  final _dio = Dio();

  //Read - GET
  Future<List<TodoModel>> getTodos() async {
    // 1. Dispara o GET
    final response = await _dio.get('${ApiConfig.baseUrl}/todos');

    // 2. Dio entrega o corpo já em List dinâmica
    final list = response.data as List; // cats

    // 3. Converte a lista dinâmica para a lista tipada de TodoModel
    return list.map((item) => TodoModel.fromMap(item)).toList();
  }
}
