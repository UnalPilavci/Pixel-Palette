import 'package:flutter/material.dart';
import '../services/color_service.dart';
import '../components/color_tile.dart';
import '../themes/app_theme.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Color> _favoriteColors = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }
  void _loadFavorites() {
    setState(() {
      _favoriteColors = ColorService.favoriteColors;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1A2530),
                  Color(0xFF000000),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Favorilerim",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          Text(
                            "Kaydettiğin renkler",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                      boxShadow: [
                        BoxShadow(color: Colors.black45, blurRadius: 20, offset: Offset(0, -5))
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 15, bottom: 10),
                          width: 50,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Expanded(
                          child: _favoriteColors.isEmpty
                              ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(30),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.05),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.favorite_border_rounded, size: 60, color: Colors.white.withValues(alpha: 0.2)),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  "Henüz favori rengin yok.",
                                  style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 16),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Renk keşfetmeye başla", style: TextStyle(color: AppTheme.primary)),
                                )
                              ],
                            ),
                          )
                              : ListView.builder(
                            padding: const EdgeInsets.only(top: 10, bottom: 20),
                            itemCount: _favoriteColors.length,
                            itemBuilder: (context, index) {
                              final color = _favoriteColors[index];
                              return Dismissible(
                                key: Key(color.toString()),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 30),
                                  color: Colors.redAccent.withValues(alpha: 0.2),
                                  child: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 30),
                                ),
                                onDismissed: (direction) {
                                  setState(() {
                                    ColorService.toggleFavorite(color);
                                    _favoriteColors.removeAt(index);
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Favorilerden kaldırıldı")),
                                  );
                                },
                                child: ColorTile(
                                  color: color,
                                  isFavorite: true,
                                  onFavoriteToggle: () {
                                    setState(() {
                                      ColorService.toggleFavorite(color);
                                      _loadFavorites();
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
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