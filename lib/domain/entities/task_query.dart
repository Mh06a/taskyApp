import 'package:equatable/equatable.dart';
import 'package:tasky/core/enums/task_sort.dart';
import 'package:tasky/core/enums/task_status_filter.dart';

final class TaskQuery extends Equatable {
  const TaskQuery({
    this.searchText = '',
    this.status = TaskStatusFilter.all,
    this.onlyHighPriority = false,
    this.sort = TaskSort.newest,
  });

  final String searchText;
  final TaskStatusFilter status;
  final bool onlyHighPriority;
  final TaskSort sort;

  TaskQuery copyWith({
    String? searchText,
    TaskStatusFilter? status,
    bool? onlyHighPriority,
    TaskSort? sort,
  }) {
    return TaskQuery(
      searchText: searchText ?? this.searchText,
      status: status ?? this.status,
      onlyHighPriority: onlyHighPriority ?? this.onlyHighPriority,
      sort: sort ?? this.sort,
    );
  }

  @override
  List<Object?> get props => [searchText, status, onlyHighPriority, sort];
}
