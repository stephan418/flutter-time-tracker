import 'package:freezed_annotation/freezed_annotation.dart';

part 'preferences.freezed.dart';
part 'preferences.g.dart';

/// {@template preferences_item}
/// A single container for any locally persisted preferences and state
///
/// Contains the [lastTaskId] which identifies the task most recently worked on
/// task
/// {@endtemplate}
@freezed
class Preferences with _$Preferences {
  /// {@macro preferences_item}
  const factory Preferences({
    required String lastTaskId,
  }) = _Preferences;

  /// Construct a new [Preferences] instance from a JSOn-style map
  factory Preferences.fromJson(Map<String, Object?> json) =>
      _$PreferencesFromJson(json);
}
