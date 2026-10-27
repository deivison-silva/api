import 'package:api_rest/models/comments_model.dart';
import 'package:api_rest/service/comments_service.dart';
import 'package:flutter/material.dart';

class CommentsView extends StatefulWidget {
  final int postID;
  const CommentsView({super.key, required this.postID});

  @override
  State<CommentsView> createState() => _CommentsViewState();
}

class _CommentsViewState extends State<CommentsView> {
  final _service = CommentsService();
  Future<List<CommentsModel>>? _futureComments;

  @override
  void initState() {
    super.initState();
    _futureComments = _service.getCommentsByPostID(widget.postID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Comentários')),
      body: FutureBuilder<List<CommentsModel>>(
        // <List<TodoModel>> - tipagem generica
        future: _futureComments,
        builder: (context, snapshot) {
          // 1. Aguardando resposta (Loading)
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Ocorreu falha (Sem rede, timeout, etc)
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar dados.'));
          }

          // 3. Sucesso com dados
          final comments = snapshot.data ?? [];

          if (comments.isEmpty) {
            return const Center(child: Text('Nenhum comentário encontrado.'));
          }

          return ListView.separated(
            separatorBuilder: (_, _) => Divider(),
            itemCount: comments.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Text(comments[index].id.toString()),
                title: Text(comments[index].name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(comments[index].body),
                    Text(comments[index].email),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
