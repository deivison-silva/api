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

  // criando uma funão para reutilizar o modal bottom sheet
  // como o post pode ser null ou não informado, podemos entender que é um novo post
  // se o post for informado, significa que é um post já existente da nossa lista
  void _showModalBottomSheet({PostsModel? post}) {
    final isEditing = post != null;

    // verifica se é edição ou criação
    if (isEditing) {
      titleController.text = post.title;
      bodyController.text = post.body;
    } else {
      titleController.clear();
      bodyController.clear();
    }

    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: false,
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
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
                  Row(
                    spacing: 16,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancelar'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (isEditing) {
                              // _service.updatePost(post.id);
                            } else {
                              final title = titleController.text;
                              final body = bodyController.text;

                              await _service.createPost(
                                title: title,
                                body: body,
                              );
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                              setState(() {
                                _futurePosts = _service.getPosts();
                              });
                            }
                          }
                        },
                        child: isEditing ? Text('Atualizar') : Text('Salvar'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

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
            padding: const EdgeInsets.only(bottom: 80.0),
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
                        IconButton(
                          icon: const Icon(
                            Icons.edit_rounded,
                            color: Colors.amber,
                          ),
                          tooltip: 'Editar post',
                          onPressed: () =>
                              _showModalBottomSheet(post: posts[index]),
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
            onPressed: () => _showModalBottomSheet(),
            tooltip: 'Add',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
