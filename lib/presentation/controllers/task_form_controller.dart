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

  bool get isEditing => _editingTask != null;
  Priority get priority => _priority;
  DateTime? get dueDate => _dueDate;
  bool get hasDueTime => _hasDueTime && _dueDate != null;
  bool get isSaving => _isSaving;

  DateTime get now => _tasksController.currentTime;
  String? get errorMessage => _tasksController.errorMessage;

  TimeOfDay? get time {
    if (!hasDueTime || _dueDate == null) return null;

    return TimeOfDay.fromDateTime(_dueDate!);
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

  void setPriority(Priority value) {
    if (_priority == value) return;

    _priority = value;
    notifyListeners();
  }

  void setDate(DateTime selected) {
    final current = _dueDate;

    _dueDate = DateTime(
      selected.year,
      selected.month,
      selected.day,
      hasDueTime ? current?.hour ?? 0 : 0,
      hasDueTime ? current?.minute ?? 0 : 0,
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

  /// Validates and saves the task.
  /// Returns true when the operation succeeds.
  Future<bool> submit() async {
    if (_isSaving) return false;

    _tasksController.clearError();

    if (!_validate()) return false;

    _isSaving = true;
    notifyListeners();

    try {
      final title = titleController.text.trim();
      final description = descriptionController.text.trim();

      final editingTask = _editingTask;

      if (editingTask == null) {
        return await _tasksController.addNewTask(
          title: title,
          description: description,
          priority: _priority,
          dueDate: _dueDate,
          hasDueTime: hasDueTime,
        );
      }

      return await _tasksController.updateExistingTask(
        editingTask.copyWith(
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

  bool _validate() {
    _titleError = Validators.taskTitle(titleController.text.trim());
    _descriptionError = Validators.taskDescription(
      descriptionController.text.trim(),
    );

    notifyListeners();

    return _titleError == null && _descriptionError == null;
  }

  void _clearTitleError() {
    if (_titleError == null) return;

    _titleError = null;
    notifyListeners();
  }

  void _clearDescriptionError() {
    if (_descriptionError == null) return;

    _descriptionError = null;
    notifyListeners();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}