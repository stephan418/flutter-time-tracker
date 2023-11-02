import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';
part 'task.g.dart';

/// {@template task_item}
/// A single `Task` item.
///
/// Contains a [title], a [description] and an [id].
/// The [id] must either be null (indicating a new object) or non-empty
/// {@endtemplate}
@freezed
class Task with _$Task {
  /// {@macro task_item}
  @Assert('id == null || id.isNotEmpty', 'id must either be null or not empty')
  factory Task({
    required String title,
    required String description,
    String? id,
  }) = _Person;

  /// Create a new Person form a JSON-style map of objects
  factory Task.fromJson(Map<String, Object?> json) => _$TaskFromJson(json);
}
