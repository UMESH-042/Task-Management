class Task {
  final String id;
  final String title;
  final bool isCompleted;
  final String category;
  final String description;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.category = 'default',
    this.description = '',
  });

  copyWith({required bool isCompleted}) {}
}
