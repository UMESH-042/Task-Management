import '../datasources/sqlite_database.dart';
import '../datasources/notification_service.dart';
import '../../domain/entities/task.dart';

class TaskRepository {
  final SQLiteDatabase _database;
  final NotificationService _notifications;

  TaskRepository(this._database) : _notifications = NotificationService();

  Future<List<Task>> getTasks() async {
    return await _database.getTasks();
  }

  Future<void> addTask(Task task) async {
    await _database.insertTask(task);
    await _notifications.scheduleTaskNotification(task);
  }

  Future<void> updateTask(Task task) async {
    await _database.updateTask(task);
    await _notifications.cancelTaskNotification(task);
    if (!task.isCompleted) {
      await _notifications.scheduleTaskNotification(task);
    }
  }

  Future<void> deleteTask(String id) async {
    final task =
        Task(id: id, title: ''); // Dummy task for notification cancellation
    await _notifications.cancelTaskNotification(task);
    await _database.deleteTask(id);
  }
}
