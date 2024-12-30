import 'package:hive_flutter/hive_flutter.dart';
import '../models/hive_task.dart';
import '../models/preferences.dart';

class HiveDatabase {
  static const String tasksBoxName = 'tasks';
  static const String prefsBoxName = 'preferences';

  late final Box<Preferences> _prefsBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(HiveTaskAdapter());
    Hive.registerAdapter(PreferencesAdapter());
    await Hive.openBox<HiveTask>(tasksBoxName);
    await Hive.openBox<Preferences>(prefsBoxName);
  }

  static Box<HiveTask> getTasksBox() {
    return Hive.box<HiveTask>(tasksBoxName);
  }

  Preferences getPreferences() {
    _prefsBox = Hive.box<Preferences>(prefsBoxName);
    return _prefsBox.get('preferences') ?? Preferences();
  }

  Future<void> savePreferences(Preferences prefs) async {
    _prefsBox = Hive.box<Preferences>(prefsBoxName);
    await _prefsBox.put('preferences', prefs);
  }
}
