import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:preferences_api/preferences_api.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template local_preferences_api}
/// An implementation of the [PreferencesApi] that store preferences in local
/// storage.
/// {@endtemplate}
class LocalPreferencesApi extends PreferencesApi {
  /// {@macro local_preferences_api}
  LocalPreferencesApi({required SharedPreferences plugin}) : _plugin = plugin {
    _init();
  }

  final SharedPreferences _plugin;

  final _preferencesStreamController =
      BehaviorSubject<Preferences?>.seeded(null);

  /// shared_preferences key for the preferences model
  @visibleForTesting
  static const kPreferencesKey = '__preferences_key__';

  String? _getValue(String key) => _plugin.getString(key);
  Future<void> _setValue(String key, String value) =>
      _plugin.setString(key, value);

  void _init() {
    final preferencesJson = _getValue(kPreferencesKey);

    if (preferencesJson == null) {
      _preferencesStreamController.add(null);
      return;
    }

    final rawPreferences =
        json.decode(preferencesJson) as Map<dynamic, dynamic>;

    final preferences =
        Preferences.fromJson(Map<String, dynamic>.from(rawPreferences));

    _preferencesStreamController.add(preferences);
  }

  @override
  Stream<Preferences?> getPreferences() =>
      _preferencesStreamController.asBroadcastStream();

  @override
  Future<void> savePreferences(Preferences preferences) async {
    _preferencesStreamController.add(preferences);
    await _setValue(kPreferencesKey, json.encode(preferences));
  }
}
