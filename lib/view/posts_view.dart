import 'package:api_rest/models/posts_model.dart';
import 'package:api_rest/service/posts_service.dart';
import 'package:api_rest/view/comments_view.dart';
import 'package:api_rest/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class PostsView extends StatefulWidget {
  const PostsView({super.key, required this.title});

  final String title;

  @override
  State<PostsView> createState() => _PostsViewState();
}

class _PostsViewState extends State<PostsView> {
  final _service = PostsService();
  Future<List<PostsModel>>? _futurePosts;

  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final bodyController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

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
                                    CommentsView(postID: posts[index].id),
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
      floatingActionButton: Row(
        spacing: 16,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _futurePosts = _service.getPosts();
              });
            },
            tooltip: 'Update',
            child: const Icon(Icons.refresh),
          ),
          FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        children: [
                          CustomTextFormField(
                            controller: titleController,
                            labelText: 'Title',
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 8),
                          CustomTextFormField(
                            controller: bodyController,
                            labelText: 'Body',
                            textInputAction: TextInputAction.done,
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                //executar função de adicionar post
                                await _service.createPost(
                                  userId: 1,
                                  title: titleController.text,
                                  body: bodyController.text,
                                );
                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                }
                                setState(() {
                                  _futurePosts = _service.getPosts();
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Salvar'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            tooltip: 'Add',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
