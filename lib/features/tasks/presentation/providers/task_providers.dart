import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/task.dart';

part 'task_providers.g.dart';

@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';
}

@riverpod
class SortOrder extends _$SortOrder {
  @override
  String build() => 'date';
}

@riverpod
class SelectedTask extends _$SelectedTask {
  @override
  Task? build() => null;
}
