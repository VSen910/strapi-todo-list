import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:strapi_todo/models/todo.dart';
import 'package:strapi_todo/utils/task_provider.dart';

final checkboxValueProvider = StateProvider((ref) => false);

class TodoCard extends ConsumerWidget {
  const TodoCard({super.key, required this.todo});

  final Todo todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () async {
        todo.isCompleted = !todo.isCompleted;
        await ref.read(taskProvider.notifier).updateStatus(todo);
      },
      onLongPress: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Delete todo'),
                content: const Text('Are you sure you want to delete this todo?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      await ref.read(taskProvider.notifier).deleteTask(todo);
                      Navigator.pop(context);
                    },
                    child: const Text('Delete'),
                  ),
                ],
              );
            });
      },
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue.shade800,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 16.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 0.8 * screenWidth,
                    child: Text(
                      todo.title,
                      style: GoogleFonts.openSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if(todo.description.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8.0),
                      SizedBox(
                        width: 0.8 * screenWidth,
                        child: Text(
                          todo.description,
                          style: GoogleFonts.openSans(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Checkbox(
                value: todo.isCompleted,
                side: const BorderSide(
                  color: Colors.white,
                ),
                activeColor: Colors.blue,
                onChanged: (val) async {
                  todo.isCompleted = val!;
                  await ref.read(taskProvider.notifier).updateStatus(todo);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
