import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/task_provider.dart';
import '../providers/preferences_provider.dart';
import '../../domain/models/task.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(sortedTasksProvider);
    final selectedCategory = ref.watch(categoryFilterProvider);
    final isDarkMode = ref.watch(preferencesProvider).isDarkMode;
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final isLargePhone = size.width > 400;

    return Scaffold(
      backgroundColor: isDarkMode
          ? const Color(0xFF1E1E1E) // Dark background
          : const Color(0xFFF5F5F7), // Light gray background
      appBar: AppBar(
        backgroundColor: isDarkMode
            ? const Color(0xFF2C2C2C) // Dark app bar
            : Theme.of(context).primaryColor, // Primary color for light theme
        elevation: 0,
        title: const Row(
          children: [
            Icon(
              Icons.task_alt,
              size: 24,
              color: Colors.white, // White icon
            ),
            SizedBox(width: 8),
            Text(
              'Tasks',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white, // White text
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.sort_rounded,
              size: 24,
              color: Colors.white, // White icons
            ),
            tooltip: 'Sort Tasks',
            onPressed: () => _showSortDialog(context, ref),
          ),
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              size: 24,
              color: Colors.white,
            ),
            tooltip: isDarkMode ? 'Light Mode' : 'Dark Mode',
            onPressed: () {
              ref.read(preferencesProvider.notifier).toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.filter_list_rounded,
              size: 24,
              color: Colors.white,
            ),
            tooltip: 'Filter Tasks',
            onPressed: () => _showFilterDialog(context, ref),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                _buildSearchBar(context, ref),
                _buildCategoryChips(selectedCategory, ref, isTablet),
                Expanded(
                  child: _buildTaskList(tasks, isTablet, isLargePhone, ref),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _showAddTaskDialog(context, ref),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Add Task',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, WidgetRef ref) {
    final isLargePhone = MediaQuery.of(context).size.width > 400;
    final isDarkMode = ref.watch(preferencesProvider).isDarkMode;

    return Padding(
      padding: EdgeInsets.all(isLargePhone ? 16 : 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isDarkMode
              ? const Color(0xFF2C2C2C) // Dark card
              : Colors.white, // White card
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search tasks...',
            prefixIcon: Icon(
              Icons.search_rounded,
              size: 24,
              color: Theme.of(context).iconTheme.color?.withOpacity(0.7),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: isLargePhone ? 16 : 12,
              vertical: isLargePhone ? 12 : 8,
            ),
          ),
          onChanged: (value) {
            ref.read(searchQueryProvider.notifier).state = value;
          },
        ),
      ),
    );
  }

  Widget _buildCategoryChips(
      String selectedCategory, WidgetRef ref, bool isTablet) {
    final categories = ['All', 'Work', 'Personal', 'Shopping', 'Others'];
    final isDarkMode = ref.watch(preferencesProvider).isDarkMode;

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(
                category,
                style: TextStyle(
                  color: isDarkMode
                      ? (isSelected ? Colors.white : Colors.grey.shade300)
                      : Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  ref.read(categoryFilterProvider.notifier).state = category;
                }
              },
              backgroundColor: isDarkMode
                  ? const Color(0xFF2C2C2C)
                  : Theme.of(context).cardColor,
              selectedColor: isDarkMode
                  ? Theme.of(context)
                      .primaryColor
                      .withOpacity(0.3) // Lighter shade in dark mode
                  : Theme.of(context).primaryColor.withOpacity(0.2),
              showCheckmark: false,
            ),
          );
        },
      ),
    );
  }

  Widget _buildTaskCard(
      Task task, BuildContext context, WidgetRef ref, bool isLargePhone) {
    final isDarkMode = ref.watch(preferencesProvider).isDarkMode;

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(
          Icons.delete_rounded,
          color: Colors.white,
          size: 28,
        ),
      ),
      onDismissed: (_) {
        ref.read(taskProvider.notifier).deleteTask(task.id);
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: isDarkMode ? const Color(0xFF2C2C2C) : Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showTaskDetails(context, task, ref),
          onLongPress: () => _showEditTaskDialog(context, ref, task),
          child: Padding(
            padding: EdgeInsets.all(isLargePhone ? 16 : 14),
            child: SizedBox(
              height: isLargePhone ? 160 : 140,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Checkbox
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          task.title,
                          style: TextStyle(
                            fontSize: isLargePhone ? 18 : 16,
                            fontWeight: FontWeight.bold,
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            color: isDarkMode ? Colors.white : null,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        height: 28,
                        width: 28,
                        child: Checkbox(
                          value: task.isCompleted,
                          onChanged: (_) {
                            ref.read(taskProvider.notifier).toggleTask(task.id);
                          },
                        ),
                      ),
                    ],
                  ),

                  // Description
                  if (task.description.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final textSpan = TextSpan(
                            text: task.description,
                            style: TextStyle(
                              color: isDarkMode
                                  ? Colors.grey.shade300
                                  : Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color
                                      ?.withOpacity(0.7),
                              fontSize: isLargePhone ? 16 : 14,
                              height: 1.3,
                            ),
                          );
                          final textPainter = TextPainter(
                            text: textSpan,
                            textDirection: TextDirection.ltr,
                            maxLines: 2,
                          );
                          textPainter.layout(maxWidth: constraints.maxWidth);

                          final isTextOverflowing =
                              textPainter.didExceedMaxLines;
                          final displayText = isTextOverflowing
                              ? '${task.description.substring(0, _findLastVisibleCharacterIndex(task.description, textPainter, constraints.maxWidth))}...'
                              : task.description;

                          return Text(
                            displayText,
                            style: TextStyle(
                              color: isDarkMode
                                  ? Colors.grey.shade300
                                  : Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color
                                      ?.withOpacity(0.7),
                              fontSize: isLargePhone ? 16 : 14,
                              height: 1.3,
                            ),
                            maxLines: 2,
                          );
                        },
                      ),
                    ),
                  ],

                  // Category and Date
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? Theme.of(context).primaryColor.withOpacity(0.2)
                              : Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          task.category,
                          style: TextStyle(
                            fontSize: isLargePhone ? 14 : 13,
                            color: isDarkMode
                                ? Colors.white
                                : Theme.of(context).textTheme.bodyMedium?.color,
                          ),
                        ),
                      ),
                      Text(
                        _formatDate(task.id),
                        style: TextStyle(
                          fontSize: isLargePhone ? 14 : 13,
                          color: isDarkMode
                              ? Colors.grey.shade400
                              : Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Add this helper method to find the last visible character
  int _findLastVisibleCharacterIndex(
      String text, TextPainter painter, double maxWidth) {
    int low = 0;
    int high = text.length;

    while (low < high) {
      final mid = (low + high) ~/ 2;
      painter.text = TextSpan(
        text: '${text.substring(0, mid)}...',
        style: painter.text!.style,
      );
      painter.layout(maxWidth: maxWidth);

      if (painter.didExceedMaxLines) {
        high = mid;
      } else {
        low = mid + 1;
      }
    }

    return low - 1;
  }

  Widget _buildTaskList(
      List<Task> tasks, bool isTablet, bool isLargePhone, WidgetRef ref) {
    return Builder(
      builder: (context) {
        if (tasks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.assignment_rounded,
                  size: 64,
                  color: Theme.of(context).iconTheme.color?.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'No tasks yet',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.color
                        ?.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: EdgeInsets.all(isLargePhone ? 16 : 8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isTablet ? 2 : 1,
            mainAxisSpacing: isLargePhone ? 16 : 8,
            crossAxisSpacing: isLargePhone ? 16 : 8,
            mainAxisExtent: isLargePhone ? 160 : 140,
          ),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return _buildTaskCard(task, context, ref, isLargePhone);
          },
        );
      },
    );
  }

  void _showFilterDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Tasks'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: TaskFilter.values.map((filter) {
            return RadioListTile<TaskFilter>(
              title: Text(filter.toString().split('.').last),
              value: filter,
              groupValue: ref.watch(taskFilterProvider),
              onChanged: (value) {
                ref.read(taskFilterProvider.notifier).state = value!;
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedCategory = 'Personal';
    final isDarkMode = ref.watch(preferencesProvider).isDarkMode;

    showDialog(
      context: context,
      builder: (context) => AnimatedPadding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).viewInsets.bottom > 0
              ? 20
              : MediaQuery.of(context).size.height * 0.1,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        duration: const Duration(milliseconds: 100),
        child: MediaQuery.removeViewInsets(
          removeBottom: true,
          context: context,
          child: SingleChildScrollView(
            child: AlertDialog(
              backgroundColor:
                  isDarkMode ? const Color(0xFF2C2C2C) : Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              title: Row(
                children: [
                  Icon(Icons.add_task_rounded,
                      color: Theme.of(context).primaryColor),
                  const SizedBox(width: 8),
                  const Text('Add Task',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: 'Enter task title',
                        labelText: 'Title',
                        prefixIcon: const Icon(Icons.title_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Enter task description',
                        labelText: 'Description',
                        prefixIcon: const Icon(Icons.description_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: InputDecoration(
                        labelText: 'Category',
                        prefixIcon: const Icon(Icons.category_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      items: ['Work', 'Personal', 'Shopping', 'Others']
                          .map((category) => DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              ))
                          .toList(),
                      onChanged: (value) {
                        selectedCategory = value!;
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isSmallScreen = constraints.maxWidth < 300;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: isSmallScreen
                                ? null
                                : constraints.maxWidth * 0.38,
                            child: TextButton.icon(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.close_rounded,
                                size: 20,
                              ),
                              label: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 14 : 16,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.grey,
                                padding: EdgeInsets.symmetric(
                                  horizontal: isSmallScreen ? 8 : 12,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: isSmallScreen
                                ? null
                                : constraints.maxWidth * 0.38,
                            child: FilledButton.icon(
                              onPressed: () {
                                if (titleController.text.isNotEmpty) {
                                  ref.read(taskProvider.notifier).addTask(
                                        titleController.text,
                                        description: descriptionController.text,
                                        category: selectedCategory,
                                      );
                                  Navigator.pop(context);
                                }
                              },
                              icon: const Icon(Icons.add_rounded),
                              label: Text(
                                'Add Task',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 14 : 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              style: FilledButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: isSmallScreen ? 8 : 12,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSortDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sort Tasks'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('By Date'),
              value: 'date',
              groupValue: ref.watch(preferencesProvider).sortOrder,
              onChanged: (value) {
                ref.read(preferencesProvider.notifier).setSortOrder(value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('Alphabetically'),
              value: 'alphabetical',
              groupValue: ref.watch(preferencesProvider).sortOrder,
              onChanged: (value) {
                ref.read(preferencesProvider.notifier).setSortOrder(value!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String taskId) {
    try {
      final date = DateTime.parse(taskId);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return '';
    }
  }

  void _showEditTaskDialog(BuildContext context, WidgetRef ref, Task task) {
    final titleController = TextEditingController(text: task.title);
    final descriptionController = TextEditingController(text: task.description);
    String selectedCategory = task.category;
    final isDarkMode = ref.watch(preferencesProvider).isDarkMode;

    showDialog(
      context: context,
      builder: (context) => AnimatedPadding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).viewInsets.bottom > 0
              ? 20
              : MediaQuery.of(context).size.height * 0.1,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        duration: const Duration(milliseconds: 100),
        child: MediaQuery.removeViewInsets(
          removeBottom: true,
          context: context,
          child: SingleChildScrollView(
            child: AlertDialog(
              backgroundColor:
                  isDarkMode ? const Color(0xFF2C2C2C) : Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              title: Row(
                children: [
                  Icon(Icons.edit_rounded,
                      color: Theme.of(context).primaryColor),
                  const SizedBox(width: 8),
                  const Text('Edit Task',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: 'Enter task title',
                        labelText: 'Title',
                        prefixIcon: const Icon(Icons.title_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Enter task description',
                        labelText: 'Description',
                        prefixIcon: const Icon(Icons.description_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: InputDecoration(
                        labelText: 'Category',
                        prefixIcon: const Icon(Icons.category_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      items: ['Work', 'Personal', 'Shopping', 'Others']
                          .map((category) => DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              ))
                          .toList(),
                      onChanged: (value) {
                        selectedCategory = value!;
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  label: const Text('Cancel'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey,
                  ),
                ),
                FilledButton.icon(
                  onPressed: () {
                    if (titleController.text.isNotEmpty) {
                      ref.read(taskProvider.notifier).editTask(
                            task.id,
                            titleController.text,
                            descriptionController.text,
                            selectedCategory,
                          );
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTaskDetails(BuildContext context, Task task, WidgetRef ref) {
    final isDarkMode = ref.watch(preferencesProvider).isDarkMode;
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    // Hide keyboard when dialog opens
    FocusScope.of(context).unfocus();

    showDialog(
      context: context,
      builder: (context) => AnimatedPadding(
        padding: EdgeInsets.only(
          top: keyboardVisible ? 20 : MediaQuery.of(context).size.height * 0.1,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        duration: const Duration(milliseconds: 100),
        child: MediaQuery.removeViewInsets(
          removeBottom: true,
          context: context,
          child: SingleChildScrollView(
            child: AlertDialog(
              backgroundColor:
                  isDarkMode ? const Color(0xFF2C2C2C) : Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              title: Row(
                children: [
                  Icon(
                    task.isCompleted
                        ? Icons.check_circle
                        : Icons.circle_outlined,
                    color: task.isCompleted ? Colors.green : Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      task.title,
                      style: TextStyle(
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (task.description.isNotEmpty) ...[
                    ListTile(
                      leading: const Icon(Icons.description_rounded),
                      title: const Text(
                        'Description',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      subtitle: Text(
                        task.description,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    const Divider(),
                  ],
                  ListTile(
                    leading: const Icon(Icons.category_rounded),
                    title: const Text(
                      'Category',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    subtitle: Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        task.category,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.calendar_today_rounded),
                    title: const Text(
                      'Created',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    subtitle: Text(
                      _formatDate(task.id),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  label: const Text('Close'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey,
                  ),
                ),
                FilledButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _showEditTaskDialog(context, ref, task);
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
