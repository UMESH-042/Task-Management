import 'package:hive/hive.dart';

part 'preferences.g.dart';

@HiveType(typeId: 2)
class Preferences extends HiveObject {
  @HiveField(0)
  bool isDarkMode;

  @HiveField(1)
  String sortOrder; // 'date', 'priority', 'alphabetical'

  Preferences({
    this.isDarkMode = false,
    this.sortOrder = 'date',
  });
}
