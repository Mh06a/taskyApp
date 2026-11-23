
import 'package:flutter/material.dart';
import 'package:tasky/core/constants/limits.dart';
import 'package:tasky/core/enums/priority.dart';
import 'package:tasky/core/enums/validation_error.dart';
import 'package:tasky/core/validators/validators.dart';
import 'package:tasky/domain/entities/task.dart';
import 'package:tasky/presentation/controllers/tasks_controller.dart';

class TaskFormController extends ChangeNotifier {
  TaskFormController({
    required TasksController tasksController,
    Task? editingTask,
  })  : _tasksController = tasksController,
        _editingTask = editingTask,
        titleController = TextEditingController(text: editingTask?.title),
        descriptionController = TextEditingController(
          text: editingTask?.description,
        ),
        _priority = editingTask?.priority ?? Priority.normal,
        _dueDate = editingTask?.dueDate,
        _hasDueTime = editingTask?.hasDueTime ?? false {
    titleController.addListener(_clearTitleError);
    descriptionController.addListener(_clearDescriptionError);
  }

  final TasksController _tasksController;
  final Task? _editingTask;

  final TextEditingController titleController;
  final TextEditingController descriptionController;

  Priority _priority;
  DateTime? _dueDate;
  bool _hasDueTime;
  bool _isSaving = false;

  ValidationError? _titleError;
  ValidationError? _descriptionError;

  // State
  bool get isEditing => _editingTask != null;
  Priority get priority => _priority;
  DateTime? get dueDate => _dueDate;
  bool get hasDueTime => _hasDueTime && _dueDate != null;
  bool get isSaving => _isSaving;

  DateTime get now => _tasksController.currentTime;
  String? get errorMessage => _tasksController.errorMessage;

  TimeOfDay? get time {
    final current = _dueDate;

    return hasDueTime && current != null
        ? TimeOfDay.fromDateTime(current)
        : null;
  }

  String? get titleErrorText => switch (_titleError) {
    ValidationError.titleEmpty => 'Task title is required',
    ValidationError.titleTooLong =>
    'Maximum ${Limits.taskTitle} characters',
    _ => null,
  };

  String? get descriptionErrorText => switch (_descriptionError) {
    ValidationError.descriptionTooLong =>
    'Maximum ${Limits.taskDescription} characters',
    _ => null,
  };

  // Setters
  void setPriority(Priority value) {
    if (_priority == value) return;

    _priority = value;
    notifyListeners();
  }

  void setDate(DateTime selected) {
    final current = _dueDate;

    final hour = hasDueTime ? current?.hour ?? 0 : 0;
    final minute = hasDueTime ? current?.minute ?? 0 : 0;

    _dueDate = DateTime(
      selected.year,
      selected.month,
      selected.day,
      hour,
      minute,
    );

    notifyListeners();
  }

  void setTime(TimeOfDay value) {
    final current = _dueDate;

    if (current == null) return;

    _dueDate = DateTime(
      current.year,
      current.month,
      current.day,
      value.hour,
      value.minute,
    );

    _hasDueTime = true;
    notifyListeners();
  }

  void removeTime() {
    final current = _dueDate;

    if (current != null) {
      _dueDate = DateTime(
        current.year,
        current.month,
        current.day,
      );
    }

    _hasDueTime = false;
    notifyListeners();
  }

  void removeDate() {
    _dueDate = null;
    _hasDueTime = false;
    notifyListeners();
  }

  // Submit
  /// Validates and saves. Returns true when the task was stored.
  Future<bool> submit() async {
    if (_isSaving || !_validate()) return false;

    _isSaving = true;
    notifyListeners();

    try {
      final title = titleController.text.trim();
      final description = descriptionController.text.trim();

      final editing = _editingTask;

      if (editing == null) {
        return await _tasksController.addNewTask(
          title: title,
          description: description,
          priority: _priority,
          dueDate: _dueDate,
          hasDueTime: hasDueTime,
        );
      }

      return await _tasksController.updateExistingTask(
        editing.copyWith(
          title: title,
          description: description,
          priority: _priority,
          dueDate: _dueDate,
          hasDueTime: hasDueTime,
        ),
      );
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  // Validation
  bool _validate() {
    _titleError = Validators.taskTitle(titleController.text.trim());

    _descriptionError = Validators.taskDescription(
      descriptionController.text.trim(),
    );

    notifyListeners();

    return _titleError == null && _descriptionError == null;
  }

  // Field errors
  void _clearFieldError({
    required ValidationError? error,
    required void Function() onClear,
  }) {
    if (error == null) return;

    onClear();
    notifyListeners();
  }

  void _clearTitleError() {
    _clearFieldError(
      error: _titleError,
      onClear: () => _titleError = null,
    );
  }

  void _clearDescriptionError() {
    _clearFieldError(
      error: _descriptionError,
      onClear: () => _descriptionError = null,
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
