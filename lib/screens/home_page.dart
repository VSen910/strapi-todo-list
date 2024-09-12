import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:strapi_todo/utils/task_provider.dart';
import 'package:strapi_todo/utils/todo_card.dart';
import 'package:strapi_todo/models/todo.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  List<Todo> findPendingTodos(List<Todo> todos) {
    List<Todo> list = [];
    for (Todo todo in todos) {
      if (!todo.isCompleted) {
        list.add(todo);
      }
    }
    return list;
  }

  List<Todo> findCompletedTodos(List<Todo> todos) {
    List<Todo> list = [];
    for (Todo todo in todos) {
      if (todo.isCompleted) {
        list.add(todo);
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final todos = ref.watch(taskProvider);
    final pendingTodos = findPendingTodos(todos);
    final completedTodos = findCompletedTodos(todos);

    final formKey = GlobalKey<FormState>();

    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TodoList',
          style: GoogleFonts.montserrat(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Pending',
              style: GoogleFonts.openSans(fontSize: 18),
            ),
          ),
          pendingTodos.isEmpty
              ? const Center(
                  child: Text('No todos'),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: pendingTodos.length,
                  itemBuilder: (context, index) {
                    final todo = pendingTodos[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TodoCard(todo: todo),
                    );
                  },
                ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Completed',
              style: GoogleFonts.openSans(fontSize: 18),
            ),
          ),
          completedTodos.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('No todos'),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: completedTodos.length,
                  itemBuilder: (context, index) {
                    final todo = completedTodos[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TodoCard(todo: todo),
                    );
                  },
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            showDragHandle: true,
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: titleController,
                            decoration: InputDecoration(
                              labelText: 'Title',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              suffix: IconButton(
                                onPressed: () {
                                  titleController.text = '';
                                },
                                icon: const Icon(Icons.close),
                              ),
                            ),
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return 'Title required';
                              }
                              return null;
                            },
                            onTapOutside: (_) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                          ),
                          const SizedBox(height: 8.0),
                          TextFormField(
                            controller: descriptionController,
                            decoration: InputDecoration(
                              labelText: 'Description',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              suffix: IconButton(
                                onPressed: () {
                                  descriptionController.text = '';
                                },
                                icon: const Icon(Icons.close),
                              ),
                            ),
                            onTapOutside: (_) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    SizedBox(
                      height: 0.06 * screenHeight,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade800,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            await ref.read(taskProvider.notifier).createTask(
                                  titleController.text,
                                  descriptionController.text,
                                );
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Add todo'),
                      ),
                    ),
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
