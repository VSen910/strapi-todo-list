import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:strapi_todo/models/todo.dart';
import 'package:strapi_todo/utils/graphql_config.dart';

final taskProvider = StateNotifierProvider<TaskNotifier, List<Todo>>((ref) {
  final taskNotifier = TaskNotifier();
  // taskNotifier.getTasks();
  return taskNotifier;
});

class TaskNotifier extends StateNotifier<List<Todo>> {
  TaskNotifier() : super([]) {
    getTasks();
  }

  Future<void> getTasks() async {
    try {
      final client = GraphqlConfig.client;
      final res = await client.query(
        QueryOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql(
            """
            query {
              tasks(sort: "publishedAt:desc") {
                data {
                  id
                  attributes {
                    Title
                    Description
                    Completed
                    publishedAt
                  }
                }
              }
            }
          """,
          ),
        ),
      );

      if(res.hasException) {
        print(res.exception);
        return;
      }

      print(res.data);

      List? list = res.data!['tasks']['data'];
      if(list == null || list.isEmpty) {
        print('empty list');
        return;
      }

      List<Todo> todos = list.map((todo) => Todo.fromJson(todo)).toList();
      print(todos);
      state = todos;
    } catch (e) {
      print(e.toString());
      return;
    }
  }

  Future<void> updateStatus(Todo selectedTodo) async {
    try {
      final client = GraphqlConfig.client;
      final res = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql(
            """
            mutation {
              updateTask(id:${selectedTodo.id}, data: {Completed: ${selectedTodo.isCompleted}}) {
                data {
                  id
                  attributes {
                    Title
                    Completed
                  }
                }
              }
            }
          """,
          ),
        ),
      );

      if(res.hasException) {
        print(res.exception);
        return;
      }

      getTasks();
    } catch (e) {
      print(e.toString());
      return;
    }
  }

  Future<void> deleteTask(Todo selectedTodo) async {
    try {
      final client = GraphqlConfig.client;
      final res = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql(
            """
            mutation {
              deleteTask(id:${selectedTodo.id}) {
                data {
                  id
                  attributes {
                    Title
                    Completed
                  }
                }
              }
            }
          """,
          ),
        ),
      );

      if(res.hasException) {
        print(res.exception);
        return;
      }

      getTasks();
    } catch (e) {
      print(e.toString());
      return;
    }
  }

  Future<void> createTask(String title, String description) async {
    try {
      final client = GraphqlConfig.client;
      final res = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql(
            r'''
              mutation CreateTask($title: String!, $description: String, $publishedAt: DateTime) {
              createTask(data: {Title: $title, Description: $description, publishedAt: $publishedAt}) {
                data {
                  id
                  attributes {
                    Title
                    Description
                    Completed
                    publishedAt
                  }
                }
              }
            }
            ''',
          ),
          variables: {
            "title": title,
            "description": description,
            "publishedAt": DateTime.now().toUtc().toIso8601String(),
          },
        ),
      );

      if(res.hasException) {
        print(res.exception);
        return;
      }

      getTasks();
    } catch (e) {
      print(e.toString());
      return;
    }
  }

}

