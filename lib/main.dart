import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/pet.dart';
import 'models/schedule.dart';
import 'models/health_record.dart';
import 'providers/auth_provider.dart';
import 'providers/pet_provider.dart';
import 'providers/schedule_provider.dart';
import 'providers/health_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/library_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/audio_provider.dart';
import 'services/notification_service.dart';
import 'utils/theme.dart';
import 'utils/constants.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait for mobile
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize Hive for Flutter
  await Hive.initFlutter();

  // Register Hive type adapters
  Hive.registerAdapter(PetAdapter());
  Hive.registerAdapter(ScheduleAdapter());
  Hive.registerAdapter(HealthRecordAdapter());

  // Open Hive boxes
  await Hive.openBox<Pet>(AppConstants.petBox);
  await Hive.openBox<Schedule>(AppConstants.scheduleBox);
  await Hive.openBox<HealthRecord>(AppConstants.healthBox);

  // Initialize notification service for mobile
  await NotificationService().init();

  // Load locale preference before first frame
  final localeProvider = LocaleProvider();
  await localeProvider.loadLocale();

  // Load library favorites before first frame
  final libraryProvider = LibraryProvider();
  await libraryProvider.loadFavorites();

  runApp(PetCareApp(
    localeProvider: localeProvider,
    libraryProvider: libraryProvider,
  ));
}

class PetCareApp extends StatelessWidget {
  final LocaleProvider localeProvider;
  final LibraryProvider libraryProvider;

  const PetCareApp({
    super.key,
    required this.localeProvider,
    required this.libraryProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PetProvider()),
        ChangeNotifierProvider(create: (_) => ScheduleProvider()),
        ChangeNotifierProvider(create: (_) => HealthProvider()),
        // New providers
        ChangeNotifierProvider.value(value: localeProvider),
        ChangeNotifierProvider.value(value: libraryProvider),
        ChangeNotifierProvider(create: (_) => AudioProvider(), lazy: false),
      ],
      child: Consumer2<ThemeProvider, LocaleProvider>(
        builder: (context, themeProvider, locale, child) {
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode:
                themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            // Locale support
            locale: locale.locale,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}