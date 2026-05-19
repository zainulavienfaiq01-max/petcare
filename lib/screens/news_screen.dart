import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';
import 'news_detail_screen.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Trending News',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primaryPurple,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return _buildNewsCard(context, index);
        },
      ),
    );
  }

  Widget _buildNewsCard(BuildContext context, int index) {
    final List<Map<String, String>> dummyNews = [
      {
        'title': 'Anjing Terlantar Diselamatkan di Jakarta, Kini Butuh Adopsi',
        'category': 'Adoption',
        'date': '18 May 2026',
        'description': 'Seekor anjing ditemukan terlantar di kawasan Jakarta Selatan dan kini dirawat di shelter...',
        'image': 'https://images.unsplash.com/photo-1543466835-00a7907e9de1?auto=format&fit=crop&w=500&q=60',
      },
      {
        'title': 'Vaksin Rabies Gratis di Bandung Diserbu Ribuan Pemilik Hewan',
        'category': 'Health',
        'date': '17 May 2026',
        'description': 'Pemerintah kota Bandung mengadakan vaksinasi rabies gratis untuk anjing dan kucing...',
        'image': 'https://images.unsplash.com/photo-1576201836106-db1758fd1c97?auto=format&fit=crop&w=500&q=60',
      },
      {
        'title': 'Pameran Kucing Internasional Hadir di ICE BSD Minggu Ini',
        'category': 'Event',
        'date': '15 May 2026',
        'description': 'Bagi para pecinta kucing, bersiaplah untuk pameran terbesar tahun ini yang akan digelar...',
        'image': 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?auto=format&fit=crop&w=500&q=60',
      },
      {
        'title': 'Tips Menjaga Nutrisi Kucing Persia Agar Bulu Tetap Lebat',
        'category': 'Nutrition',
        'date': '12 May 2026',
        'description': 'Kucing persia membutuhkan perawatan khusus terutama pada asupan makanannya...',
        'image': 'https://images.unsplash.com/photo-1533738363-b7f9aef128ce?auto=format&fit=crop&w=500&q=60',
      },
      {
        'title': 'Komunitas Reptil Surabaya Berikan Edukasi Cara Merawat Ular',
        'category': 'Education',
        'date': '10 May 2026',
        'description': 'Semakin banyaknya pecinta reptil membuat komunitas ini bergerak untuk mengedukasi...',
        'image': 'https://images.unsplash.com/photo-1504450758481-7338eba7524a?auto=format&fit=crop&w=500&q=60',
      },
    ];

    final news = dummyNews[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            news['image']!,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 180,
                color: Colors.grey[300],
                child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
              );
            },
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
                        color: AppColors.primaryPurple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        news['category']!,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryPurple,
                        ),
                      ),
                    ),
                    Text(
                      news['date']!,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  news['title']!,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  news['description']!,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewsDetailScreen(news: news),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryPurple,
                      side: const BorderSide(color: AppColors.primaryPurple),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Read More',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
