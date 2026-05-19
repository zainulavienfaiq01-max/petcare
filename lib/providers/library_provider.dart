import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/breed.dart';

/// Provider that manages the Pet Library state:
/// - Favorites (bookmarks)
/// - Active breed type selection (dog/cat)
/// - Search query
class LibraryProvider extends ChangeNotifier {
  // ─── Favorites ─────────────────────────────────────────────────────────────
  final Set<String> _favoriteIds = {};

  Set<String> get favoriteIds => _favoriteIds;

  bool isFavorite(Breed breed) => _favoriteIds.contains(breed.id);

  Future<void> toggleFavorite(Breed breed) async {
    if (_favoriteIds.contains(breed.id)) {
      _favoriteIds.remove(breed.id);
    } else {
      _favoriteIds.add(breed.id);
    }
    notifyListeners();
    await _saveFavorites();
  }

  // ─── Persistence ────────────────────────────────────────────────────────────
  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('library_favorites') ?? [];
    _favoriteIds.addAll(saved);
    notifyListeners();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('library_favorites', _favoriteIds.toList());
  }
}
