import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../pages/home_page.dart';
import '../pages/register_page.dart';
import '../themes/app_theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isObscure = true;

  void _login() async {
    setState(() { _isLoading = true; });
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1A2530), Color(0xFF000000)],
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50,),
                    Container(
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: AppTheme.primary.withValues(alpha: 0.2), blurRadius: 30, spreadRadius: 5)],
                      ),
                      child: Lottie.asset('assets/animations/pixel_palette_animations_login_page.json', fit: BoxFit.contain),
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      "Pixel Palette",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.5),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                      ),
                      child: Column(
                        children: [
                          _buildModernTextField(
                            controller: _emailController,
                            hintText: "E-posta Adresi",
                            icon: Icons.email_outlined,
                          ),
                          const SizedBox(height: 16),
                          _buildModernTextField(
                            controller: _passwordController,
                            hintText: "Şifre",
                            icon: Icons.lock_outline,
                            isPassword: true,
                            isObscure: _isObscure,
                            onSuffixPressed: () => setState(() => _isObscure = !_isObscure),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Şifre sıfırlama bağlantısı e-postana gönderildi! 📧")),
                                );
                              },
                              child: Text("Şifremi Unuttum?", style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13)),
                            ),
                          ),

                          const SizedBox(height: 5),
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primary,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator(color: Colors.black)
                                  : const Text("Giriş Yap", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.2))),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text("veya şununla giriş yap", style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12)),
                        ),
                        Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.2))),
                      ],
                    ),

                    const SizedBox(height: 25),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialButton(
                          icon: Icons.g_mobiledata,
                          color: Colors.redAccent,
                          onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Google ile giriş yapılıyor..."))),
                        ),
                        const SizedBox(width: 35),
                        _buildSocialButton(
                          icon: Icons.apple,
                          color: Colors.white,
                          onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Apple ile giriş yapılıyor..."))),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Hesabın yok mu?", style: TextStyle(color: Colors.white.withValues(alpha: 0.6))),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
                          },
                          child: const Text("Hemen Kayıt Ol", style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildModernTextField({required TextEditingController controller, required String hintText, required IconData icon, bool isPassword = false, bool isObscure = false, VoidCallback? onSuffixPressed}) {
    return Container(
      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(16)),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? isObscure : false,
        style: const TextStyle(color: Colors.white),
        cursorColor: AppTheme.primary,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
          prefixIcon: Icon(icon, color: Colors.white.withValues(alpha: 0.6)),
          suffixIcon: isPassword ? IconButton(icon: Icon(isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.white.withValues(alpha: 0.6)), onPressed: onSuffixPressed) : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
      ),
    );
  }

  Widget _buildSocialButton({required IconData icon, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      splashColor: Colors.white.withValues(alpha: 0.3),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.15),
              Colors.white.withValues(alpha: 0.05),
            ],
          ),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 15,
              offset: const Offset(5, 5),
            ),
            BoxShadow(
              color: color.withValues(alpha: 0.2),
              blurRadius: 10,
              spreadRadius: -5,
            )
          ],
        ),
        child: Center(
          child: Icon(
            icon,
            color: color,
            size: 30,
            shadows: [
              Shadow(
                color: color.withValues(alpha: 0.5),
                blurRadius: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}