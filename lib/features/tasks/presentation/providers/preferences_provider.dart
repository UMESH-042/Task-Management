import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/hive_database.dart';
import '../../data/models/preferences.dart';

final preferencesProvider =
    StateNotifierProvider<PreferencesNotifier, Preferences>((ref) {
  return PreferencesNotifier();
});

class PreferencesNotifier extends StateNotifier<Preferences> {
  PreferencesNotifier() : super(Preferences()) {
    _loadPreferences();
  }

  void _loadPreferences() {
    final prefs = HiveDatabase().getPreferences();
    state = prefs;
  }

  void toggleTheme() {
    final newPrefs = Preferences(
      isDarkMode: !state.isDarkMode,
      sortOrder: state.sortOrder,
    );
    HiveDatabase().savePreferences(newPrefs);
    state = newPrefs;
  }

  void setSortOrder(String order) {
    final newPrefs = Preferences(
      isDarkMode: state.isDarkMode,
      sortOrder: order,
    );
    HiveDatabase().savePreferences(newPrefs);
    state = newPrefs;
  }
}

// Move sortedTasksProvider to task_provider.dart since it depends on taskProvider
