import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../themes/app_theme.dart';
import '../pages/home_page.dart';
import '../pages/favorites_page.dart';
import '../pages/login_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2C3E50),
              Color(0xFF000000),
            ],
          ),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 60, bottom: 20),
              child: Column(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primary.withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        )
                      ],
                    ),
                    child: Lottie.asset(
                      'assets/animations/pixel_palette_animations.json',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Pixel Palette",
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5
                    ),
                  ),
                  Text(
                    ">----Unal----<",
                    style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.5)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildModernTile(
                      context,
                      icon: Icons.home_rounded,
                      text: "Ana Sayfa",
                      onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage())),
                      isActive: true,
                    ),
                    const SizedBox(height: 10),
                    _buildModernTile(
                      context,
                      icon: Icons.favorite_rounded,
                      text: "Favorilerim",
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesPage()));
                      },
                      isActive: false,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Divider(color: Colors.white10),
                    ),
                    _buildModernTile(
                      context,
                      icon: Icons.settings_rounded,
                      text: "Ayarlar",
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Ayarlar sayfası yakında eklenecek! 🛠️")),
                        );
                      },
                      isActive: false,
                    ),
                    const SizedBox(height: 10),
                    _buildModernTile(
                      context,
                      icon: Icons.mail_outline_rounded,
                      text: "İletişim",
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("iletisim@pixelpalette.com")),
                        );
                      },
                      isActive: false,
                    ),
                    const SizedBox(height: 10),
                    _buildModernTile(
                      context,
                      icon: Icons.info_outline_rounded,
                      text: "Hakkında",
                      onTap: () {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: AppTheme.surface,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            title: const Center(
                                child: Text("Pixel Palette", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.05),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.palette, size: 40, color: AppTheme.primary),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  "Flutter ile geliştirilmiştir\nby Unal",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white70, fontSize: 16),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Kapat", style: TextStyle(color: AppTheme.primary)),
                              ),
                            ],
                          ),
                        );
                      },
                      isActive: false,
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
              child: _buildModernTile(
                context,
                icon: Icons.logout_rounded,
                text: "Çıkış Yap",
                color: Colors.redAccent,
                onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage())),
                isActive: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernTile(
      BuildContext context, {
        required IconData icon,
        required String text,
        required VoidCallback onTap,
        required bool isActive,
        Color? color,
      }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        splashColor: AppTheme.primary.withValues(alpha: 0.2),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          decoration: BoxDecoration(
            color: isActive
                ? AppTheme.primary.withValues(alpha: 0.15)
                : Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isActive ? AppTheme.primary.withValues(alpha: 0.5) : Colors.transparent,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: color ?? (isActive ? AppTheme.primary : Colors.white70),
                size: 24,
              ),
              const SizedBox(width: 15),
              Text(
                text,
                style: TextStyle(
                  color: color ?? (isActive ? Colors.white : Colors.white70),
                  fontSize: 16,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              const Spacer(),
              if (!isActive && color == null)
                Icon(Icons.arrow_forward_ios_rounded, color: Colors.white.withValues(alpha: 0.2), size: 12),
            ],
          ),
        ),
      ),
    );
  }
}