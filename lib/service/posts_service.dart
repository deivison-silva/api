import 'package:api_rest/models/posts_model.dart';
import 'package:api_rest/api/api_config.dart';
import 'package:dio/dio.dart';

class PostsService {
  final _dio = Dio();

  //Read - GET
  Future<List<PostsModel>> getPosts() async {
    var response = await _dio.get('${ApiConfig.baseUrl}/posts');

    // 2. Dio entrega o corpo já em List dinâmica
    final list = response.data as List;

    // 3. Converte a lista dinâmica para a lista tipada de PostsModel
    return list.map((item) => PostsModel.fromMap(item)).toList();
  }

  //Delete - DELETE
  Future<void> deletePost(int id) async {
    await _dio.delete('${ApiConfig.baseUrl}/posts/$id');
  }

  //Create - POST
  Future<void> createPost({
    required int userId,
    required String title,
    required String body,
  }) async {
    final response = await _dio.post(
      '${ApiConfig.baseUrl}/posts',
      data: {'userId': userId, 'title': title, 'body': body},
    );
    return response.data;
  }
}
