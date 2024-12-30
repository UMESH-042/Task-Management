import 'package:hive/hive.dart';
import '../../domain/models/task.dart';

part 'hive_task.g.dart';

@HiveType(typeId: 1)
class HiveTask extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  bool isCompleted;

  @HiveField(3)
  String category;

  @HiveField(4)
  String description;

  HiveTask({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.category = 'default',
    this.description = '',
  });

  factory HiveTask.fromTask(Task task) {
    return HiveTask(
      id: task.id,
      title: task.title,
      isCompleted: task.isCompleted,
      category: task.category,
      description: task.description,
    );
  }

  Task toTask() {
    return Task(
      id: id,
      title: title,
      isCompleted: isCompleted,
      category: category,
      description: description,
    );
  }
}
