import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for multi-language support (Indonesian / English).
/// Uses SharedPreferences for persistence across app restarts.
class LocaleProvider extends ChangeNotifier {
  static const String _prefKey = 'app_locale';

  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  bool get isEnglish => _locale.languageCode == 'en';
  bool get isIndonesian => _locale.languageCode == 'id';

  /// Initialize locale from saved preferences.
  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefKey) ?? 'en';
    _locale = Locale(saved);
    notifyListeners();
  }

  /// Switch to Indonesian.
  Future<void> setIndonesian() async {
    _locale = const Locale('id');
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, 'id');
  }

  /// Switch to English.
  Future<void> setEnglish() async {
    _locale = const Locale('en');
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, 'en');
  }

  /// Toggle between en and id.
  Future<void> toggleLocale() async {
    if (isEnglish) {
      await setIndonesian();
    } else {
      await setEnglish();
    }
  }

  /// Translate a key based on current locale.
  String translate(String key) {
    if (isIndonesian) {
      return _id[key] ?? _en[key] ?? key;
    }
    return _en[key] ?? key;
  }

  // ─── English strings ────────────────────────────────────────────────────────
  static const Map<String, String> _en = {
    // General
    'app_name': 'PetCare',
    'language': 'Language',
    'english': 'English',
    'indonesian': 'Indonesian',
    'cancel': 'Cancel',
    'close': 'Close',
    'save': 'Save',
    'search': 'Search...',

    // Navigation
    'nav_home': 'Home',
    'nav_pets': 'Pets',
    'nav_schedule': 'Schedule',
    'nav_health': 'Health',
    'nav_profile': 'Profile',

    // Dashboard
    'welcome_back': 'Welcome Back!',
    'your_pets': 'Your Pets',
    'statistics': 'Statistics',
    'no_pets': 'No pets added yet',
    'todays_schedule': "Today's Schedule",
    'no_schedules': 'No schedules for today',
    'quick_actions': 'Quick Actions',
    'consultation': 'Consultation',
    'pet_news': 'Pet News',
    'total_pets': 'Total Pets',
    'todays_tasks': "Today's Tasks",
    'completed': 'Completed',
    'upcoming_vaccines': 'Upcoming Vaccines',

    // Pet Library
    'pet_library': 'Pet Library',
    'explore_breeds': 'Explore pet breeds',
    'dogs': 'Dogs',
    'cats': 'Cats',
    'dog_breeds': 'Dog Breeds',
    'cat_breeds': 'Cat Breeds',
    'search_breeds': 'Search breeds...',
    'no_breeds_found': 'No breeds found',
    'lifespan': 'Lifespan',
    'origin': 'Origin',
    'habitat': 'Habitat',
    'temperament': 'Temperament',
    'characteristics': 'Characteristics',
    'about': 'About',
    'size': 'Size',
    'favorites': 'Favorites',
    'add_favorite': 'Add to Favorites',
    'remove_favorite': 'Remove from Favorites',
    'no_favorites': 'No favorites yet',
    'add_to_favorites': 'Tap the heart icon to add breeds',

    // Profile
    'profile': 'Profile',
    'dark_mode': 'Dark Mode',
    'dark_mode_sub': 'Toggle dark theme',
    'about_app': 'About',
    'logout': 'Logout',
    'logout_confirm': 'Are you sure you want to logout?',
    'language_settings': 'Language Settings',
    'language_settings_sub': 'Change app language',
  };

  // ─── Indonesian strings ─────────────────────────────────────────────────────
  static const Map<String, String> _id = {
    // General
    'app_name': 'PetCare',
    'language': 'Bahasa',
    'english': 'Inggris',
    'indonesian': 'Indonesia',
    'cancel': 'Batal',
    'close': 'Tutup',
    'save': 'Simpan',
    'search': 'Cari...',

    // Navigation
    'nav_home': 'Beranda',
    'nav_pets': 'Hewan',
    'nav_schedule': 'Jadwal',
    'nav_health': 'Kesehatan',
    'nav_profile': 'Profil',

    // Dashboard
    'welcome_back': 'Selamat Datang Kembali!',
    'your_pets': 'Hewan Peliharaan',
    'statistics': 'Statistik',
    'no_pets': 'Belum ada hewan yang ditambahkan',
    'todays_schedule': 'Jadwal Hari Ini',
    'no_schedules': 'Tidak ada jadwal hari ini',
    'quick_actions': 'Aksi Cepat',
    'consultation': 'Konsultasi',
    'pet_news': 'Berita Hewan',
    'total_pets': 'Total Hewan',
    'todays_tasks': 'Tugas Hari Ini',
    'completed': 'Selesai',
    'upcoming_vaccines': 'Vaksin Mendatang',

    // Pet Library
    'pet_library': 'Perpustakaan Hewan',
    'explore_breeds': 'Jelajahi jenis hewan',
    'dogs': 'Anjing',
    'cats': 'Kucing',
    'dog_breeds': 'Jenis Anjing',
    'cat_breeds': 'Jenis Kucing',
    'search_breeds': 'Cari jenis hewan...',
    'no_breeds_found': 'Tidak ada jenis yang ditemukan',
    'lifespan': 'Masa Hidup',
    'origin': 'Asal',
    'habitat': 'Habitat',
    'temperament': 'Temperamen',
    'characteristics': 'Karakteristik',
    'about': 'Tentang',
    'size': 'Ukuran',
    'favorites': 'Favorit',
    'add_favorite': 'Tambah ke Favorit',
    'remove_favorite': 'Hapus dari Favorit',
    'no_favorites': 'Belum ada favorit',
    'add_to_favorites': 'Ketuk ikon hati untuk menambahkan jenis',

    // Profile
    'profile': 'Profil',
    'dark_mode': 'Mode Gelap',
    'dark_mode_sub': 'Ganti tema gelap',
    'about_app': 'Tentang',
    'logout': 'Keluar',
    'logout_confirm': 'Apakah Anda yakin ingin keluar?',
    'language_settings': 'Pengaturan Bahasa',
    'language_settings_sub': 'Ubah bahasa aplikasi',
  };
}
