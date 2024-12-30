import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/sqlite_database.dart';
import '../../domain/entities/task.dart';
import '../../data/repositories/task_repository.dart';

part 'task_view_model.g.dart';

@riverpod
class TaskNotifier extends _$TaskNotifier {
  @override
  Future<List<Task>> build() async {
    return ref.read(taskRepositoryProvider).getTasks();
  }

  Future<void> addTask(Task task) async {
    await ref.read(taskRepositoryProvider).addTask(task);
    ref.invalidateSelf();
  }

  Future<void> updateTask(Task task) async {
    await ref.read(taskRepositoryProvider).updateTask(task);
    ref.invalidateSelf();
  }

  Future<void> deleteTask(String id) async {
    await ref.read(taskRepositoryProvider).deleteTask(id);
    ref.invalidateSelf();
  }
}

@riverpod
TaskRepository taskRepository(TaskRepositoryRef ref) {
  return TaskRepository(SQLiteDatabase());
}
