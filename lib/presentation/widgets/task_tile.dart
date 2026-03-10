import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app_herody/application/providers/task_providers.dart';
import 'package:todo_app_herody/domain/models/task_model.dart';

class TaskTile extends ConsumerWidget {

  final TaskModel task;

  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return ListTile(

      leading: Checkbox(
        value: task.isCompleted,
        onChanged: (value) {

          final updated = TaskModel(
            id: task.id,
            title: task.title,
            isCompleted: value ?? false,
            createdAt: task.createdAt,
          );

          ref.read(taskNotifierProvider.notifier).updateTask(updated);
        },
      ),

      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.isCompleted
              ? TextDecoration.lineThrough
              : null,
        ),
      ),
trailing: Row(
  mainAxisSize: MainAxisSize.min,
  children: [

    IconButton(
      icon: const Icon(Icons.edit),
      onPressed: () {
        final controller = TextEditingController(text: task.title);

        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: const Text("Edit Task"),
              content: TextField(
                controller: controller,
              ),
              actions: [

                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),

                ElevatedButton(
                  onPressed: () {

                    final updatedTask = TaskModel(
                      id: task.id,
                      title: controller.text,
                      isCompleted: task.isCompleted,
                      createdAt: task.createdAt,
                    );

                    ref
                        .read(taskNotifierProvider.notifier)
                        .updateTask(updatedTask);

                    Navigator.pop(context);
                  },
                  child: const Text("Save"),
                ),

              ],
            );
          },
        );
      },
    ),

    IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () {
        ref
            .read(taskNotifierProvider.notifier)
            .deleteTask(task.id);
      },
    ),

  ],
),
    );
  }
}