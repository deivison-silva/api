import 'package:api_rest/models/comments_model.dart';
import 'package:api_rest/api/api_config.dart';
import 'package:dio/dio.dart';

class CommentsService {
  final _dio = Dio();

  //Read - GET
  Future<List<CommentsModel>> getCommentsByPostID(int postID) async {
    var response = await _dio.get(
      '${ApiConfig.baseUrl}/posts/$postID/comments',
    );

    // 2. Dio entrega o corpo já em List dinâmica
    final list = response.data as List;

    // 3. Converte a lista dinâmica para a lista tipada de TodoModel
    return list.map((item) => CommentsModel.fromMap(item)).toList();
  }
}
