class AppConstants {
  static const String appName = 'PetCare';
  static const String appVersion = '1.0.0';

  // Hive Box Names
  static const String petBox = 'pets';
  static const String scheduleBox = 'schedules';
  static const String healthBox = 'health_records';

  // SharedPreferences Keys
  static const String keyIsDarkMode = 'is_dark_mode';
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyUserName = 'user_name';
  static const String keyUserEmail = 'user_email';

  // Pet Types
  static const List<String> petTypes = [
    'Kucing',
    'Anjing',
    'Burung',
    'Hamster',
    'Kelinci',
    'Ikan',
    'Reptil',
    'Lainnya',
  ];

  // Schedule Types
  static const List<String> scheduleTypes = [
    'Makan',
    'Vaksin',
    'Grooming',
    'Kontrol Dokter',
  ];

  // Pet Type Icons (emoji)
  static const Map<String, String> petTypeEmoji = {
    'Kucing': '🐱',
    'Anjing': '🐶',
    'Burung': '🐦',
    'Hamster': '🐹',
    'Kelinci': '🐰',
    'Ikan': '🐟',
    'Reptil': '🦎',
    'Lainnya': '🐾',
  };

  // Schedule Type Icons
  static const Map<String, String> scheduleTypeEmoji = {
    'Makan': '🍖',
    'Vaksin': '💉',
    'Grooming': '✂️',
    'Kontrol Dokter': '🩺',
  };
}
