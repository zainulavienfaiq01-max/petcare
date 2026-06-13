import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/news_item.dart';

class NewsProvider with ChangeNotifier {
  List<NewsItem> _newsList = [];
  bool _isLoading = false;
  String _error = '';
  String _selectedCategory = 'All';

  final List<String> categories = [
    'All',
    'Trending News',
    'Pet Care',
    'Animal Health',
    'Veterinary',
    'Wildlife',
  ];

  List<NewsItem> get newsList {
    if (_selectedCategory == 'All') return _newsList;
    return _newsList.where((n) => n.category == _selectedCategory).toList();
  }

  bool get isLoading => _isLoading;
  String get error => _error;
  String get selectedCategory => _selectedCategory;

  NewsProvider() {
    fetchNews();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> fetchNews({bool forceRefresh = false}) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Check cache first if not forced
      if (!forceRefresh) {
        final cachedData = prefs.getString('cached_news');
        final lastFetch = prefs.getInt('cached_news_time') ?? 0;
        final now = DateTime.now().millisecondsSinceEpoch;
        
        // Cache valid for 12 hours
        if (cachedData != null && (now - lastFetch) < 12 * 60 * 60 * 1000) {
          final List<dynamic> decoded = json.decode(cachedData);
          _newsList = decoded.map((e) => NewsItem.fromJson(e)).toList();
          _isLoading = false;
          notifyListeners();
          return;
        }
      }

      // 1. Fetch from BBC topics
      final url = 'https://www.bbc.com/news/topics/c51grdzv08yt';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final document = parser.parse(response.body);
        final List<NewsItem> fetchedNews = [];
        
        // In structural web scraping, class names vary. We look for standard promo tags.
        final promoBlocks = document.querySelectorAll('[data-testid="promo"]');
        
        for (var i = 0; i < promoBlocks.length; i++) {
          final block = promoBlocks[i];
          final aTag = block.querySelector('a.focusIndicatorDisplayBlock');
          final textBlocks = block.querySelectorAll('p[data-testid="card-description"]');
          final titleBlocks = block.querySelectorAll('h2[data-testid="card-headline"]');
          final imgTag = block.querySelector('img');
          final dateBlocks = block.querySelectorAll('span[data-testid="card-metadata-lastupdated"]');
          
          if (titleBlocks.isNotEmpty && aTag != null) {
             final titleText = titleBlocks.first.text.trim();
             final descText = textBlocks.isNotEmpty ? textBlocks.first.text.trim() : titleText;
             var linkUrl = aTag.attributes['href'] ?? '';
             if (linkUrl.startsWith('/')) {
                linkUrl = 'https://www.bbc.com$linkUrl';
             }
             final imageUrl = imgTag?.attributes['src'] ?? '';
             final dateText = dateBlocks.isNotEmpty ? dateBlocks.first.text.trim() : 'Just now';
             
             // Analyze title to guess category
             String cat = 'Trending News';
             final lowerTitle = titleText.toLowerCase();
             if(lowerTitle.contains('dog') || lowerTitle.contains('cat') || lowerTitle.contains('pet')) { cat = 'Pet Care'; }
             else if(lowerTitle.contains('vet') || lowerTitle.contains('clinic')) { cat = 'Veterinary'; }
             else if(lowerTitle.contains('disease') || lowerTitle.contains('virus') || lowerTitle.contains('health')) { cat = 'Animal Health'; }
             else if(lowerTitle.contains('wild') || lowerTitle.contains('lion') || lowerTitle.contains('elephant')) { cat = 'Wildlife'; }
             
             // Filter out items without an image if possible, or use placeholder
             if (titleText.isNotEmpty) {
                 fetchedNews.add(NewsItem(
                   title: titleText,
                  category: cat,
                  date: dateText,
                  description: descText,
                  imageUrl: imageUrl.isNotEmpty ? imageUrl : 'https://images.unsplash.com/photo-1543466835-00a7907e9de1?auto=format&fit=crop&w=500&q=60',
                  link: linkUrl,
                 ));
             }
          }
        }
        
        if (fetchedNews.isNotEmpty) {
           _newsList = fetchedNews;
           
           // Cache it
           prefs.setString('cached_news', json.encode(_newsList.map((e) => e.toJson()).toList()));
           prefs.setInt('cached_news_time', DateTime.now().millisecondsSinceEpoch);
        } else {
           _loadFallbackNews();
        }
      } else {
        _loadFallbackNews();
        _error = 'Could not load live news. Showing offline cache.';
      }
    } catch (e) {
      // Fallback on error
      _loadFallbackNews();
      _error = 'No connection. Showing offline news.';
    }

    _isLoading = false;
    notifyListeners();
  }
  
  void _loadFallbackNews() {
    if (_newsList.isNotEmpty) return;
    
    // Robust mock fallback based on BBC style
    _newsList = [
      NewsItem(
        title: 'Dog owners to face unlimited fines if their pets attack livestock',
        category: 'Pet Care',
        date: '10 hrs ago',
        description: 'Under new laws proposed by the government, dog owners face harsh penalties for inadequate control in rural areas.',
        imageUrl: 'https://images.unsplash.com/photo-1543466835-00a7907e9de1?auto=format&fit=crop&w=500&q=60',
        link: 'https://www.bbc.com/news/uk-politics',
      ),
      NewsItem(
        title: 'Rare snow leopard cub born in sanctuary',
        category: 'Wildlife',
        date: '22 hrs ago',
        description: 'Conservationists celebrate the successful birth of a highly endangered snow leopard cub.',
        imageUrl: 'https://images.unsplash.com/photo-1589133465133-c46b10787eeb?auto=format&fit=crop&w=500&q=60',
        link: 'https://www.bbc.com/news/science-environment',
      ),
      NewsItem(
        title: 'New veterinary guidelines for feline vaccines',
        category: 'Veterinary',
        date: '1 day ago',
        description: 'Vets updated guidelines emphasize the importance of regular boosters for domestic cats.',
        imageUrl: 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?auto=format&fit=crop&w=500&q=60',
        link: 'https://www.bbc.com/news/health',
      ),
      NewsItem(
        title: 'Rising concerns over mysterious dog respiratory illness',
        category: 'Animal Health',
        date: '2 days ago',
        description: 'Veterinarians are investigating a surge in respiratory problems among dogs across the continent.',
        imageUrl: 'https://images.unsplash.com/photo-1576201836106-db1758fd1c97?auto=format&fit=crop&w=500&q=60',
        link: 'https://www.bbc.com/news/health',
      ),
      NewsItem(
        title: 'The man who rescued 200 stray street animals',
        category: 'Trending News',
        date: '3 days ago',
        description: 'An inspiring story of a local hero who converted his home into a safe haven for displaced street pets.',
        imageUrl: 'https://images.unsplash.com/photo-1504450758481-7338eba7524a?auto=format&fit=crop&w=500&q=60',
        link: 'https://www.bbc.com/news/world',
      )
    ];
  }
}
