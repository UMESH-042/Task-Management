import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'features/tasks/data/models/hive_task.dart';
import 'features/tasks/data/models/preferences.dart';
import 'features/tasks/presentation/screens/home_screen.dart';
import 'features/tasks/presentation/providers/preferences_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Adapters
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(HiveTaskAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(PreferencesAdapter());
  }

  // Open Boxes
  await Hive.openBox<HiveTask>('tasks');
  await Hive.openBox<Preferences>('preferences');

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(preferencesProvider).isDarkMode;

    return MaterialApp(
       debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: const HomeScreen(),
    );
  }
}
