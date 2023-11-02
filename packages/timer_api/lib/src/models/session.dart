import 'package:freezed_annotation/freezed_annotation.dart';

part 'session.freezed.dart';
part 'session.g.dart';

/// {@template session_item}
/// A single `session` item.
///
/// A session is the representation of an amount of tracked time at any point in
/// time. It can also be linked to a Task.
/// Contains [seconds] elapse, a [startedAt] date and time, a [taskId] and an
/// [id].
/// {@endtemplate}
@freezed
class Session with _$Session {
  /// {@macro session_item}
  @Assert(
    'taskId == null || taskId.isNotEmpty',
    'taskId must either be null or not empty',
  )
  @Assert('id == null || id.isNotEmpty', 'id must either be null or not empty')
  factory Session({
    required int seconds,
    required DateTime startedAt,
    String? taskId,
    String? id,
  }) = _Session;

  /// Create a new Session from a Json-style map of objects
  factory Session.fromJson(Map<String, Object?> json) =>
      _$SessionFromJson(json);
}
