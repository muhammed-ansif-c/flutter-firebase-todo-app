import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:todo_app_herody/domain/models/task_model.dart';
import 'package:todo_app_herody/infrastructure/services/task_service.dart';

final taskServiceProvider = Provider<TaskService>((ref) {
  return TaskService();
});

class TaskNotifier extends StateNotifier<List<TaskModel>> {
  final TaskService taskService;

  TaskNotifier(this.taskService) : super([]);

  Future<void> loadTasks() async {
    final tasks = await taskService.fetchTasks();
    state = tasks;
  }

  Future<void> addTask(TaskModel task) async {
    await taskService.addTask(task);
    await loadTasks();
  }

  Future<void> updateTask(TaskModel task) async {
    await taskService.updateTask(task);
    await loadTasks();
  }

  Future<void> deleteTask(String taskId) async {
    await taskService.deleteTask(taskId);
    await loadTasks();
  }
}

final taskNotifierProvider =
    StateNotifierProvider<TaskNotifier, List<TaskModel>>((ref) {
  final service = ref.watch(taskServiceProvider);
  return TaskNotifier(service);
});