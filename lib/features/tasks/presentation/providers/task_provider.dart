import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intern_example/features/tasks/presentation/providers/preferences_provider.dart';
import '../../domain/models/task.dart';
import '../../data/datasources/hive_database.dart';
import '../../data/models/hive_task.dart';

final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  return TaskNotifier();
});

class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier() : super([]) {
    _loadTasks();
  }

  void _loadTasks() {
    final box = HiveDatabase.getTasksBox();
    final hiveTasks = box.values.toList();
    state = hiveTasks.map((task) => task.toTask()).toList();
  }

  void addTask(String title,
      {String description = '', String category = 'default'}) {
    final task = Task(
      id: DateTime.now().toString(),
      title: title,
      isCompleted: false,
      description: description,
      category: category,
    );
    final hiveTask = HiveTask.fromTask(task);
    HiveDatabase.getTasksBox().add(hiveTask);
    state = [...state, task];
  }

  void deleteTask(String id) {
    final box = HiveDatabase.getTasksBox();
    final taskIndex = box.values.toList().indexWhere((task) => task.id == id);
    if (taskIndex != -1) {
      box.deleteAt(taskIndex);
    }
    state = state.where((task) => task.id != id).toList();
  }

  void toggleTask(String id) {
    final box = HiveDatabase.getTasksBox();
    final hiveTask = box.values.firstWhere((task) => task.id == id);
    hiveTask.isCompleted = !hiveTask.isCompleted;
    hiveTask.save();

    state = state.map((task) {
      if (task.id == id) {
        return Task(
          id: task.id,
          title: task.title,
          isCompleted: !task.isCompleted,
          category: task.category,
          description: task.description,
        );
      }
      return task;
    }).toList();
  }

  void editTask(String id, String title, String description, String category) {
    final box = HiveDatabase.getTasksBox();
    final taskIndex = box.values.toList().indexWhere((task) => task.id == id);
    if (taskIndex != -1) {
      final task = box.getAt(taskIndex);
      final updatedTask = HiveTask(
        id: id,
        title: title,
        description: description,
        category: category,
        isCompleted: task!.isCompleted,
      );
      box.putAt(taskIndex, updatedTask);

      state = state.map((task) {
        if (task.id == id) {
          return Task(
            id: id,
            title: title,
            description: description,
            category: category,
            isCompleted: task.isCompleted,
          );
        }
        return task;
      }).toList();
    }
  }
}

final filteredTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(taskProvider);
  final filter = ref.watch(taskFilterProvider);
  final search = ref.watch(searchQueryProvider);
  final categoryFilter = ref.watch(categoryFilterProvider);

  return tasks.where((task) {
    if (search.isNotEmpty &&
        !task.title.toLowerCase().contains(search.toLowerCase())) {
      return false;
    }

    if (categoryFilter != 'All' && task.category != categoryFilter) {
      return false;
    }

    switch (filter) {
      case TaskFilter.completed:
        return task.isCompleted;
      case TaskFilter.pending:
        return !task.isCompleted;
      default:
        return true;
    }
  }).toList();
});

enum TaskFilter { all, completed, pending }

final taskFilterProvider = StateProvider<TaskFilter>((ref) => TaskFilter.all);
final searchQueryProvider = StateProvider<String>((ref) => '');
final categoryFilterProvider = StateProvider<String>((ref) => 'All');

final sortedTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(filteredTasksProvider);
  final sortOrder = ref.watch(preferencesProvider).sortOrder;

  final sortedTasks = [...tasks];
  switch (sortOrder) {
    case 'date':
      sortedTasks.sort((a, b) => b.id.compareTo(a.id));
      break;
    case 'alphabetical':
      sortedTasks.sort((a, b) => a.title.compareTo(b.title));
      break;
  }
  return sortedTasks;
});
