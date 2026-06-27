import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/breed.dart';
import '../providers/library_provider.dart';
import '../providers/locale_provider.dart';
import '../services/breed_data_service.dart';
import '../utils/colors.dart';
import 'breed_detail_screen.dart';

/// Displays a searchable, filterable list of dog or cat breeds.
class BreedListScreen extends StatefulWidget {
  final String type; // 'dog' or 'cat'

  static const int dogCount = 10;
  static const int catCount = 10;

  const BreedListScreen({super.key, required this.type});

  @override
  State<BreedListScreen> createState() => _BreedListScreenState();
}

class _BreedListScreenState extends State<BreedListScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _listController;
  String _query = '';
  bool _showFavoritesOnly = false;

  // Gradient configs per type
  LinearGradient get _gradient => widget.type == 'dog'
      ? const LinearGradient(
          colors: [Color(0xFFf6a623), Color(0xFFf0845c)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
      : const LinearGradient(
          colors: [Color(0xFF8360c3), Color(0xFF2ebf91)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

  @override
  void initState() {
    super.initState();
    _listController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();

    // Load saved favorites on open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LibraryProvider>().loadFavorites();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _listController.dispose();
    super.dispose();
  }

  List<Breed> _getFilteredBreeds(LibraryProvider lib) {
    List<Breed> breeds = _query.isEmpty
        ? BreedDataService.getBreedsByType(widget.type)
        : BreedDataService.searchBreeds(_query, widget.type);

    if (_showFavoritesOnly) {
      breeds = breeds.where((b) => lib.isFavorite(b)).toList();
    }
    return breeds;
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>();
    final t = locale.translate;
    final isDog = widget.type == 'dog';

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Consumer<LibraryProvider>(
        builder: (context, lib, _) {
          final breeds = _getFilteredBreeds(lib);

          return CustomScrollView(
            slivers: [
              // ── Gradient SliverAppBar ────────────────────────────────────
              SliverAppBar(
                expandedHeight: 160,
                pinned: true,
                backgroundColor: isDog
                    ? const Color(0xFFf6a623)
                    : const Color(0xFF8360c3),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  // Favorites toggle
                  IconButton(
                    icon: Icon(
                      _showFavoritesOnly
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.white,
                    ),
                    tooltip: t('favorites'),
                    onPressed: () =>
                        setState(() => _showFavoritesOnly = !_showFavoritesOnly),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(gradient: _gradient),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 36),
                          Text(
                            isDog ? '🐶' : '🐱',
                            style: const TextStyle(fontSize: 40),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            isDog ? t('dog_breeds') : t('cat_breeds'),
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  titlePadding: EdgeInsets.zero,
                ),
              ),

              // ── Search Bar ───────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (v) => setState(() => _query = v),
                    decoration: InputDecoration(
                      hintText: t('search_breeds'),
                      hintStyle: GoogleFonts.poppins(color: Colors.grey),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      suffixIcon: _query.isNotEmpty
                          ? IconButton(
                              icon:
                                  const Icon(Icons.clear, color: Colors.grey),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _query = '');
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 14),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Colors.grey.withValues(alpha: 0.2),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: isDog
                              ? const Color(0xFFf6a623)
                              : AppColors.primaryPurple,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ── Favorites filter chip ────────────────────────────────────
              if (_showFavoritesOnly)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Icon(Icons.favorite,
                            color: Colors.red[400], size: 16),
                        const SizedBox(width: 6),
                        Text(
                          t('favorites'),
                          style: GoogleFonts.poppins(
                            color: Colors.red[400],
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () =>
                              setState(() => _showFavoritesOnly = false),
                          child: Text(
                            'Show All',
                            style: GoogleFonts.poppins(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // ── Breed List ───────────────────────────────────────────────
              breeds.isEmpty
                  ? SliverFillRemaining(
                      hasScrollBody: false,
                      child: _EmptyState(
                        message: _showFavoritesOnly
                            ? t('no_favorites')
                            : t('no_breeds_found'),
                        subtitle: _showFavoritesOnly
                            ? t('add_to_favorites')
                            : null,
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final breed = breeds[index];
                            return _BreedCard(
                              breed: breed,
                              index: index,
                              isFavorite: lib.isFavorite(breed),
                              onFavoriteToggle: () =>
                                  lib.toggleFavorite(breed),
                              accentColor: isDog
                                  ? const Color(0xFFf6a623)
                                  : AppColors.primaryPurple,
                              onTap: () => Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (_, a1, a2) =>
                                      BreedDetailScreen(breed: breed),
                                  transitionsBuilder: (_, a1, a2, child) =>
                                      FadeTransition(
                                    opacity: a1,
                                    child: child,
                                  ),
                                ),
                              ),
                            );
                          },
                          childCount: breeds.length,
                        ),
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }
}

// ── Breed Card ──────────────────────────────────────────────────────────────
class _BreedCard extends StatelessWidget {
  final Breed breed;
  final int index;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;
  final Color accentColor;

  const _BreedCard({
    required this.breed,
    required this.index,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onTap,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + index * 60),
      curve: Curves.easeOutBack,
      builder: (context, value, child) => Transform.scale(
        scale: value,
        child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // ── Image ───────────────────────────────────────────────────
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                child: Image.asset(
                  breed.imageUrl,
                  width: 110,
                  height: 110,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 110,
                    height: 110,
                    color: Colors.grey[100],
                    child: const Icon(Icons.pets,
                        size: 40, color: Colors.grey),
                  ),
                ),
              ),

              // ── Info ─────────────────────────────────────────────────────
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name + favorite
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              breed.name,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          GestureDetector(
                            onTap: onFavoriteToggle,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              transitionBuilder: (child, anim) =>
                                  ScaleTransition(scale: anim, child: child),
                              child: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                key: ValueKey(isFavorite),
                                color: isFavorite
                                    ? Colors.red
                                    : Colors.grey[400],
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Origin
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              size: 13, color: accentColor),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              breed.origin,
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: Colors.grey[500],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Lifespan
                      Row(
                        children: [
                          Icon(Icons.timer_outlined,
                              size: 13, color: accentColor),
                          const SizedBox(width: 3),
                          Text(
                            breed.lifespan,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Characteristic chips (first 2)
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: breed.characteristics
                            .take(2)
                            .map(
                              (c) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: accentColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  c,
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: accentColor,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Empty State ─────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final String message;
  final String? subtitle;

  const _EmptyState({required this.message, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 72, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              message,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[400],
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.grey[400],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
