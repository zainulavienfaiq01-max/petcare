import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'models/pet.dart';
import 'models/schedule.dart';
import 'models/health_record.dart';
import 'providers/pet_provider.dart';
import 'providers/schedule_provider.dart';
import 'providers/health_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'services/notification_service.dart';
import 'utils/theme.dart';
import 'utils/constants.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  Hive.registerAdapter(PetAdapter());
  Hive.registerAdapter(ScheduleAdapter());
  Hive.registerAdapter(HealthRecordAdapter());
  
  await Hive.openBox<Pet>(AppConstants.petBox);
  await Hive.openBox<Schedule>(AppConstants.scheduleBox);
  await Hive.openBox<HealthRecord>(AppConstants.healthBox);
  
  final notificationService = NotificationService();
  await notificationService.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PetProvider()),
        ChangeNotifierProvider(create: (_) => ScheduleProvider()),
        ChangeNotifierProvider(create: (_) => HealthProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}