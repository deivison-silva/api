import 'package:api_rest/models/comments_model.dart';
import 'package:api_rest/models/posts_model.dart';
import 'package:api_rest/service/comments_service.dart';
import 'package:api_rest/service/posts_service.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API REST',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const MyHomePage(title: 'API REST'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _service = PostsService();
  Future<List<PostsModel>>? _futurePosts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<PostsModel>>(
        // <List<TodoModel>> - tipagem generica
        future: _futurePosts,
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
          final posts = snapshot.data ?? [];

          if (posts.isEmpty) {
            return const Center(child: Text('Nenhum post encontrado.'));
          }

          return ListView.separated(
            separatorBuilder: (_, _) => Divider(),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Text(posts[index].id.toString()),
                title: Text(posts[index].title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(posts[index].body),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            // push -> ir para uma nova tela

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    CommentPage(postID: posts[index].id),
                              ),
                            );
                          },
                          child: Text('Comentários'),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          tooltip: 'Remover post',
                          onPressed: () async {
                            await _service.deletePost(posts[index].id);
                            setState(() {
                              _futurePosts = _service.getPosts();
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _futurePosts = _service.getPosts();
          });
        },
        tooltip: 'Update',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class CommentPage extends StatefulWidget {
  final int postID;
  const CommentPage({super.key, required this.postID});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
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
