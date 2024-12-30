import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/task.dart';
import '../viewmodels/task_view_model.dart';
import '../providers/task_providers.dart';
import 'task_dialog.dart';

class TaskDetail extends ConsumerWidget {
  const TaskDetail({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTask = ref.watch(selectedTaskProvider);

    if (selectedTask == null) {
      return const Center(child: Text('Select a task to view details'));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            selectedTask.title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          if (selectedTask.description != null) ...[
            Text(
              selectedTask.description!,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
          ],
          _buildInfoRow(
            'Created',
            DateFormat.yMMMd().format(selectedTask.createdAt),
          ),
          if (selectedTask.dueDate != null)
            _buildInfoRow(
              'Due Date',
              DateFormat.yMMMd().format(selectedTask.dueDate!),
            ),
          _buildInfoRow(
            'Priority',
            _getPriorityText(selectedTask.priority),
          ),
          _buildInfoRow(
            'Status',
            selectedTask.isCompleted ? 'Completed' : 'Pending',
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () =>
                    _showEditTaskDialog(context, ref, selectedTask),
                child: const Text('Edit'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  ref
                      .read(taskNotifierProvider.notifier)
                      .deleteTask(selectedTask.id);
                  ref.read(selectedTaskProvider.notifier).state = null;
                },
                child: const Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  String _getPriorityText(int priority) {
    switch (priority) {
      case 0:
        return 'Low';
      case 1:
        return 'Medium';
      case 2:
        return 'High';
      default:
        return 'Unknown';
    }
  }

  void _showEditTaskDialog(BuildContext context, WidgetRef ref, Task task) {
    showDialog(
      context: context,
      builder: (context) => TaskDialog(task: task),
    );
  }
}
