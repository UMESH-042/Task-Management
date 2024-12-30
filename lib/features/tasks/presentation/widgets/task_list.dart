import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/task_view_model.dart';
import '../providers/task_providers.dart';
import '../../domain/entities/task.dart';

class TaskList extends ConsumerWidget {
  const TaskList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(taskNotifierProvider);
    final sortOrder = ref.watch(sortOrderProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: SearchBar(
                  onChanged: (value) =>
                      ref.read(searchQueryProvider.notifier).state = value,
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.sort),
                onSelected: (value) =>
                    ref.read(sortOrderProvider.notifier).state = value,
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'date',
                    child: Text('Sort by Date'),
                  ),
                  const PopupMenuItem(
                    value: 'priority',
                    child: Text('Sort by Priority'),
                  ),
                  const PopupMenuItem(
                    value: 'title',
                    child: Text('Sort by Title'),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: tasksAsync.when(
            data: (tasks) {
              final searchQuery = ref.watch(searchQueryProvider);
              var filteredTasks = tasks.where((task) {
                return task.title
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase());
              }).toList();

              // Sort tasks based on selected order
              switch (sortOrder) {
                case 'priority':
                  filteredTasks
                      .sort((a, b) => b.priority.compareTo(a.priority));
                  break;
                case 'title':
                  filteredTasks.sort((a, b) => a.title.compareTo(b.title));
                  break;
                case 'date':
                default:
                  filteredTasks
                      .sort((a, b) => b.createdAt.compareTo(a.createdAt));
              }

              return ListView.builder(
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) => TaskListItem(
                  task: filteredTasks[index],
                  onTap: () => ref.read(selectedTaskProvider.notifier).state =
                      filteredTasks[index],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
          ),
        ),
      ],
    );
  }
}

class TaskListItem extends ConsumerWidget {
  final Task task;
  final VoidCallback? onTap;

  const TaskListItem({
    super.key,
    required this.task,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = ref.watch(selectedTaskProvider)?.id == task.id;

    return ListTile(
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text(task.description ?? ''),
      trailing: Checkbox(
        value: task.isCompleted,
        onChanged: (value) {
          ref.read(taskNotifierProvider.notifier).updateTask(
                task.copyWith(isCompleted: value),
              );
        },
      ),
      selected: isSelected,
      onTap: onTap,
    );
  }
}
