import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/news_provider.dart';
import '../models/news_item.dart';
import '../utils/colors.dart';
import 'news_detail_screen.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Latest News',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primaryPurple,
        elevation: 0,
        centerTitle: true,
      ),
      body: Consumer<NewsProvider>(
        builder: (context, newsProvider, child) {
          return Column(
            children: [
              // Categories horizontal list
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: newsProvider.categories.length,
                  itemBuilder: (context, index) {
                    final category = newsProvider.categories[index];
                    final isSelected = newsProvider.selectedCategory == category;

                    return GestureDetector(
                      onTap: () => newsProvider.setCategory(category),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primaryPurple : (isDark ? AppColors.cardDark : Colors.white),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? AppColors.primaryPurple : Colors.grey.withValues(alpha: 0.3),
                          ),
                          boxShadow: isSelected ? [
                            BoxShadow(
                              color: AppColors.primaryPurple.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ] : null,
                        ),
                        child: Center(
                          child: Text(
                            category,
                            style: GoogleFonts.poppins(
                              color: isSelected ? Colors.white : (isDark ? Colors.white : Colors.grey[800]),
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // Error Banner
              if (newsProvider.error.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.amber.withValues(alpha: 0.2),
                  width: double.infinity,
                  child: Text(
                    newsProvider.error,
                    style: GoogleFonts.poppins(color: Colors.orange[800], fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),

              // News List
              Expanded(
                child: newsProvider.isLoading && newsProvider.newsList.isEmpty
                    ? const Center(child: CircularProgressIndicator(color: AppColors.primaryPurple))
                    : RefreshIndicator(
                        color: AppColors.primaryPurple,
                        onRefresh: () => newsProvider.fetchNews(forceRefresh: true),
                        child: newsProvider.newsList.isEmpty
                            ? ListView(
                                children: [
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                                  Center(
                                    child: Text(
                                      'No news found in this category.',
                                      style: GoogleFonts.poppins(color: Colors.grey),
                                    ),
                                  ),
                                ],
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: newsProvider.newsList.length,
                                itemBuilder: (context, index) {
                                  final news = newsProvider.newsList[index];
                                  return _buildNewsCard(context, news, isDark);
                                },
                              ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNewsCard(BuildContext context, NewsItem news, bool isDark) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 300),
            pageBuilder: (_, __, ___) => NewsDetailScreen(news: news),
            transitionsBuilder: (_, animation, __, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                )),
                child: child,
              );
            },
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: news.imageUrl,
              child: CachedNetworkImage(
                imageUrl: news.imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 180,
                  color: isDark ? Colors.grey[800] : Colors.grey[300],
                  child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 180,
                  color: isDark ? Colors.grey[800] : Colors.grey[300],
                  child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryPurple.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          news.category,
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryPurple,
                          ),
                        ),
                      ),
                      Text(
                        news.date,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    news.title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    news.description,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: isDark ? AppColors.textSecondaryDark : Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
